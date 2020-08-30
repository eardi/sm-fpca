/*
============================================================================================
   This class implements a quadtree.  It is used to partition a set of points (in 2-D)
   in order to facilitate fast searching operations.
   
   See this paper for some details on the traversal methods:
   S. F. Frisken and R. N. Perry,
   ``Simple and Efficient Traversal Methods for Quadtrees and Octrees,''
   Journal of Graphics Tools, 2002, Vol. 7, pg. 1-11
   
   Note: the numbering of the children of each cell is:

      y
      |     2   3
      +-x   0   1

   in binary:

      y
      |     10  11
      +-x   00  01

   Copyright (c) 01-14-2014,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* Quadtree cell.  Note that the locational codes and the cell level are only
   used in neighbor searching; they are not necessary for point or region location. */
struct trCell
{
    pt_type  lb_v[2]; // left  - bottom corner coordinates
    pt_type  rt_v[2]; // right - top    corner coordinates
    UINT_type  xLocCode;    // X locational code
    UINT_type  yLocCode;    // Y locational code
    UINT_type  level;       // Cell level in hierarchy (smallest cell has level 0)

    trCell*                 parent;   // Pointer to parent cell
    trCell*                 child[4]; // Pointers to child cells
                                      // Note: either all children exist or NONE exist.
    std::vector<UINT_type>  pt_indices; // indices of points in global array that are
                                        // contained in this cell (if it is a leaf).
};
/***************************************************************************************/

/***************************************************************************************/
/* C++ sub-class of basetree */
#define  TR  quadtree
class TR : public basetree
{
public:
    TR (); // constructor
    ~TR (); // DE-structor

    // point coordinates to partition into the tree
    MATLAB_Matrix_ReadOnly<pt_type,2> Points;

    // initializing
    void Get_Bounding_Box_From_Points(pt_type&, pt_type&, pt_type&, pt_type&);
    void Set_Bounding_Box_From_User(const pt_type&, const pt_type&, const pt_type&, const pt_type&,
                                    const mxArray*);
    void Set_Bounding_Box_DEFAULT(const pt_type&, const pt_type&, const pt_type&, const pt_type&);
    void Setup_Bucket_Size(const UINT_type);

    // create/destroy
    void Destroy_Tree();
    void Build_Tree();

    // updating
    void Update_Tree();
    void Check_Points_Against_Bounding_Box(MATLAB_Matrix_ReadOnly<pt_type,2>);
    void Tidy_Up_Tree();
    const UINT_type Get_Num_Points_In_Node(trCell*);

    // closest point
    void kNN_Search(MATLAB_Matrix_ReadOnly<pt_type,2>, MATLAB_Matrix_ReadWrite<UINT_type>,
                    MATLAB_Matrix_ReadWrite<pt_type>, const bool&);
    void Find_Closest_Point(const pt_type&, const pt_type&);
    void Find_Closest_In_Node(trCell*, const pt_type&, const pt_type&);
    void Find_Closest_In_Leaf(trCell*, const pt_type&, const pt_type&);

    // locating (searching)
    trCell* Locate_Cell(const pt_type&, const pt_type&);
    trCell* Locate_Region(const pt_type&, const pt_type&,
                          const pt_type&, const pt_type&);
    trCell* Locate_Left_Neighbor(trCell*);
    trCell* Locate_Right_Neighbor(trCell*);
    void Locate_RB_Vertex_Neighbors(trCell*, trCell*&, trCell*&, trCell*&);

    // displaying
    void Print_Tree();
    void Print_Tree(trCell*);
    void Print_Node_Info(trCell*);
    mxArray* Get_Tree_Data(const UINT_type&);

private:
    // big bounding box coordinates
    pt_type  box_lb[2]; // left-bottom corner of box
    pt_type  box_rt[2]; // right-top   corner of box
    // largest side length of bounding box.
    pt_type  box_size;
    // transformation from big bounding box to [0,1) x [0,1)
    pt_type  box_slope_x, box_slope_y;

    // refine/coarsen tree
    void init_node(trCell* n, trCell* p, const pt_type LL[2], const pt_type UR[2]);
    void delete_children(trCell*);
    void insert_points_into_node(trCell*);
    const UINT_type coarsen_node(trCell*);

    // updating tree
    void gather_exit_info();
    void gather_exit_info(trCell*);
    void gather_exit_info_sub(trCell*);
    void gather_exit_info_leaf(trCell*);
    void redistribute_exited_points();

    // displaying tree
    void print_sub_tree(trCell*);
    void print_leaf(trCell*);
    void get_num_nodes_in_tree(trCell*, const UINT_type&, UINT_type&);
    void collect_tree_data(mxArray*, trCell*, const UINT_type&, UINT_type&);

    // traversal
    inline void traverse(trCell*&, UINT_type&,
                         const UINT_type&, const UINT_type&);
    inline void traverse_to_level(trCell*&, UINT_type&,
                                  const UINT_type&, const UINT_type&,
                                  const UINT_type&);
    inline void get_common_ancestor(trCell*&, UINT_type&, const UINT_type&);

    // closest point
    inline pt_type compute_distance_squared(const pt_type&, const pt_type&,
                                            const pt_type&, const pt_type&);
    inline const unsigned int* optimal_child_order(trCell*, const pt_type&, const pt_type&);
    bool ball_outside_node(trCell*, const pt_type&, const pt_type&, const pt_type&);

    // helper
    void compute_transformation_factor();
    inline UINT_type x_pos_to_loc_code(const pt_type&);
    inline UINT_type y_pos_to_loc_code(const pt_type&);
};

/***************************************************************************************/
/* constructor */
TR::TR () : basetree()
{
    // init
    box_lb[0] = 0.0; box_lb[1] = 0.0;
    box_rt[0] = 1.0; box_rt[1] = 1.0;
    compute_transformation_factor();
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
TR::~TR ()
{
    // delete the tree
    Destroy_Tree();
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the default bounding box for the input points */
void TR::Get_Bounding_Box_From_Points(pt_type& Min_X, pt_type& Max_X,
                                      pt_type& Min_Y, pt_type& Max_Y)
{
    // Note: need to run:  Points.Setup_Data(mxPoints), before entering this routine

    // access point coordinates
    const pt_type* Point_X = Points.Get_Data_Col_Ptr(1);
    const pt_type* Point_Y = Points.Get_Data_Col_Ptr(2);
    Point_X = Point_X + 1; // put it back to C-style indexing
    Point_Y = Point_Y + 1; // put it back to C-style indexing
    const UINT_type Num_Points = (UINT_type) Points.Get_Num_Rows();

    // get min and max X and Y coordinates
    Min_X = *std::min_element(Point_X,Point_X + Num_Points);
    Max_X = *std::max_element(Point_X,Point_X + Num_Points);
    Min_Y = *std::min_element(Point_Y,Point_Y + Num_Points);
    Max_Y = *std::max_element(Point_Y,Point_Y + Num_Points);
}
/***************************************************************************************/


/***************************************************************************************/
/* set the bounding box based on user input */
void TR::Set_Bounding_Box_From_User(const pt_type& Pt_Min_X, const pt_type& Pt_Max_X,
                                    const pt_type& Pt_Min_Y, const pt_type& Pt_Max_Y,
                                    const mxArray* mxBoundingBox)
{
    // let the user set the bounding box
    const UINT_type Num_Row_BB = (UINT_type) mxGetM(mxBoundingBox);
    const UINT_type Num_Col_BB = (UINT_type) mxGetN(mxBoundingBox);
    if ( (Num_Row_BB != 1) || (Num_Col_BB != 4) )
        {
        mexPrintf("ERROR:\n");
        mexPrintf("Bounding box coordinates must be a 1x4 row vector!\n");
        mexPrintf("         It should look like this:  [Min_X, Max_X, Min_Y, Max_Y].\n");
        mexErrMsgTxt("STOP\n");
        }
    // pointer to data
    pt_type* BB = (pt_type*) mxGetPr(mxBoundingBox);
    const pt_type User_Min_X = BB[0];
    const pt_type User_Max_X = BB[1];
    const pt_type User_Min_Y = BB[2];
    const pt_type User_Max_Y = BB[3];

    if ( (User_Min_X > Pt_Min_X) || (User_Max_X < Pt_Max_X) ||
         (User_Min_Y > Pt_Min_Y) || (User_Max_Y < Pt_Max_Y) )
        {
        mexPrintf("ERROR:\n");
        mexPrintf("The user's box *cannot* contain the points!\n");
        mexPrintf("The bounding box of the user is:\n");
        mexPrintf("       (Min_X, Max_X)  =  (%1.15f, %1.15f)\n",User_Min_X,User_Max_X);
        mexPrintf("       (Min_Y, Max_Y)  =  (%1.15f, %1.15f)\n",User_Min_Y,User_Max_Y);
        mexPrintf("The bounding box of the *points* is:\n");
        mexPrintf("       (Min_X, Max_X)  =  (%1.15f, %1.15f)\n",Pt_Min_X,Pt_Max_X);
        mexPrintf("       (Min_Y, Max_Y)  =  (%1.15f, %1.15f)\n",Pt_Min_Y,Pt_Max_Y);
        mexPrintf("The user's box must contain the points!\n");
        mexErrMsgTxt("STOP\n");
        }

    // set bounding box coordinates from user
    box_lb[0] = User_Min_X;  box_lb[1] = User_Min_Y;
    box_rt[0] = User_Max_X;  box_rt[1] = User_Max_Y;

    compute_transformation_factor();
}
/***************************************************************************************/


/***************************************************************************************/
/* set the bounding box based on user input */
void TR::Set_Bounding_Box_DEFAULT(const pt_type& Pt_Min_X, const pt_type& Pt_Max_X,
                                  const pt_type& Pt_Min_Y, const pt_type& Pt_Max_Y)
{
    // get box size
    const pt_type X_Diff = (Pt_Max_X - Pt_Min_X);
    const pt_type Y_Diff = (Pt_Max_Y - Pt_Min_Y);

    // set bounding box coordinates to be slightly larger
    box_lb[0] = Pt_Min_X - (0.001*X_Diff);  box_lb[1] = Pt_Min_Y - (0.001*Y_Diff);
    box_rt[0] = Pt_Max_X + (0.001*X_Diff);  box_rt[1] = Pt_Max_Y + (0.001*Y_Diff);

    compute_transformation_factor();
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the multiplicative factor for transforming points to [0,1) x [0,1). */
void TR::compute_transformation_factor()
{
    const pt_type size_X = box_rt[0] - box_lb[0];
    const pt_type size_Y = box_rt[1] - box_lb[1];
	if ( (size_X <= 0) || (size_Y <= 0) )
		{
        mexPrintf("ERROR:\n");
        mexPrintf("The bounding box has zero (or negative) volume!\n");
        mexPrintf("The bounding box is defined by:\n");
        mexPrintf("       (Min_X, Max_X)  =  (%1.15f, %1.15f)\n",box_lb[0],box_rt[0]);
        mexPrintf("       (Min_Y, Max_Y)  =  (%1.15f, %1.15f)\n",box_lb[1],box_rt[1]);
        mexPrintf("Check your inputs!\n");
        mexErrMsgTxt("STOP\n");
		}
    box_size = std::max(size_X,size_Y);

    // pre-compute transformation rule
    box_slope_x = 1.0 / size_X;
    box_slope_y = 1.0 / size_Y;
}
/***************************************************************************************/


/***************************************************************************************/
/* setup bucket size */
void TR::Setup_Bucket_Size(const UINT_type bucket)
{
    bucket_size = bucket;
    if (bucket_size < 1)
        mexErrMsgTxt("Bucket size must be at least 1! (recommended size = ~20.)\n");
}
/***************************************************************************************/


/***************************************************************************************/
/* destroy! */
void TR::Destroy_Tree()
{
    delete_children(root);
    delete(root);
    root = NULL; // always set a pointer to NULL after you delete the object!
}
/***************************************************************************************/


/***************************************************************************************/
/* initialize the various parts of the node; parent is the direct ancestor of node;
   see also the sister routine: delete_children. */
void TR::init_node(trCell* node,        trCell* parent,
                   const pt_type LL[2], const pt_type UR[2])
{
    node->lb_v[0] = LL[0];
    node->lb_v[1] = LL[1];
    node->rt_v[0] = UR[0];
    node->rt_v[1] = UR[1];
    node->xLocCode = x_pos_to_loc_code(LL[0]);
    node->yLocCode = y_pos_to_loc_code(LL[1]);
    if (parent==NULL)
        node->level = tr_root_level;
    else
        node->level = parent->level - 1;
    node->parent    = parent;
    node->child[0]  = NULL;
    node->child[1]  = NULL;
    node->child[2]  = NULL;
    node->child[3]  = NULL;
    node->pt_indices.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* delete all children of this node (and their descendants).
   see also the sister routine: init_node.   */
void TR::delete_children(trCell* node)
{
    if(node!=NULL)
        {
        delete_children(node->child[0]);
        delete(node->child[0]);
        node->child[0] = NULL; // you must do this!
                               // this indicates that the child no longer exists!
        delete_children(node->child[1]);
        delete(node->child[1]);
        node->child[1] = NULL;

        delete_children(node->child[2]);
        delete(node->child[2]);
        node->child[2] = NULL;

        delete_children(node->child[3]);
        delete(node->child[3]);
        node->child[3] = NULL;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* build the tree from the internal point list */
void TR::Build_Tree()
{
    Destroy_Tree(); // clear it!
    // re-init
    root = new trCell;
    init_node(root, NULL, box_lb, box_rt);

    // put all of the points in the root
    const UINT_type Num_Points = (UINT_type) Points.Get_Num_Rows();
    root->pt_indices.reserve(Num_Points);
    for (UINT_type ii = 1; ii <= Num_Points; ii++) // MATLAB style indexing
        root->pt_indices.push_back(ii);

    // recurse until all points are distributed to leafs that respect the bucket_size
    insert_points_into_node(root);
}
/***************************************************************************************/


/***************************************************************************************/
/* This takes the points in node->pt_indices and does one of the following:
    (1) if the number of points fit into the "bucket size",
           then it leaves the points as is (i.e. the bucket is *not* over-filled).
    else
    (2) it splits the node into 4, deposits the points accordingly, and recurses...

    Note: this expects node->pt_indices to already be initialized!
          Moreover, it assumes node->pt_indices are actually contained in the
          bounding box of the node. */
void TR::insert_points_into_node(trCell* node)
{
    // only split the node if there are too many points AND
    //     we have *not* reached the bottom level yet.
    const UINT_type Num_Points = (UINT_type) node->pt_indices.size();
    const bool SPLIT_NODE = ( (Num_Points > bucket_size) && (node->level > 0) );

    if (SPLIT_NODE)
        {
        /* set the children of the root node */

        // compute coordinate shifts
        const pt_type x_half = 0.5 * (node->rt_v[0] + node->lb_v[0]);
        const pt_type y_half = 0.5 * (node->rt_v[1] + node->lb_v[1]);

        if (node->child[0]!=NULL)
            {
            mexPrintf("This should NOT happen!\n");
            mexErrMsgTxt("STOP!");
            }

        // child #0
        node->child[0] = new trCell;
        const pt_type center[2] = {x_half, y_half};
        init_node(node->child[0], node, node->lb_v, center);
        // child #1
        node->child[1] = new trCell;
        const pt_type child_1_ll[2] = {x_half, node->lb_v[1]};
        const pt_type child_1_ur[2] = {node->rt_v[0], y_half};
        init_node(node->child[1], node, child_1_ll, child_1_ur);
        // child #2
        node->child[2] = new trCell;
        const pt_type child_2_ll[2] = {node->lb_v[0], y_half};
        const pt_type child_2_ur[2] = {x_half, node->rt_v[1]};
        init_node(node->child[2], node, child_2_ll, child_2_ur);
        // child #3
        node->child[3] = new trCell;
        init_node(node->child[3], node, center, node->rt_v);

        // reserve memory for the pt_indices
        const UINT_type estimated_Num_Points = (UINT_type) ( (Num_Points / 3) + 1 );
        node->child[0]->pt_indices.reserve(estimated_Num_Points);
        node->child[1]->pt_indices.reserve(estimated_Num_Points);
        node->child[2]->pt_indices.reserve(estimated_Num_Points);
        node->child[3]->pt_indices.reserve(estimated_Num_Points);

        // partition point indices
        std::vector<UINT_type>::iterator it;
        for (it = node->pt_indices.begin(); it != node->pt_indices.end(); ++it)
            {
            const UINT_type pt_index = *it;
            pt_type pt_coord[2];
            Points.Read(pt_index, pt_coord);

            // find which quadrant the point falls into and push it into that quadrant
            // Note: recall the ordering of the quadrants at the beginning of this file.
            const unsigned int ci = 2 * (pt_coord[1] >= center[1]) + (pt_coord[0] >= center[0]);
            node->child[ci]->pt_indices.push_back(pt_index);

            // Note: we do *not* perform other checks to make sure the point is inside
            //       a quadrant.  Thus, it is imperative that the bounding box strictly
            //       contain all of the points.
            }
        // clear the node->pt_indices because we moved the points to the children
        node->pt_indices.clear();
        node->pt_indices.reserve(0);

        // error check (see later)
        const UINT_type N0 = (UINT_type) node->child[0]->pt_indices.size();
        const UINT_type N1 = (UINT_type) node->child[1]->pt_indices.size();
        const UINT_type N2 = (UINT_type) node->child[2]->pt_indices.size();
        const UINT_type N3 = (UINT_type) node->child[3]->pt_indices.size();
        const UINT_type num_pts_partitioned = N0 + N1 + N2 + N3;

        // if child #0 does not contain any points, then make sure it has NO children
        if (N0==0)
            delete_children(node->child[0]);
        else
            insert_points_into_node(node->child[0]);
        // if child #1 does not contain any points, then make sure it has NO children
        if (N1==0)
            delete_children(node->child[1]);
        else
            insert_points_into_node(node->child[1]);
        // if child #2 does not contain any points, then make sure it has NO children
        if (N2==0)
            delete_children(node->child[2]);
        else
            insert_points_into_node(node->child[2]);
        // if child #3 does not contain any points, then make sure it has NO children
        if (N3==0)
            delete_children(node->child[3]);
        else
            insert_points_into_node(node->child[3]);

        if (num_pts_partitioned!=Num_Points)
            {
            mexPrintf("Number of points partitioned  = %d.\n",num_pts_partitioned);
            mexPrintf("Number of points in this cell = %d.\n",Num_Points);
            mexErrMsgTxt("These numbers should be the same!\n");
            }
        }
    else // the node must hold all of the points
        {
        // don't bother sorting... not needed!
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Update the tree structure (if the points have changed their coordinates). */
void TR::Update_Tree()
{
    // collect all information about points that have exited their
    //         former enclosing cells
    gather_exit_info();

    // redistribute the points into the tree (and split nodes if necessary)
    redistribute_exited_points();

    // cleanup any empty (or under-filled) leafs that are remaining in the tree
    Tidy_Up_Tree();

    // clear this stuff (not needed anymore)
    exited_point.clear();
    exited_point.reserve(0);
}
/***************************************************************************************/


/***************************************************************************************/
/* Gather all information about points that have exited their enclosing cell for the
   entire tree. */
void TR::gather_exit_info()
{
    // init vector to contain exited points
    exited_point.clear();
    const UINT_type Num_Points = (UINT_type) Points.Get_Num_Rows();
    // assume only 20% of the points have changed
    const UINT_type estimated_pts = (UINT_type) (0.2 * Num_Points + 100);
    exited_point.reserve(estimated_pts);

    // examine the entire tree
    gather_exit_info(root);
}
/***************************************************************************************/


/***************************************************************************************/
/* Gather all information about points that have exited their enclosing cell for the
   given node. */
void TR::gather_exit_info(trCell* node)
{
    gather_exit_info_sub(node);
}
/***************************************************************************************/


/***************************************************************************************/
/* Gather all information about points that have exited their enclosing cell for the
   given node. Basically, we are just preforming a recursive traversal of the entire
   sub-tree at this node. */
void TR::gather_exit_info_sub(trCell* node)
{
    if(node!=NULL) // if the node exists
        {
        if (!node->pt_indices.empty()) // if this node contains actual indices
            gather_exit_info_leaf(node);
        else
            {
            // descend to the children
            gather_exit_info_sub(node->child[0]);
            gather_exit_info_sub(node->child[1]);
            gather_exit_info_sub(node->child[2]);
            gather_exit_info_sub(node->child[3]);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Gather information about points that have exited this leaf, i.e. for points that
   do not lie in the leaf's bounding box. */
void TR::gather_exit_info_leaf(trCell* leaf)
{
    // copy over
    std::vector<UINT_type> temp_indices = leaf->pt_indices;
    leaf->pt_indices.clear(); // clear this now.  It may get filled up again below.

    // bounding box of the leaf
    const pt_type Min_X = leaf->lb_v[0];
    const pt_type Min_Y = leaf->lb_v[1];
    const pt_type Max_X = leaf->rt_v[0];
    const pt_type Max_Y = leaf->rt_v[1];

    // check each point in the leaf
    std::vector<UINT_type>::iterator it;
    for (it = temp_indices.begin(); it != temp_indices.end(); ++it)
        {
        // get the point's coordinates
        const UINT_type pt_index = *it;
        pt_type pt_coord[2];
        Points.Read(pt_index, pt_coord);

        // if it is in the bounding box of the leaf
        if ( in_interval(pt_coord[0], Min_X, Max_X) &&
             in_interval(pt_coord[1], Min_Y, Max_Y) )
            leaf->pt_indices.push_back(pt_index); // put it back in the leaf
        else // it has exited!
            {
            ExitPoint EP;
            EP.new_node = Locate_Cell(pt_coord[0], pt_coord[1]);
            EP.pt_index = pt_index;
            exited_point.push_back(EP); // store it

            // make sure point is actually *in* the cell's bounding box!
            const pt_type NN_Min_X = EP.new_node->lb_v[0];
            const pt_type NN_Min_Y = EP.new_node->lb_v[1];
            const pt_type NN_Max_X = EP.new_node->rt_v[0];
            const pt_type NN_Max_Y = EP.new_node->rt_v[1];
            if (!( in_interval(pt_coord[0], NN_Min_X, NN_Max_X) &&
                   in_interval(pt_coord[1], NN_Min_Y, NN_Max_Y) ) )
                {
                mexPrintf("ERROR: this point is not in the following cell:\n");
                mexPrintf("       (X,Y) = (%1.15f, %1.15f)\n\n",pt_coord[0],pt_coord[1]);
                mexPrintf("Cell Info:\n");
                Print_Node_Info(EP.new_node);
                mexPrintf("\n");
                mexPrintf("SUGGESTION:\n");
                mexPrintf("   Note the level of the cell.  If it is 0, then you probably\n");
                mexPrintf("   got this error because you specified the max number of\n");
                mexPrintf("   tree levels *too small*.  When you first create the tree,\n");
                mexPrintf("   try setting a large value for Max_Levels (<= 32).\n");
                mexErrMsgTxt("STOP!");
                }
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Re-distribute all points that exited their cells to the correct leafs in the
   current tree structure. */
void TR::redistribute_exited_points()
{
    // sort the exited points by their enclosing cell,
    //    so we can modify each cell *at once*
    std::sort(exited_point.begin(), exited_point.end(), order_by_cell);
    // add a delimiter
    ExitPoint DL;
    DL.new_node = NULL;
    DL.pt_index = 0;
    exited_point.push_back(DL);

    // temp vector of pt_indices (in a single cell)
    std::vector<UINT_type> temp_pts;
    temp_pts.clear();
    const UINT_type estimated_pts = (UINT_type) (20 * bucket_size + 20);
    temp_pts.reserve(estimated_pts);

    // init
    std::vector<ExitPoint>::iterator it;
    trCell* prev_cell = exited_point.front().new_node; // init
    // now loop through the points and re-distribute
    for (it = exited_point.begin(); it != exited_point.end(); ++it)
        {
        const ExitPoint EP = *it;
              trCell*   current_cell = EP.new_node;
        const UINT_type current_ind  = EP.pt_index;

        // if we are still in the same cell
        if (current_cell==prev_cell)
            // collect all points that have moved to the same cell
            temp_pts.push_back(current_ind);
        else // we have switched to a new cell
            {
            // the points should be located in a terminal node (without children)
            if (prev_cell->child[0]!=NULL)
                {
                mexPrintf("This cell should not have children!\n\n");
                Print_Tree(prev_cell);
                mexErrMsgTxt("STOP\n");
                }

            // add the points we have found to the END of
            //     the list of points in the previous cell we were looking at
            prev_cell->pt_indices.insert(prev_cell->pt_indices.end(),
                                         temp_pts.begin(), temp_pts.end());
            // distribute points into that cell
            insert_points_into_node(prev_cell);

            // clear the list and start collecting a new set of points
            temp_pts.clear();
            temp_pts.push_back(current_ind);

            // update the previous cell
            prev_cell = current_cell;
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* This cleans up any under-filled descendants in the tree. */
void TR::Tidy_Up_Tree()
{
    const UINT_type Coarse_TOTAL  = coarsen_node(root);
    const UINT_type Num_Points    = Points.Get_Num_Rows();
    if (Coarse_TOTAL != Num_Points)
        {
        mexPrintf("The total number of points is %d.\n",Num_Points);
        mexPrintf("But the number of points in the coarsened tree is %d.\n",Coarse_TOTAL);
        mexErrMsgTxt("This should *not* happen!\n");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* This traverses the node and coarsens any empty or under-filled descendants. */
const UINT_type TR::coarsen_node(trCell* node)
{
    if (node==NULL)
        return 0;
    else // the node exists
        {
        // if no children exist
        if (node->child[0]==NULL)
            {
            const UINT_type NP = (UINT_type) node->pt_indices.size();
            return NP;
            }
        else
            {
            // descend to the children
            const UINT_type N0 = coarsen_node(node->child[0]);
            const UINT_type N1 = coarsen_node(node->child[1]);
            const UINT_type N2 = coarsen_node(node->child[2]);
            const UINT_type N3 = coarsen_node(node->child[3]);
            const UINT_type total = N0 + N1 + N2 + N3;
            // if the total <= bucket_size, then we can coarsen this node
            if (total <= bucket_size)
                {
                /* collapse children to parent */

                // init parent vector
                node->pt_indices.clear();
                node->pt_indices.reserve(total);

                // copy points from children
                node->pt_indices.insert(node->pt_indices.end(),
                                        node->child[0]->pt_indices.begin(),
                                        node->child[0]->pt_indices.end());
                node->pt_indices.insert(node->pt_indices.end(),
                                        node->child[1]->pt_indices.begin(),
                                        node->child[1]->pt_indices.end());
                node->pt_indices.insert(node->pt_indices.end(),
                                        node->child[2]->pt_indices.begin(),
                                        node->child[2]->pt_indices.end());
                node->pt_indices.insert(node->pt_indices.end(),
                                        node->child[3]->pt_indices.begin(),
                                        node->child[3]->pt_indices.end());
                delete_children(node);
                }
            return total;
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* This returns the total number of points contained in the bounding box of the
   given node (i.e. this searches all the children and tallys up the points).  */
const UINT_type TR::Get_Num_Points_In_Node(trCell* node)
{
    if (node==NULL)
        return 0;
    else // the node exists
        {
        // if no children exist
        if (node->child[0]==NULL)
            {
            const UINT_type NP = (UINT_type) node->pt_indices.size();
            return NP;
            }
        else
            {
            // descend to the children
            const UINT_type N0 = Get_Num_Points_In_Node(node->child[0]);
            const UINT_type N1 = Get_Num_Points_In_Node(node->child[1]);
            const UINT_type N2 = Get_Num_Points_In_Node(node->child[2]);
            const UINT_type N3 = Get_Num_Points_In_Node(node->child[3]);
            return (N0 + N1 + N2 + N3);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* This returns the total number of nodes in the tree >= the given level. */
void TR::get_num_nodes_in_tree(trCell* node, const UINT_type& level, UINT_type& total)
{
    if (node==NULL)
        return;
    else // the node exists
        {
        if (node->level >= level)
            total++; // increment the count
        else
            return;

        // if no children exist
        if (node->child[0]==NULL)
            return;
        else
            {
            // descend to the children
            get_num_nodes_in_tree(node->child[0],level,total);
            get_num_nodes_in_tree(node->child[1],level,total);
            get_num_nodes_in_tree(node->child[2],level,total);
            get_num_nodes_in_tree(node->child[3],level,total);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* This records the tree data into the given MATLAB cell array for nodes with level >=
   the given level (i.e. we can filter out very small nodes). */
void TR::collect_tree_data(mxArray* mxData, trCell* node, const UINT_type& level, UINT_type& row)
{
    if (node==NULL)
        return;
    else // the node exists
        {
        if (node->level >= level)
            {
            // write node level data
            mwSize nsubs = 2;
            mwIndex subs[2] = {row, 0};
            mwIndex index = mxCalcSingleSubscript(mxData, nsubs, subs);
            mxArray* mxLevel = mxCreateNumericMatrix((mwSize) 1, (mwSize) 1, mxUINT32_CLASS, mxREAL);
            UINT_type* ptr_node_level = (UINT_type*) mxGetPr(mxLevel);
            *ptr_node_level = node->level;
            mxSetCell(mxData, index, mxLevel); // store it in the cell array

            // write bounding box coordinates
            subs[1] = 1;
            index = mxCalcSingleSubscript(mxData, nsubs, subs);
            mxArray* mxBox = mxCreateDoubleMatrix((mwSize) 1, (mwSize) 4, mxREAL);
            pt_type* ptr_box = (pt_type*) mxGetPr(mxBox);
            ptr_box[0] = node->lb_v[0]; // Min_X
            ptr_box[1] = node->rt_v[0]; // Max_X
            ptr_box[2] = node->lb_v[1]; // Min_Y
            ptr_box[3] = node->rt_v[1]; // Max_Y
            mxSetCell(mxData, index, mxBox); // store it in the cell array

            // write point indices (if there are any)
            if (!node->pt_indices.empty())
                {
                // write point index data
                subs[1] = 2;
                index = mxCalcSingleSubscript(mxData, nsubs, subs);
                mxArray* mxPts = mxCreateNumericMatrix((mwSize) node->pt_indices.size(),
                                                       (mwSize) 1, mxUINT32_CLASS, mxREAL);
                UINT_type* ptr_pts = (UINT_type*) mxGetPr(mxPts);
                for (UINT_type ii = 0; ii < node->pt_indices.size(); ii++)
                    {
                    ptr_pts[ii] = node->pt_indices[ii];
                    }
                mxSetCell(mxData, index, mxPts); // store it in the cell array
                }
            else
                {
                // do nothing?
                }
            row++; // increment the count
            }
        else
            return;

        // if no children exist
        if (node->child[0]==NULL)
            return;
        else
            {
            // descend to the children
            collect_tree_data(mxData,node->child[0],level,row);
            collect_tree_data(mxData,node->child[1],level,row);
            collect_tree_data(mxData,node->child[2],level,row);
            collect_tree_data(mxData,node->child[3],level,row);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Gather all of the data of the tree (into a MATLAB cell array) for use in plotting
   it in MATLAB. */
mxArray* TR::Get_Tree_Data(const UINT_type& level)
{
    UINT_type total = 0; // init
    get_num_nodes_in_tree(root,level,total);

    // allocate cell array
    const mwSize dims[2] = {total, 3};
    mxArray* mxData = mxCreateCellArray((mwSize) 2, dims);

    // fill the cell array
    UINT_type row = 0; // init
    collect_tree_data(mxData,root,level,row);

    return mxData;
}
/***************************************************************************************/


/***************************************************************************************/
/* print the tree info to the MATLAB display as ASCII text. */
void TR::Print_Tree()
{
    mexPrintf("Start from the ROOT Level:\n\n");

    print_count = 0;  // initialize (for error checking)
    Print_Tree(root);

    const UINT_type Num_Points = (UINT_type) Points.Get_Num_Rows();
    if (print_count!=Num_Points)
        {
        mexPrintf("Number of points printed: %d.\n",print_count);
        mexPrintf("Actual number of points: %d.\n",Num_Points);
        mexErrMsgTxt("Number of points printed out does not match the actual number of points!\n");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* print the tree info to the display */
void TR::Print_Tree(trCell* node)
{
    Print_Node_Info(node);
    print_sub_tree(node);
}
/***************************************************************************************/


/***************************************************************************************/
/* print info about the given node */
void TR::Print_Node_Info(trCell* node)
{
    if (node!=NULL)
        {
        mexPrintf("Level: %d   |  Side Dimensions:  %1.15f x %1.15f\n",node->level,
		                          node->rt_v[0] - node->lb_v[0],node->rt_v[1] - node->lb_v[1]);
        mexPrintf("Cell LL Corner: (%1.15f,%1.15f)\n",node->lb_v[0],node->lb_v[1]);
        mexPrintf("Cell UR Corner: (%1.15f,%1.15f)\n",node->rt_v[0],node->rt_v[1]);
        mexPrintf("Cell xLocCode:   %d\n",node->xLocCode);
        mexPrintf("Cell yLocCode:   %d\n",node->yLocCode);
        if (node->child[0]==NULL) // either ALL of the children exist, or ALL do not exist!
            mexPrintf("Cell has NO children.\n");
        else
            mexPrintf("Cell has children.\n");

        const UINT_type NP = Get_Num_Points_In_Node(node);
        mexPrintf("Cell contains %d points.\n",NP);
        mexPrintf("\n");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* print all of the leaf(s) of the tree */
void TR::print_sub_tree(trCell* node)
{
    if(node!=NULL) // if the node exists
        {
        if (!node->pt_indices.empty()) // if this node contains actual indices
            print_leaf(node);
        else
            {
            // descend to the children
            print_sub_tree(node->child[0]);
            print_sub_tree(node->child[1]);
            print_sub_tree(node->child[2]);
            print_sub_tree(node->child[3]);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* print end-leaf */
void TR::print_leaf(trCell* leaf)
{
    // print info about the containing leaf (cell)
    mexPrintf("Level: %d   |  Side Dimensions:  %1.15f x %1.15f\n",leaf->level,
		                          leaf->rt_v[0] - leaf->lb_v[0],leaf->rt_v[1] - leaf->lb_v[1]);
    mexPrintf("----Cell LL Corner: (%1.15f,%1.15f)----\n",leaf->lb_v[0],leaf->lb_v[1]);

    std::vector<UINT_type>::iterator it;
    for (it = leaf->pt_indices.begin(); it != leaf->pt_indices.end(); ++it)
        {
        const UINT_type pt_index = *it;
        pt_type pt_coord[2];
        Points.Read(pt_index, pt_coord);
        mexPrintf("index:  %d   coord:  %1.15f, %1.15f  \n",
                           pt_index,    pt_coord[0],    pt_coord[1]);
        print_count++; // keep track of the number of points that are printed out
        }

    mexPrintf("----Cell UR Corner: (%1.15f,%1.15f)----\n",leaf->rt_v[0],leaf->rt_v[1]);
    mexPrintf("\n");
}
/***************************************************************************************/

static const unsigned int Child_Order_0123[4] = {0, 1, 2, 3};
static const unsigned int Child_Order_0213[4] = {0, 2, 1, 3};
static const unsigned int Child_Order_1032[4] = {1, 0, 3, 2};
static const unsigned int Child_Order_1302[4] = {1, 3, 0, 2};
static const unsigned int Child_Order_2031[4] = {2, 0, 3, 1};
static const unsigned int Child_Order_2301[4] = {2, 3, 0, 1};
static const unsigned int Child_Order_3120[4] = {3, 1, 2, 0};
static const unsigned int Child_Order_3210[4] = {3, 2, 1, 0};
/***************************************************************************************/
/* Get optimal children order to traverse when finding the closest point, by following
   the x and y locational codes, xLocCode and yLocCode. Upon entering, cell is the
   specified cell to search for the closest point (typically, the root node). Upon
   termination, childOrder contains the integers 0, 1, 2, 3 in some order.
*/
inline const unsigned int* TR::optimal_child_order(trCell* cell, const pt_type& X,
                                                                 const pt_type& Y)
{
    const pt_type center_X = 0.5 * (cell->lb_v[0] + cell->rt_v[0]);
    const pt_type center_Y = 0.5 * (cell->lb_v[1] + cell->rt_v[1]);
    const unsigned int ChildZero = 2 * (Y >= center_Y) + (X >= center_X);
    const pt_type X_Diff = std::abs(X - center_X);
    const pt_type Y_Diff = std::abs(Y - center_Y);

    if (ChildZero==0)
        {
        if (X_Diff < Y_Diff)
            return Child_Order_0123; // 0 1 2 3
        else
            return Child_Order_0213; // 0 2 1 3
        }
    else if (ChildZero==1)
        {
        if (X_Diff < Y_Diff)
            return Child_Order_1032; // 1 0 3 2
        else
            return Child_Order_1302; // 1 3 0 2
        }
    else if (ChildZero==2)
        {
        if (X_Diff < Y_Diff)
            return Child_Order_2301; // 2 3 0 1
        else
            return Child_Order_2031; // 2 0 3 1
        }
    else //if (ChildZero==3)
        {
        if (X_Diff < Y_Diff)
            return Child_Order_3210; // 3 2 1 0
        else
            return Child_Order_3120; // 3 1 2 0
        }
}
// {
    // int nextLevel = cell->level - 1;

    // UINT_type childBranchBit = 1 << nextLevel;
    // UINT_type x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
    // UINT_type y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );
    // const unsigned int ChildZero = (unsigned int) (x_bit + y_bit);

    // if (ChildZero==0)
        // {
        // while (nextLevel >= 0)
            // {
            // childBranchBit = 1 << nextLevel;
            // x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
            // y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );
            // const UINT_type candidateIndex = x_bit + y_bit;

            // if (candidateIndex==1)
                // return Child_Order_0123; // 0 1 2 3
            // else if (candidateIndex==2)
                // return Child_Order_0213; // 0 2 1 3
            // }
        // // if last level is reached, then just pick an order...
        // return Child_Order_0213;
        // }
    // else if (ChildZero==1)
        // {
        // while (nextLevel >= 0)
            // {
            // childBranchBit = 1 << nextLevel;
            // x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
            // y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );
            // const UINT_type candidateIndex = x_bit + y_bit;

            // if (candidateIndex==0)
                // return Child_Order_1032; // 1 0 3 2
            // else if (candidateIndex==3)
                // return Child_Order_1302; // 1 3 0 2
            // }
        // // if last level is reached, then just pick an order...
        // return Child_Order_1302;
        // }
    // else if (ChildZero==2)
        // {
        // while (nextLevel >= 0)
            // {
            // childBranchBit = 1 << nextLevel;
            // x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
            // y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );
            // const UINT_type candidateIndex = x_bit + y_bit;

            // if (candidateIndex==0)
                // return Child_Order_2031; // 2 0 3 1
            // else if (candidateIndex==3)
                // return Child_Order_2301; // 2 3 0 1
            // }
        // // if last level is reached, then just pick an order...
        // return Child_Order_2301;
        // }
    // else if (ChildZero==3)
        // {
        // while (nextLevel >= 0)
            // {
            // childBranchBit = 1 << nextLevel;
            // x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
            // y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );
            // const UINT_type candidateIndex = x_bit + y_bit;

            // if (candidateIndex==1)
                // return Child_Order_3120; // 3 1 2 0
            // else if (candidateIndex==2)
                // return Child_Order_3210; // 3 2 1 0
            // }
        // // if last level is reached, then just pick an order...
        // return Child_Order_3210;
        // }
    // else
        // {
        // mexPrintf("This should never happen!\n");
        // return NULL;
        // }
// }
/***************************************************************************************/


/***************************************************************************************/
/* Traverse a quadtree from a specified cell (typically the root cell)
   to a leaf cell by following the x and y locational codes, xLocCode and
   yLocCode. Upon entering, cell is the specified cell and nextLevel is one less
   than the level of the specified cell. Upon termination, cell is the leaf cell
   and nextLevel is one less than the level of the leaf cell. */
inline void TR::traverse(trCell*& cell,                   UINT_type& nextLevel,
                         const UINT_type& xLocCode, const UINT_type& yLocCode)
{
    // while there are still children, keep traversing
    while (cell->child[0]!=NULL) // NOTE: if one child is NOT NULL, then all are NOT NULL
        {
        // const unsigned int childIndex = 2 * (Y >= cell->center[1]) +
                                            // (X >= cell->center[0]);
        const UINT_type childBranchBit = 1 << nextLevel;
        const UINT_type x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
        const UINT_type y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );

        const UINT_type childIndex = x_bit + y_bit;
        cell = cell->child[childIndex];
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Traverse a quadtree from a specified cell to an offspring cell by
   following the x and y locational codes, xLocCode and yLocCode. The offpring
   cell is either at a specified level or is a leaf cell if a leaf cell is
   reached before the specified level. Upon entering, cell is the specified
   cell and nextLevel is one less than the level of the specified cell. Upon
   termination, cell is the offspring cell and nextLevel is one less than the
   level of the offspring cell. */
inline void TR::traverse_to_level(trCell*& cell,                   UINT_type& nextLevel,
                                  const UINT_type& xLocCode, const UINT_type& yLocCode,
                                  const UINT_type& level)
{
    UINT_type n = nextLevel - level + 1;

    while (n--)
        {
        const UINT_type childBranchBit = 1 << nextLevel;
        const UINT_type x_bit = ( (xLocCode & childBranchBit) >> nextLevel);
        const UINT_type y_bit = ( (yLocCode & childBranchBit) >> (--nextLevel) );

        const UINT_type childIndex = x_bit + y_bit;
        cell = cell->child[childIndex];

        // if no more children, then stop!
        if (cell->child[0]==NULL) break;
        // NOTE: if any child does not exist, then they ALL do not exist
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Traverse a quadtree to a common ancestor of a specified cell
   and its neighbor, whose x or y locational code differs from the cell's
   corresponding x or y locational code by binaryDiff (determined by XOR'ing the
   appropriate pair of x or y locational codes). Upon entering, cell is the
   specified cell and cellLevel is the cell's level. Upon termination, cell is
   the common ancestor and cellLevel is the common ancestor's level. */
inline void TR::get_common_ancestor(trCell*& cell,  UINT_type& cellLevel,
                                    const UINT_type& binaryDiff)
{
    while ( (binaryDiff) & (1 << (cellLevel)) )
        {
        cell = cell->parent;
        cellLevel++;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* compute L^2 distance squared */
inline pt_type TR::compute_distance_squared(const pt_type& X0, const pt_type& Y0,
                                            const pt_type& X1, const pt_type& Y1)
{
    // compute distance (squared) between the points
    const pt_type  X_Diff = X0 - X1;
    const pt_type  Y_Diff = Y0 - Y1;
    return (X_Diff*X_Diff + Y_Diff*Y_Diff);
    // can use other metric possibly, i.e. L^\infty, L^1, ...
}
/***************************************************************************************/


/***************************************************************************************/
/* Given an array of points, check that they are contained in the bounding box. */
void TR::Check_Points_Against_Bounding_Box(MATLAB_Matrix_ReadOnly<pt_type,2> Input_Pts)
{
    // access point coordinates
    const pt_type* Point_X = Input_Pts.Get_Data_Col_Ptr(1);
    const pt_type* Point_Y = Input_Pts.Get_Data_Col_Ptr(2);
    Point_X = Point_X + 1; // put it back to C-style indexing
    Point_Y = Point_Y + 1; // put it back to C-style indexing
    const UINT_type Num_Points = (UINT_type) Input_Pts.Get_Num_Rows();

    // get min and max X and Y coordinates
    const pt_type Min_X = *std::min_element(Point_X,Point_X + Num_Points);
    const pt_type Max_X = *std::max_element(Point_X,Point_X + Num_Points);
    const pt_type Min_Y = *std::min_element(Point_Y,Point_Y + Num_Points);
    const pt_type Max_Y = *std::max_element(Point_Y,Point_Y + Num_Points);

    // do these points violate the bounding box?
    const bool INSIDE = ( (box_lb[0] <= Min_X) && (box_rt[0] > Max_X) &&
                          (box_lb[1] <= Min_Y) && (box_rt[1] > Max_Y) );
    if (!INSIDE)
        {
        mexPrintf("ERROR:\n");
        mexPrintf("The input points do not fit into the quadtree's bounding box!\n");
        mexPrintf("The bounding box of the quadtree is:\n");
        mexPrintf("       (Min_X, Max_X)  =  (%1.15f, %1.15f)\n",box_lb[0],box_rt[0]);
        mexPrintf("       (Min_Y, Max_Y)  =  (%1.15f, %1.15f)\n",box_lb[1],box_rt[1]);
        mexPrintf("The bounding box of the *input points* is:\n");
        mexPrintf("       (Min_X, Max_X)  =  (%1.15f, %1.15f)\n",Min_X,Max_X);
        mexPrintf("       (Min_Y, Max_Y)  =  (%1.15f, %1.15f)\n",Min_Y,Max_Y);
        mexPrintf("Your input points violate the bounding box of the quadtree!\n");
        mexErrMsgTxt("Make sure that your input points fit within the bounding box of the quadtree!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Given an array of points, for each point: find the k nearest neighbor points in
   the quadtree.  In addition, return the distances (if desired).
   Note: the given points must be in the bounding box. */
void TR::kNN_Search(MATLAB_Matrix_ReadOnly<pt_type,2>  Input_Pts,
                    MATLAB_Matrix_ReadWrite<UINT_type> Output_Indices,
                    MATLAB_Matrix_ReadWrite<pt_type>   Output_Dist,
                    const bool&                        RETURN_DIST)
{
    // first make sure points are in the bounding box
    Check_Points_Against_Bounding_Box(Input_Pts);

    // init
    const UINT_type Num_Points = Output_Indices.Get_Num_Rows();
    num_neighbors              = Output_Indices.Get_Num_Cols();

    // get direct pointers to Output_Indices' data (care must be used here!!!)
    std::vector<UINT_type*> OI;
    OI.reserve(num_neighbors);
    for (unsigned int kk = 1; kk <= num_neighbors; kk++) // MATLAB style
        OI.push_back(Output_Indices.Get_Data_Col_Ptr(kk));

    // init internal variable to store nearest neighbor info
    ind_dist.clear();
    ind_dist.reserve(num_neighbors + 3 * bucket_size); // make sure it is big enough to hold extra indices

    if (RETURN_DIST) // record the distances also
        {
        // get direct pointers to Output_Dist's data (care must be used here!!!)
        std::vector<pt_type*> OD;
        OD.reserve(num_neighbors);
        for (unsigned int kk = 1; kk <= num_neighbors; kk++) // MATLAB style
            OD.push_back(Output_Dist.Get_Data_Col_Ptr(kk));

        // loop through all of the points
        for (UINT_type ii = 1; ii <= Num_Points; ii++) // MATLAB style
            {
            // read the point coordinates
            pt_type input_coord[2];
            Input_Pts.Read(ii, input_coord);

            Find_Closest_Point(input_coord[0], input_coord[1]);

            // save the closest point index and the distance to the closest point
            for (unsigned int jj = 0; jj < ind_dist.size(); jj++)
                {
                OI[jj][ii] = ind_dist[jj].index;
                OD[jj][ii] = sqrt(ind_dist[jj].dist); // don't forget the square root
                }
            }
        }
    else // do not output distances
        {
        // loop through all of the points
        for (UINT_type ii = 1; ii <= Num_Points; ii++) // MATLAB style
            {
            // read the point coordinates
            pt_type input_coord[2];
            Input_Pts.Read(ii, input_coord);

            Find_Closest_Point(input_coord[0], input_coord[1]);

            // save the closest point index
            for (unsigned int jj = 0; jj < ind_dist.size(); jj++) // MATLAB style
                OI[jj][ii] = ind_dist[jj].index;
            }
        }

    ind_dist.clear(); // don't need this anymore
    ind_dist.reserve(0);
}
/***************************************************************************************/


/***************************************************************************************/
/* Given the point coordinates in (X,Y), find the closest point(s) in Points and return
   their indices and distances (squared) in ind_dist.
   Note: ind_dist[ii].dist is the squared distance between (X,Y) and
                                                   Points[ind_dist[ii].index].
   Note: the given point must be in the bounding box. */
void TR::Find_Closest_Point(const pt_type& X, const pt_type& Y)
{
    ind_dist.clear();
    // dummy value
    IndexDist  ID_INF;
    ID_INF.index = 0; // dummy value
    ID_INF.dist  = 2.01 * box_size * box_size; // this is definitely bigger than the SQUARED distance to the closest point
    ind_dist.assign(num_neighbors,ID_INF);

    // if the root happens to be a leaf (the simplest case)
    if (root->child[0]==NULL) // i.e. there are no children
        Find_Closest_In_Leaf(root,X,Y);
    else // descend to the children
        Find_Closest_In_Node(root,X,Y);
}
/***************************************************************************************/


/***************************************************************************************/
/* Find the closest point(s) in Points to the given point (X,Y) within the given node. */
void TR::Find_Closest_In_Node(trCell*  node, const pt_type&  X, const pt_type&  Y)
{
    //----Use the branching patterns of the locational codes from the node
    //----to choose an order for searching the children
    const unsigned int* childOrder = optimal_child_order(node,X,Y);

    for (unsigned int ii = 0; ii < 4; ii++)
        {
        trCell* NC = node->child[childOrder[ii]];

        const pt_type DD_sq = ind_dist.back().dist; // get the largest distance (i.e. the last element)
        const bool NO_INTERSECTION = ball_outside_node(NC,DD_sq,X,Y);
        if (NO_INTERSECTION)
            {
            // ignore this child (keep current known closest point)
            }
        else
            {
            // if NC has no children, then it must be a leaf
            if (NC->child[0]==NULL) // note: either all children exist or all do not exist
                Find_Closest_In_Leaf(NC,X,Y);
            else // descend to the node's children
                Find_Closest_In_Node(NC,X,Y);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* A circle of radius (squared) Rad_sq and center (X,Y) is given, and a cell of the
   tree is given.  This returns true/false if the circle intersects the cell. */
bool TR::ball_outside_node(trCell*     cell,   const pt_type& Rad_sq,
                           const pt_type& X,   const pt_type& Y)
{
    // find the closest point to the circle within the rectangle
    const pt_type closestX = clamp(X, cell->lb_v[0], cell->rt_v[0]);
    const pt_type closestY = clamp(Y, cell->lb_v[1], cell->rt_v[1]);

    // calculate the distance between the circle's center and this closest point
    const pt_type distanceSquared = compute_distance_squared(X,Y,closestX,closestY);

    // if the distance is > the circle's radius, then there is NO intersection
    return (distanceSquared > Rad_sq);
}
/***************************************************************************************/


/***************************************************************************************/
/* Given a leaf of the tree, a point (X,Y), and the *current* closest point(s) in
   ind_dist, this compares (X,Y) to all the points in the leaf and updates the
   closest points accordingly. */
void TR::Find_Closest_In_Leaf(trCell* leaf, const pt_type& X, const pt_type& Y)
{
    // check against all points in the leaf
    std::vector<UINT_type>::iterator it;

    for (it = leaf->pt_indices.begin(); it != leaf->pt_indices.end(); ++it)
        {
        // read the current point
        const UINT_type pt_ind = *it;
        pt_type pt_coord[2];
        Points.Read(pt_ind, pt_coord);

        // init struct
        IndexDist  id_0;
        id_0.index = pt_ind; // store it

        // compute distance to that point
        id_0.dist = compute_distance_squared(X,Y,pt_coord[0],pt_coord[1]);

        // put it at the end of the current list (for now...)
        ind_dist.push_back(id_0);
        }
    // now sort it (only need the first 1:num_neighbors sorted)
    std::partial_sort(ind_dist.begin(), ind_dist.begin()+num_neighbors, ind_dist.end(), order_by_dist);
    //std::sort(ind_dist.begin(), ind_dist.end(), order_by_dist);
    // drop everything past the last neighbor (if we have filled up past that)
    ind_dist.resize(num_neighbors);
}
/***************************************************************************************/


/***************************************************************************************/
/* Locate the leaf cell containing the specified point (x,y), where (x,y) lies in
   the big bounding box. */
trCell* TR::Locate_Cell(const pt_type& X, const pt_type& Y)
{
    const UINT_type xLocCode = x_pos_to_loc_code(X);
    const UINT_type yLocCode = y_pos_to_loc_code(Y);

    //----Follow the branching patterns of the locational codes from the root cell
    //----to locate the leaf cell containing (x,y)
    trCell* cell = root;
    UINT_type nextLevel = cell->level - 1;
    traverse(cell,nextLevel,xLocCode,yLocCode);
    return cell;
}
/***************************************************************************************/


/***************************************************************************************/
/* Locate the smallest cell that entirely contains a rectangular region defined
   by its left-bottom vertex (x0,y0) and its right-top vertex (x1,y1), where the
   vertices lie in the big bounding box.
   Note: this seems to also work: left-top     vertex (x0,y0),
                                  right-bottom vertex (x1,y1)    */
trCell* TR::Locate_Region(const pt_type& X0, const pt_type& Y0,
                          const pt_type& X1, const pt_type& Y1)
{
    const UINT_type x0LocCode = x_pos_to_loc_code(X0);
    const UINT_type y0LocCode = y_pos_to_loc_code(Y0);
    const UINT_type x1LocCode = x_pos_to_loc_code(X1);
    const UINT_type y1LocCode = y_pos_to_loc_code(Y1);

    //----Determine the XOR'ed pairs of locational codes of the region boundaries
    const UINT_type xDiff = x0LocCode ^ x1LocCode;
    const UINT_type yDiff = y0LocCode ^ y1LocCode;

    //----Determine the level of the smallest possible cell entirely containing
    //----the region
    UINT_type level    = tr_root_level;
    UINT_type minLevel = tr_root_level;

    while (!(xDiff & (1 << level)) && level) level--;

    while (!(yDiff & (1 << minLevel)) && (minLevel > level)) minLevel--;

    minLevel++;

    //----Follow the branching patterns of the locational codes of X0 from the
    //----root cell to the smallest cell entirely containing the region
    trCell* cell = root;
    level = cell->level - 1;
    traverse_to_level(cell,level,x0LocCode,y0LocCode,minLevel);

    return cell;
}
/***************************************************************************************/


/***************************************************************************************/
/* Locate the left edge neighbor of the same size or larger of a specified cell.
   A null pointer is returned if no such neighbor exists. */
trCell* TR::Locate_Left_Neighbor(trCell* cell)
{
    //----Get cell's x and y locational codes and the x locational code of the
    //----cell's smallest possible left neighbor
    const UINT_type xLocCode     = cell->xLocCode;
    const UINT_type yLocCode     = cell->yLocCode;
    const UINT_type xLeftLocCode = xLocCode - 0x00000001;

    //----No left neighbor if this is the left side of the quadtree
    if (xLocCode == 0)
        return NULL;
    else
        {
        //----Determine the smallest common ancestor of the cell and the cell's
        //----smallest possible left neighbor
        UINT_type cellLevel, nextLevel;
        const UINT_type diff = xLocCode ^ xLeftLocCode;
        trCell* pCell = cell;
        cellLevel = nextLevel = cell->level;
        get_common_ancestor(pCell,nextLevel,diff);

        //----Start from the smallest common ancestor and follow the branching
        //----patterns of the locational codes downward to the smallest left
        //----neighbor of size greater than or equal to cell
        nextLevel--;
        traverse_to_level(pCell,nextLevel,xLeftLocCode,yLocCode,cellLevel);
        return pCell;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Locate the right edge neighbor of the same size or larger of a specified cell.
   A null pointer is returned if no such neighbor exists. */
trCell* TR::Locate_Right_Neighbor(trCell* cell)
{
    const UINT_type binaryCellSize = 1 << cell->level;

    //----Get cell's x and y locational codes and the x locational code of the
    //----cell's right neighbors
    const UINT_type xLocCode      = cell->xLocCode;
    const UINT_type yLocCode      = cell->yLocCode;
    const UINT_type xRightLocCode = xLocCode + binaryCellSize;

    //----No right neighbor if this is the right side of the quadtree
    const UINT_type ROOT_compare = (1 << tr_root_level);
    if (xRightLocCode >= ROOT_compare)
        return NULL;
    else
        {
        //----Determine the smallest common ancestor of the cell and the cell's
        //----right neighbors
        UINT_type cellLevel, nextLevel;
        const UINT_type diff = xLocCode ^ xRightLocCode;
        trCell* pCell = cell;
        cellLevel = nextLevel = cell->level;
        get_common_ancestor(pCell,nextLevel,diff);

        //----Start from the smallest common ancestor and follow the branching
        //----patterns of the locational codes downward to the smallest right
        //----neighbor of size greater than or equal to cell
        nextLevel--;
        traverse_to_level(pCell,nextLevel,xRightLocCode,yLocCode,cellLevel);
        return pCell;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Locate the three leaf cell vertex neighbors touching the (right-bottom) vertex
   of a specified cell. bVtxNbr, rVtxNbr, and rbVtxNbr are set to null if the
   corresponding neighbor does not exist. */
void TR::Locate_RB_Vertex_Neighbors(trCell* cell, trCell*& bVtxNbr, trCell*& rVtxNbr, trCell*& rbVtxNbr)
{
    //----CellSize
    const UINT_type binCellSize = 1 << cell->level;

    //----Get cell's x and y locational codes and the x and y locational codes of
    //----the cell's right and bottom vertex neighbors
    const UINT_type xRightLocCode  = cell->xLocCode + binCellSize;
    const UINT_type xLocCode       = xRightLocCode - 0x00000001;
    const UINT_type yLocCode       = cell->yLocCode;
    const UINT_type yBottomLocCode = yLocCode - 0x00000001;
    UINT_type rightLevel, bottomLevel;
    UINT_type diff;
    trCell* commonRight;
    trCell* commonBottom;

    //----There are no right neighbors if this is the right side of the quadtree and
    //----no bottom neighbors if this is the bottom of the quadtree
    const UINT_type ROOT_compare = (1 << tr_root_level);
    const UINT_type noRight      = (xRightLocCode >= ROOT_compare) ? 1 : 0;
    const UINT_type noBottom     = (yLocCode == 0) ? 1 : 0;

    //----Determine the right leaf cell vertex neighbor
    if (noRight)
        rVtxNbr = NULL;
    else
        {
        //----Determine the smallest common ancestor of the cell and the cell's
        //----right neighbor. Save this right common ancestor and its level for
        //----determining the right-bottom vertex.
        UINT_type level = cell->level;
        diff = xLocCode ^ xRightLocCode;
        commonRight = cell;
        get_common_ancestor(commonRight,level,diff);
        rightLevel = level;
        //----Follow the branching patterns of the locational codes downward from
        //----the smallest common ancestor to the right leaf cell vertex neighbor
        rVtxNbr = commonRight;
        level--;
        traverse_to_level(rVtxNbr,level,xRightLocCode,cell->yLocCode,0);
        }

    //----Determine the bottom leaf cell vertex neighbor
    if (noBottom)
        bVtxNbr = NULL;
    else
        {
        //----Determine the smallest common ancestor of the cell and the cell's
        //----bottom neighbor. Save this bottom common ancestor and its level for
        //----determining the right-bottom vertex.
        UINT_type level = cell->level;
        diff = yLocCode ^ yBottomLocCode;
        commonBottom = cell;
        get_common_ancestor(commonBottom,level,diff);
        bottomLevel = level;
        //----Follow the branching patterns of the locational codes downward from
        //----the smallest common ancestor to the bottom leaf cell vertex neighbor
        bVtxNbr = commonBottom;
        level--;
        traverse_to_level(bVtxNbr,level,xLocCode,yBottomLocCode,0);
        }

    //----Determine the right-bottom leaf cell vertex neighbor
    if (noRight || noBottom)
        rbVtxNbr = NULL;
    else
        {
        //----Follow the branching patterns of the locational codes downward from
        //----the smallest common ancestor (the larger of the right common ancestor
        //----and the bottom common ancestor) to the right-bottom leaf cell vertex
        //----neighbor
        if (rightLevel >= bottomLevel)
            {
            rbVtxNbr = commonRight;
            rightLevel--;
            traverse_to_level(rbVtxNbr,rightLevel,xRightLocCode,yBottomLocCode,0);
            }
        else
            {
            rbVtxNbr = commonBottom;
            bottomLevel--;
            traverse_to_level(rbVtxNbr,bottomLevel,xRightLocCode,yBottomLocCode,0);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* convert position to integer location code. */
inline UINT_type TR::x_pos_to_loc_code(const pt_type& pos)
{
//----Determine the x and y locational codes of the point's position. Refer
//----to [King2001] for more efficient methods for converting floating point
//----numbers to integers.

    // map x coordinate to the interval [0,1)
    const pt_type x_pos = box_slope_x * (pos - box_lb[0]);
    if ( (x_pos < 0.0) || (x_pos >= 1.0) )
        {
        mexPrintf("ERROR:\n");
        mexPrintf("The given x-coordinate: %1.15f\n",pos);
        mexPrintf("    lies outside of the bounding box x-range: [%1.15f, %1.15f).\n",box_lb[0],box_rt[0]);
        mexErrMsgTxt("STOP!\n");
        }

    return my_trunc(x_pos * tr_max_val);
}
/***************************************************************************************/


/***************************************************************************************/
/* convert position to integer location code. */
inline UINT_type TR::y_pos_to_loc_code(const pt_type& pos)
{
//----Determine the x and y locational codes of the point's position. Refer
//----to [King2001] for more efficient methods for converting floating point
//----numbers to integers.

    // map y coordinate to the interval [0,1)
    const pt_type y_pos = box_slope_y * (pos - box_lb[1]);
    if ( (y_pos < 0.0) || (y_pos >= 1.0) )
        {
        mexPrintf("ERROR:\n");
        mexPrintf("The given y-coordinate: %1.15f\n",pos);
        mexPrintf("    lies outside of the bounding box y-range: [%1.15f, %1.15f).\n",box_lb[1],box_rt[1]);
        mexErrMsgTxt("STOP!\n");
        }

    return my_trunc(y_pos * tr_max_val);
}
/***************************************************************************************/

#undef  TR

/***/
