/*
============================================================================================
   This class accesses the mesh geometry data and computes the local transformation from
   the reference element to a `general' element in the mesh.
   
   Several things are computed, such as the gradient of the transformation and Jacobian,
   as well as many other ``custom items''.
   
   This code references the header files:
   
   matrix_vector_defn.h
   matrix_vector_ops.h
   geometric_computations.h
   

   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-06-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set mesh geometry data type name
#define MGC        CLASS_geom_Gamma_embedded_in_Gamma_restricted_to_Gamma
// set the type of map
#define MAP_type  "CG - lagrange_deg2_dim2"

// set the Global mesh topological dimension
#define GLOBAL_TD  2
// set the Subdomain topological dimension
#define SUB_TD  2
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  2
// set the (ambient) geometric dimension
#define GD  3
// set the number of quad points
#define NQ  19
// set the number of basis functions
#define NB  6
// set whether to access the local simplex (facet) orientation
#define ORIENT  false
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/* C++ (Specific) Mesh class definition */
class MGC: public Abstract_MESH_GEOMETRY_Class // derive from base class
{
public:
    /***************************************************************************************/
    // data structures containing information about the local mapping from a
    // reference simplex to the actual element in the mesh.
    // Note: this data is evaluated at several quadrature points.
    // local map evaluated at a quadrature point in reference element
    VEC_3x1 Map_PHI[NQ];
    // gradient of the transformation (matrix)
    MAT_3x2 Map_PHI_Grad[NQ];
    // metric tensor of the map
    MAT_2x2 Map_PHI_Metric[NQ];
    // determinant of the metric matrix
    SCALAR Map_Det_Metric[NQ];
    // inverse of determinant of Metric
    SCALAR Map_Inv_Det_Metric[NQ];
    // inverse of the Metric tensor
    MAT_2x2 Map_PHI_Inv_Metric[NQ];
    // determinant of the transformation (Jacobian)
    SCALAR Map_Det_Jac[NQ];
    // determinant of Jacobian multiplied by quadrature weight
    SCALAR Map_Det_Jac_w_Weight[NQ];
    // inverse of determinant of Jacobian
    SCALAR Map_Inv_Det_Jac[NQ];
    // the oriented normal vector of the manifold
    VEC_3x1 Map_Normal_Vector[NQ];
    // hessian of the transformation
    MAT_3x2x2 Map_PHI_Hess[NQ];
    // 2nd fundamental form of the map
    MAT_2x2 Map_PHI_2nd_Fund_Form[NQ];
    // total curvature of the manifold
    SCALAR Map_Total_Curvature[NQ];

    MGC (); // constructor
    ~MGC ();   // DE-structor
    void Setup_Mesh_Geometry(const mxArray*, const mxArray*, const mxArray*);
    void Compute_Local_Transformation();
    double Orientation[SUB_TD+1]; // mesh "facet" orientation direction for the current subdomain element
    // pointer to Domain class
    const CLASS_Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma*   Domain;

private:
    double*  Node_Value[GD];    // mesh node values
    int*     Elem_DoF[NB];      // element DoF list
    bool*    Elem_Orient[SUB_TD+1]; // element facet orientation
                                    // true  = face has an outward normal vector (+1)
                                    // false = face has an  inward normal vector (-1)

    void Get_Local_to_Global_DoFmap(const int&, int*);
    void Get_Local_Orientation(const int&);
    void Compute_Map_p1(const int&);
};
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* constructor */
MGC::MGC () : Abstract_MESH_GEOMETRY_Class ()
{
    Type      = (char*) MAP_type;
    Global_TopDim = GLOBAL_TD;
    Sub_TopDim    = SUB_TD;
    DoI_TopDim    = DOI_TD;
    GeoDim    = GD;
    Num_QP    = NQ;
    Num_Basis = NB;

    // init mesh information to NULL
    Num_Nodes = 0;
    Num_Elem  = 0;
    for (int gd_i = 0; (gd_i < GeoDim); gd_i++)
        Node_Value[gd_i] = NULL;
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = NULL;
    for (int o_i = 0; (o_i < (Sub_TopDim+1)); o_i++)
        {
        Orientation[o_i] = +1.0;
        Elem_Orient[o_i] = NULL;
        }

    // init everything to zero
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI_Grad[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Det_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Inv_Det_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI_Inv_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Det_Jac[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Det_Jac_w_Weight[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Inv_Det_Jac[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Normal_Vector[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI_Hess[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_PHI_2nd_Fund_Form[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Total_Curvature[qp_i].Set_To_Zero();
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* DE-structor */
MGC::~MGC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void MGC::Setup_Mesh_Geometry(const mxArray *Vtx,       // inputs
                              const mxArray *Elem,      // inputs
                              const mxArray *Orient)    // inputs
{
    // get the ambient geometric dimension
    int CHK_GeoDim = (int) mxGetN(Vtx);
    // get the number of vertices
    Num_Nodes = (int) mxGetM(Vtx);
    // get the number of elements
    Num_Elem  = (int) mxGetM(Elem);
    // get the number of basis functions for each element
    int CHK_Num_Basis = (int) mxGetN(Elem);
    // get the number of rows, columns in the orientation data
    int CHK_Num_Row_Orient = (int) mxGetM(Orient);
    int CHK_Num_Col_Orient = (int) mxGetN(Orient);

    /* BEGIN: Simple Error Checking */
    if (mxGetClassID(Elem)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Geometry DoFmap must be uint32!");
    if (CHK_GeoDim != GeoDim)
        {
        mexPrintf("ERROR: Vertex Coordinate List has %d columns; expected %d columns.\n", CHK_GeoDim, GeoDim);
        mexErrMsgTxt("ERROR: ambient geometric dimension must match!");
        }
    if (CHK_Num_Basis!=Num_Basis)
        {
        mexPrintf("ERROR: Mesh DoFmap has %d columns; expected %d columns.\n", CHK_Num_Basis, Num_Basis);
        mexPrintf("ERROR: A common reason for this error is you are using a finite element space\n");
        mexPrintf("ERROR:     to represent the mesh that is higher order than piecewise linear\n");
        mexPrintf("ERROR:     and you forgot to create a distinct DoFmap for that space.\n");
        mexPrintf("ERROR: You *cannot* just use the plain triangulation data!\n");
        mexPrintf("ERROR:     That only works for linear elements.\n");
        mexErrMsgTxt("ERROR: number of basis functions describing geometry must match!");
        }
    if (ORIENT) // if we should access orientation data, then make some checks
        {
        if (mxGetClassID(Orient)!=mxLOGICAL_CLASS) mexErrMsgTxt("ERROR: Mesh Orientation must be logical!");
        if (CHK_Num_Row_Orient!=Num_Elem)
            {
            mexPrintf("ERROR: Mesh Orientation has %d rows; expected %d rows.\n", CHK_Num_Row_Orient, Num_Elem);
            mexErrMsgTxt("ERROR: Orientation rows should match the Mesh DoFmap rows!");
            }
        if (CHK_Num_Col_Orient!=(Sub_TopDim+1))
            {
            mexPrintf("ERROR: Mesh Orientation has %d columns; expected %d columns.\n", CHK_Num_Col_Orient, (Sub_TopDim+1));
            mexErrMsgTxt("ERROR: Orientation cols should match the Mesh topological dimension + 1!");
            }
        }
    /* END: Simple Error Checking */


    // split up the columns of the node data
    Node_Value[0] = mxGetPr(Vtx);
    for (int gd_i = 1; (gd_i < GeoDim); gd_i++)
        Node_Value[gd_i] = Node_Value[gd_i-1] + Num_Nodes;

    // split up the columns of the element data
    Elem_DoF[0] = (int *) mxGetPr(Elem);
    for (int basis_i = 1; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = Elem_DoF[basis_i-1] + Num_Elem;

    // split up the columns of the element (facet) orientation data
    if (ORIENT)
        {
        Elem_Orient[0] = (bool *) mxGetPr(Orient);
        for (int o_i = 1; (o_i < (Sub_TopDim+1)); o_i++)
            Elem_Orient[o_i] = Elem_Orient[o_i-1] + Num_Elem;
        }

    // get maximum DoF present in Elem
    int Elem_Num_Nodes  = *std::max_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    int Min_DoF         = *std::min_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    if ((Min_DoF < 1) || (Elem_Num_Nodes < 1))
        {
        mexPrintf("ERROR: There are Mesh DoFs that have indices < 1!\n");
        mexPrintf("ERROR: There are problems with this Mesh Type = %s!\n",Type);
        mexErrMsgTxt("ERROR: Fix your Mesh DoFmap!");
        }
    if (Elem_Num_Nodes > Num_Nodes)
        {
        mexPrintf("ERROR: There are Mesh DoFs that have indices > number of Mesh Values!\n");
        mexPrintf("ERROR: There are problems with this Mesh Type = %s!\n",Type);
        mexErrMsgTxt("ERROR: Fix your Mesh Values or DoFmap!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the local DoFs on the given element */
void MGC::Get_Local_to_Global_DoFmap(const int& elem_index, int* Indices)  // inputs
{
    // get local to global indexing for geometry DoFmap
    for (int basis_i = 0; (basis_i < NB); basis_i++)
        {
        int DoF_index = Elem_DoF[basis_i][elem_index] - 1; // shifted for C - style indexing
        Indices[basis_i] = DoF_index;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the local orientation of the given element */
void MGC::Get_Local_Orientation(const int& elem_index)  // inputs
{
    // translate logical info to +/- 1.0
    for (int o_i = 0; (o_i < (SUB_TD+1)); o_i++)
        {
        const bool Orient_TF = Elem_Orient[o_i][elem_index];
        if (Orient_TF) Orientation[o_i] = +1.0;
        else           Orientation[o_i] = -1.0;
        }
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation based on the given mesh entity */
void MGC::Compute_Local_Transformation()
{
    // read in the embedding info
    const int Global_Cell_Index = Domain->Global_Cell_Index;

    // compute "facet" orientation directions of current simplex
    if (ORIENT)  Get_Local_Orientation(Global_Cell_Index);

    /* compute local map */

    Compute_Map_p1(Global_Cell_Index);
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_p1(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Intrinsic Map
// Local Map Element on Global mesh: CG, lagrange_deg2_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 2
// Map has geometric dimension = 3
// Number of Quadrature Points = 19

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {-1.11111111111111105E-01, -1.11111111111111105E-01, -1.11111111111111105E-01, 4.44444444444444420E-01, 4.44444444444444420E-01, 4.44444444444444420E-01}, \
    {-1.97833583218494161E-02, -1.01045799810935439E-02, -1.01045799810935439E-02, 9.59155878435288156E-01, 4.04183199243741756E-02, 4.04183199243741756E-02}, \
    {-1.01045799810935300E-02, -1.01045799810935439E-02, -1.97833583218494057E-02, 4.04183199243741478E-02, 4.04183199243741478E-02, 9.59155878435288156E-01}, \
    {-1.01045799810935300E-02, -1.97833583218494057E-02, -1.01045799810935439E-02, 4.04183199243741478E-02, 9.59155878435288156E-01, 4.04183199243741478E-02}, \
    {-9.41590610259220029E-02, -5.49949695100121830E-02, -5.49949695100121830E-02, 7.64189243965848863E-01, 2.19979878040048732E-01, 2.19979878040048732E-01}, \
    {-5.49949695100121830E-02, -5.49949695100121830E-02, -9.41590610259220029E-02, 2.19979878040048732E-01, 2.19979878040048732E-01, 7.64189243965848863E-01}, \
    {-5.49949695100121830E-02, -9.41590610259220029E-02, -5.49949695100121830E-02, 2.19979878040048732E-01, 7.64189243965848863E-01, 2.19979878040048732E-01}, \
    {1.54143352841839831E-01, -1.17362393980023683E-01, -1.17362393980023683E-01, 1.41682283278018073E-01, 4.69449575920094730E-01, 4.69449575920094730E-01}, \
    {-1.17362393980023669E-01, -1.17362393980023683E-01, 1.54143352841839915E-01, 4.69449575920094786E-01, 4.69449575920094619E-01, 1.41682283278018017E-01}, \
    {-1.17362393980023669E-01, 1.54143352841839915E-01, -1.17362393980023683E-01, 4.69449575920094786E-01, 1.41682283278018017E-01, 4.69449575920094619E-01}, \
    {7.47628754581319943E-01, -4.07280546574436617E-02, -4.07280546574436617E-02, 8.00291747401809909E-03, 1.62912218629774647E-01, 1.62912218629774647E-01}, \
    {-4.07280546574436270E-02, -4.07280546574436617E-02, 7.47628754581320054E-01, 1.62912218629774647E-01, 1.62912218629774508E-01, 8.00291747401809042E-03}, \
    {-4.07280546574436270E-02, 7.47628754581320054E-01, -4.07280546574436617E-02, 1.62912218629774647E-01, 8.00291747401809042E-03, 1.62912218629774508E-01}, \
    {3.57552126895708478E-01, -3.41242748493072040E-02, -1.23427852046401318E-01, 3.27070562224210035E-02, 6.58074626191913037E-01, 1.09218317585665983E-01}, \
    {3.57552126895708478E-01, -1.23427852046401318E-01, -3.41242748493072040E-02, 3.27070562224210035E-02, 1.09218317585665983E-01, 6.58074626191913037E-01}, \
    {-1.23427852046401318E-01, -3.41242748493072040E-02, 3.57552126895708478E-01, 1.09218317585665983E-01, 6.58074626191913037E-01, 3.27070562224210035E-02}, \
    {-1.23427852046401318E-01, 3.57552126895708478E-01, -3.41242748493072040E-02, 1.09218317585665983E-01, 3.27070562224210035E-02, 6.58074626191913037E-01}, \
    {-3.41242748493072040E-02, -1.23427852046401318E-01, 3.57552126895708478E-01, 6.58074626191913037E-01, 1.09218317585665983E-01, 3.27070562224210035E-02}, \
    {-3.41242748493072040E-02, 3.57552126895708478E-01, -1.23427852046401318E-01, 6.58074626191913037E-01, 3.27070562224210035E-02, 1.09218317585665983E-01}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-3.33333333333333315E-01, 0.00000000000000000E+00, 3.33333333333333315E-01, 1.33333333333333326E+00, 0.00000000000000000E+00, -1.33333333333333326E+00}, \
    {9.17460153589900962E-01, 0.00000000000000000E+00, 9.58730076794950481E-01, 1.95873007679495048E+00, -1.87619023038485144E+00, -1.95873007679495048E+00}, \
    {-9.58730076794950592E-01, 0.00000000000000000E+00, -9.17460153589900962E-01, 1.95873007679495048E+00, 1.87619023038485166E+00, -1.95873007679495048E+00}, \
    {-9.58730076794950592E-01, 0.00000000000000000E+00, 9.58730076794950481E-01, 8.25398464100989826E-02, 5.55111512312578270E-17, -8.25398464100989826E-02}, \
    {4.96716731943493084E-01, 0.00000000000000000E+00, 7.48358365971746542E-01, 1.74835836597174654E+00, -1.24507509791523963E+00, -1.74835836597174654E+00}, \
    {-7.48358365971746542E-01, 0.00000000000000000E+00, -4.96716731943493084E-01, 1.74835836597174654E+00, 1.24507509791523963E+00, -1.74835836597174654E+00}, \
    {-7.48358365971746542E-01, 0.00000000000000000E+00, 7.48358365971746542E-01, 5.03283268056506916E-01, 0.00000000000000000E+00, -5.03283268056506916E-01}, \
    {-1.49437171504773825E+00, 0.00000000000000000E+00, -2.47185857523869124E-01, 7.52814142476130876E-01, 1.74155757257160748E+00, -7.52814142476130876E-01}, \
    {2.47185857523869346E-01, 0.00000000000000000E+00, 1.49437171504773847E+00, 7.52814142476130876E-01, -1.74155757257160793E+00, -7.52814142476130876E-01}, \
    {2.47185857523869346E-01, 0.00000000000000000E+00, -2.47185857523869124E-01, 2.49437171504773847E+00, -2.22044604925031308E-16, -2.49437171504773847E+00}, \
    {-2.64216389284437847E+00, 0.00000000000000000E+00, -8.21081946422189124E-01, 1.78918053577810848E-01, 3.46324583926656748E+00, -1.78918053577810848E-01}, \
    {8.21081946422189346E-01, 0.00000000000000000E+00, 2.64216389284437847E+00, 1.78918053577810848E-01, -3.46324583926656793E+00, -1.78918053577810848E-01}, \
    {8.21081946422189346E-01, 0.00000000000000000E+00, -8.21081946422189124E-01, 3.64216389284437847E+00, -1.66533453693773481E-16, -3.64216389284437847E+00}, \
    {-1.96479439513799203E+00, 0.00000000000000000E+00, -1.12148043356937177E-01, 1.47353648218945144E-01, 2.07694243849492910E+00, -1.47353648218945144E-01}, \
    {-1.96479439513799203E+00, 0.00000000000000000E+00, -8.52646351781054856E-01, 8.87851956643062823E-01, 2.81744074691904700E+00, -8.87851956643062823E-01}, \
    {1.12148043356937177E-01, 0.00000000000000000E+00, 1.96479439513799203E+00, 1.47353648218945144E-01, -2.07694243849492910E+00, -1.47353648218945144E-01}, \
    {1.12148043356937177E-01, 0.00000000000000000E+00, -8.52646351781054856E-01, 2.96479439513799203E+00, 7.40498308424117679E-01, -2.96479439513799203E+00}, \
    {8.52646351781054856E-01, 0.00000000000000000E+00, 1.96479439513799203E+00, 8.87851956643062823E-01, -2.81744074691904700E+00, -8.87851956643062823E-01}, \
    {8.52646351781054856E-01, 0.00000000000000000E+00, -1.12148043356937177E-01, 2.96479439513799203E+00, -7.40498308424117679E-01, -2.96479439513799203E+00}  \
    };

    // Value of basis function, derivatives = [0  2  0], at quadrature points
    static const double Geo_Basis_Val_0_2_0[NQ][NB] = { \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-3.33333333333333315E-01, 3.33333333333333315E-01, 0.00000000000000000E+00, 1.33333333333333326E+00, -1.33333333333333326E+00, 0.00000000000000000E+00}, \
    {9.17460153589900962E-01, 9.58730076794950481E-01, 0.00000000000000000E+00, 1.95873007679495048E+00, -1.95873007679495048E+00, -1.87619023038485144E+00}, \
    {-9.58730076794950592E-01, 9.58730076794950481E-01, 0.00000000000000000E+00, 8.25398464100989826E-02, -8.25398464100989826E-02, 5.55111512312578270E-17}, \
    {-9.58730076794950592E-01, -9.17460153589900962E-01, 0.00000000000000000E+00, 1.95873007679495048E+00, -1.95873007679495048E+00, 1.87619023038485166E+00}, \
    {4.96716731943493084E-01, 7.48358365971746542E-01, 0.00000000000000000E+00, 1.74835836597174654E+00, -1.74835836597174654E+00, -1.24507509791523963E+00}, \
    {-7.48358365971746542E-01, 7.48358365971746542E-01, 0.00000000000000000E+00, 5.03283268056506916E-01, -5.03283268056506916E-01, 0.00000000000000000E+00}, \
    {-7.48358365971746542E-01, -4.96716731943493084E-01, 0.00000000000000000E+00, 1.74835836597174654E+00, -1.74835836597174654E+00, 1.24507509791523963E+00}, \
    {-1.49437171504773825E+00, -2.47185857523869124E-01, 0.00000000000000000E+00, 7.52814142476130876E-01, -7.52814142476130876E-01, 1.74155757257160748E+00}, \
    {2.47185857523869346E-01, -2.47185857523869124E-01, 0.00000000000000000E+00, 2.49437171504773847E+00, -2.49437171504773847E+00, -2.22044604925031308E-16}, \
    {2.47185857523869346E-01, 1.49437171504773847E+00, 0.00000000000000000E+00, 7.52814142476130876E-01, -7.52814142476130876E-01, -1.74155757257160793E+00}, \
    {-2.64216389284437847E+00, -8.21081946422189124E-01, 0.00000000000000000E+00, 1.78918053577810848E-01, -1.78918053577810848E-01, 3.46324583926656748E+00}, \
    {8.21081946422189346E-01, -8.21081946422189124E-01, 0.00000000000000000E+00, 3.64216389284437847E+00, -3.64216389284437847E+00, -1.66533453693773481E-16}, \
    {8.21081946422189346E-01, 2.64216389284437847E+00, 0.00000000000000000E+00, 1.78918053577810848E-01, -1.78918053577810848E-01, -3.46324583926656793E+00}, \
    {-1.96479439513799203E+00, -8.52646351781054856E-01, 0.00000000000000000E+00, 8.87851956643062823E-01, -8.87851956643062823E-01, 2.81744074691904700E+00}, \
    {-1.96479439513799203E+00, -1.12148043356937177E-01, 0.00000000000000000E+00, 1.47353648218945144E-01, -1.47353648218945144E-01, 2.07694243849492910E+00}, \
    {1.12148043356937177E-01, -8.52646351781054856E-01, 0.00000000000000000E+00, 2.96479439513799203E+00, -2.96479439513799203E+00, 7.40498308424117679E-01}, \
    {1.12148043356937177E-01, 1.96479439513799203E+00, 0.00000000000000000E+00, 1.47353648218945144E-01, -1.47353648218945144E-01, -2.07694243849492910E+00}, \
    {8.52646351781054856E-01, -1.12148043356937177E-01, 0.00000000000000000E+00, 2.96479439513799203E+00, -2.96479439513799203E+00, -7.40498308424117679E-01}, \
    {8.52646351781054856E-01, 1.96479439513799203E+00, 0.00000000000000000E+00, 8.87851956643062823E-01, -8.87851956643062823E-01, -2.81744074691904700E+00}  \
    };

    // Value of basis function, derivatives = [1  1  0], at quadrature points
    static const double Geo_Basis_Val_1_1_0[NQ][NB] = { \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}, \
    {4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 4.00000000000000000E+00, -4.00000000000000000E+00, -4.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [2  0  0], at quadrature points
    static const double Geo_Basis_Val_2_0_0[NQ][NB] = { \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}, \
    {4.00000000000000000E+00, 4.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00, -8.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     {3.33333333333333315E-01, 3.33333333333333315E-01}, \
//     {4.89682519198737620E-01, 4.89682519198737620E-01}, \
//     {4.89682519198737620E-01, 2.06349616025247456E-02}, \
//     {2.06349616025247456E-02, 4.89682519198737620E-01}, \
//     {4.37089591492936635E-01, 4.37089591492936635E-01}, \
//     {4.37089591492936635E-01, 1.25820817014126729E-01}, \
//     {1.25820817014126729E-01, 4.37089591492936635E-01}, \
//     {1.88203535619032719E-01, 1.88203535619032719E-01}, \
//     {1.88203535619032719E-01, 6.23592928761934617E-01}, \
//     {6.23592928761934617E-01, 1.88203535619032719E-01}, \
//     {4.47295133944527121E-02, 4.47295133944527121E-02}, \
//     {4.47295133944527121E-02, 9.10540973211094617E-01}, \
//     {9.10540973211094617E-01, 4.47295133944527121E-02}, \
//     {3.68384120547362859E-02, 2.21962989160765706E-01}, \
//     {2.21962989160765706E-01, 3.68384120547362859E-02}, \
//     {3.68384120547362859E-02, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 3.68384120547362859E-02}, \
//     {2.21962989160765706E-01, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 2.21962989160765706E-01}  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    4.85678981413994182E-02, \
    1.56673501135695357E-02, \
    1.56673501135695357E-02, \
    1.56673501135695357E-02, \
    3.89137705023871391E-02, \
    3.89137705023871391E-02, \
    3.89137705023871391E-02, \
    3.98238694636051244E-02, \
    3.98238694636051244E-02, \
    3.98238694636051244E-02, \
    1.27888378293490156E-02, \
    1.27888378293490156E-02, \
    1.27888378293490156E-02, \
    2.16417696886446881E-02, \
    2.16417696886446881E-02, \
    2.16417696886446881E-02, \
    2.16417696886446881E-02, \
    2.16417696886446881E-02, \
    2.16417696886446881E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the local map
    // note: indexing is in the C style
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // sum over basis functions
        VEC_3x1& Map_PHI_qp_i = Map_PHI[qp_i];
        Map_PHI_qp_i.v[0] = Geo_Basis_Val_0_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_0_0[qp_i][2]*Node_Value[0][kc[2]]+Geo_Basis_Val_0_0_0[qp_i][3]*Node_Value[0][kc[3]]+Geo_Basis_Val_0_0_0[qp_i][4]*Node_Value[0][kc[4]]+Geo_Basis_Val_0_0_0[qp_i][5]*Node_Value[0][kc[5]];
        Map_PHI_qp_i.v[1] = Geo_Basis_Val_0_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_0_0[qp_i][2]*Node_Value[1][kc[2]]+Geo_Basis_Val_0_0_0[qp_i][3]*Node_Value[1][kc[3]]+Geo_Basis_Val_0_0_0[qp_i][4]*Node_Value[1][kc[4]]+Geo_Basis_Val_0_0_0[qp_i][5]*Node_Value[1][kc[5]];
        Map_PHI_qp_i.v[2] = Geo_Basis_Val_0_0_0[qp_i][0]*Node_Value[2][kc[0]]+Geo_Basis_Val_0_0_0[qp_i][1]*Node_Value[2][kc[1]]+Geo_Basis_Val_0_0_0[qp_i][2]*Node_Value[2][kc[2]]+Geo_Basis_Val_0_0_0[qp_i][3]*Node_Value[2][kc[3]]+Geo_Basis_Val_0_0_0[qp_i][4]*Node_Value[2][kc[4]]+Geo_Basis_Val_0_0_0[qp_i][5]*Node_Value[2][kc[5]];
        }
    // compute the gradient of the local map
    // note: indexing is in the C style
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // sum over basis functions
        MAT_3x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]]+Geo_Basis_Val_1_0_0[qp_i][3]*Node_Value[0][kc[3]]+Geo_Basis_Val_1_0_0[qp_i][4]*Node_Value[0][kc[4]]+Geo_Basis_Val_1_0_0[qp_i][5]*Node_Value[0][kc[5]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]]+Geo_Basis_Val_0_1_0[qp_i][3]*Node_Value[0][kc[3]]+Geo_Basis_Val_0_1_0[qp_i][4]*Node_Value[0][kc[4]]+Geo_Basis_Val_0_1_0[qp_i][5]*Node_Value[0][kc[5]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]]+Geo_Basis_Val_1_0_0[qp_i][3]*Node_Value[1][kc[3]]+Geo_Basis_Val_1_0_0[qp_i][4]*Node_Value[1][kc[4]]+Geo_Basis_Val_1_0_0[qp_i][5]*Node_Value[1][kc[5]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]]+Geo_Basis_Val_0_1_0[qp_i][3]*Node_Value[1][kc[3]]+Geo_Basis_Val_0_1_0[qp_i][4]*Node_Value[1][kc[4]]+Geo_Basis_Val_0_1_0[qp_i][5]*Node_Value[1][kc[5]];
        Map_PHI_Grad_qp_i.m[2][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[2][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[2][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[2][kc[2]]+Geo_Basis_Val_1_0_0[qp_i][3]*Node_Value[2][kc[3]]+Geo_Basis_Val_1_0_0[qp_i][4]*Node_Value[2][kc[4]]+Geo_Basis_Val_1_0_0[qp_i][5]*Node_Value[2][kc[5]];
        Map_PHI_Grad_qp_i.m[2][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[2][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[2][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[2][kc[2]]+Geo_Basis_Val_0_1_0[qp_i][3]*Node_Value[2][kc[3]]+Geo_Basis_Val_0_1_0[qp_i][4]*Node_Value[2][kc[4]]+Geo_Basis_Val_0_1_0[qp_i][5]*Node_Value[2][kc[5]];
        }
    // compute metric tensor from jacobian matrix
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Metric_qp_i = Map_PHI_Metric[qp_i];
        Mat_Transpose_Mat_Self(Map_PHI_Grad[qp_i], Map_PHI_Metric_qp_i);
        }
    // compute determinant of Metric: det(PHI_Metric)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Det_Metric_qp_i = Map_Det_Metric[qp_i];
        Map_Det_Metric_qp_i.a = Determinant(Map_PHI_Metric[qp_i]);
        }
    // compute 1 / det(Metric)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Metric_qp_i = Map_Inv_Det_Metric[qp_i];
        Map_Inv_Det_Metric_qp_i.a = 1.0 / Map_Det_Metric[qp_i].a;
        }
    // compute inverse of the Metric tensor
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Metric_qp_i = Map_PHI_Inv_Metric[qp_i];
        Matrix_Inverse(Map_PHI_Metric[qp_i], Map_Inv_Det_Metric[qp_i], Map_PHI_Inv_Metric_qp_i);
        }
    // compute determinant of Jacobian
    // note: det(Jac) = sqrt(det(PHI_Metric))
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = sqrt(Map_Det_Metric[qp_i].a);
        }
    // multiply det(jacobian) by quadrature weight
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_w_Weight_qp_i = Map_Det_Jac_w_Weight[qp_i];
        Map_Det_Jac_w_Weight_qp_i.a = Map_Det_Jac[qp_i].a * Quad_Weights[qp_i];
        }
    // compute 1 / det(Jacobian)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // compute oriented normal vector (assuming the original mesh was oriented properly)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        VEC_3x1& Map_Normal_Vector_qp_i = Map_Normal_Vector[qp_i];
        Compute_Normal_Vector(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_Normal_Vector_qp_i);
        }
    // compute the hessian of the local map
    // note: indexing is in the C style
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // sum over basis functions
        MAT_3x2x2& Map_PHI_Hess_qp_i = Map_PHI_Hess[qp_i];
        Map_PHI_Hess_qp_i.m[0][0][0] = Geo_Basis_Val_2_0_0[qp_i][0] * Node_Value[0][kc[0]] + Geo_Basis_Val_2_0_0[qp_i][1] * Node_Value[0][kc[1]] + Geo_Basis_Val_2_0_0[qp_i][2] * Node_Value[0][kc[2]] + Geo_Basis_Val_2_0_0[qp_i][3] * Node_Value[0][kc[3]] + Geo_Basis_Val_2_0_0[qp_i][4] * Node_Value[0][kc[4]] + Geo_Basis_Val_2_0_0[qp_i][5] * Node_Value[0][kc[5]];
        Map_PHI_Hess_qp_i.m[0][0][1] = Geo_Basis_Val_1_1_0[qp_i][0] * Node_Value[0][kc[0]] + Geo_Basis_Val_1_1_0[qp_i][1] * Node_Value[0][kc[1]] + Geo_Basis_Val_1_1_0[qp_i][2] * Node_Value[0][kc[2]] + Geo_Basis_Val_1_1_0[qp_i][3] * Node_Value[0][kc[3]] + Geo_Basis_Val_1_1_0[qp_i][4] * Node_Value[0][kc[4]] + Geo_Basis_Val_1_1_0[qp_i][5] * Node_Value[0][kc[5]];
        Map_PHI_Hess_qp_i.m[0][1][0] = Map_PHI_Hess_qp_i.m[0][0][1]; // symmetry!
        Map_PHI_Hess_qp_i.m[0][1][1] = Geo_Basis_Val_0_2_0[qp_i][0] * Node_Value[0][kc[0]] + Geo_Basis_Val_0_2_0[qp_i][1] * Node_Value[0][kc[1]] + Geo_Basis_Val_0_2_0[qp_i][2] * Node_Value[0][kc[2]] + Geo_Basis_Val_0_2_0[qp_i][3] * Node_Value[0][kc[3]] + Geo_Basis_Val_0_2_0[qp_i][4] * Node_Value[0][kc[4]] + Geo_Basis_Val_0_2_0[qp_i][5] * Node_Value[0][kc[5]];
        Map_PHI_Hess_qp_i.m[1][0][0] = Geo_Basis_Val_2_0_0[qp_i][0] * Node_Value[1][kc[0]] + Geo_Basis_Val_2_0_0[qp_i][1] * Node_Value[1][kc[1]] + Geo_Basis_Val_2_0_0[qp_i][2] * Node_Value[1][kc[2]] + Geo_Basis_Val_2_0_0[qp_i][3] * Node_Value[1][kc[3]] + Geo_Basis_Val_2_0_0[qp_i][4] * Node_Value[1][kc[4]] + Geo_Basis_Val_2_0_0[qp_i][5] * Node_Value[1][kc[5]];
        Map_PHI_Hess_qp_i.m[1][0][1] = Geo_Basis_Val_1_1_0[qp_i][0] * Node_Value[1][kc[0]] + Geo_Basis_Val_1_1_0[qp_i][1] * Node_Value[1][kc[1]] + Geo_Basis_Val_1_1_0[qp_i][2] * Node_Value[1][kc[2]] + Geo_Basis_Val_1_1_0[qp_i][3] * Node_Value[1][kc[3]] + Geo_Basis_Val_1_1_0[qp_i][4] * Node_Value[1][kc[4]] + Geo_Basis_Val_1_1_0[qp_i][5] * Node_Value[1][kc[5]];
        Map_PHI_Hess_qp_i.m[1][1][0] = Map_PHI_Hess_qp_i.m[1][0][1]; // symmetry!
        Map_PHI_Hess_qp_i.m[1][1][1] = Geo_Basis_Val_0_2_0[qp_i][0] * Node_Value[1][kc[0]] + Geo_Basis_Val_0_2_0[qp_i][1] * Node_Value[1][kc[1]] + Geo_Basis_Val_0_2_0[qp_i][2] * Node_Value[1][kc[2]] + Geo_Basis_Val_0_2_0[qp_i][3] * Node_Value[1][kc[3]] + Geo_Basis_Val_0_2_0[qp_i][4] * Node_Value[1][kc[4]] + Geo_Basis_Val_0_2_0[qp_i][5] * Node_Value[1][kc[5]];
        Map_PHI_Hess_qp_i.m[2][0][0] = Geo_Basis_Val_2_0_0[qp_i][0] * Node_Value[2][kc[0]] + Geo_Basis_Val_2_0_0[qp_i][1] * Node_Value[2][kc[1]] + Geo_Basis_Val_2_0_0[qp_i][2] * Node_Value[2][kc[2]] + Geo_Basis_Val_2_0_0[qp_i][3] * Node_Value[2][kc[3]] + Geo_Basis_Val_2_0_0[qp_i][4] * Node_Value[2][kc[4]] + Geo_Basis_Val_2_0_0[qp_i][5] * Node_Value[2][kc[5]];
        Map_PHI_Hess_qp_i.m[2][0][1] = Geo_Basis_Val_1_1_0[qp_i][0] * Node_Value[2][kc[0]] + Geo_Basis_Val_1_1_0[qp_i][1] * Node_Value[2][kc[1]] + Geo_Basis_Val_1_1_0[qp_i][2] * Node_Value[2][kc[2]] + Geo_Basis_Val_1_1_0[qp_i][3] * Node_Value[2][kc[3]] + Geo_Basis_Val_1_1_0[qp_i][4] * Node_Value[2][kc[4]] + Geo_Basis_Val_1_1_0[qp_i][5] * Node_Value[2][kc[5]];
        Map_PHI_Hess_qp_i.m[2][1][0] = Map_PHI_Hess_qp_i.m[2][0][1]; // symmetry!
        Map_PHI_Hess_qp_i.m[2][1][1] = Geo_Basis_Val_0_2_0[qp_i][0] * Node_Value[2][kc[0]] + Geo_Basis_Val_0_2_0[qp_i][1] * Node_Value[2][kc[1]] + Geo_Basis_Val_0_2_0[qp_i][2] * Node_Value[2][kc[2]] + Geo_Basis_Val_0_2_0[qp_i][3] * Node_Value[2][kc[3]] + Geo_Basis_Val_0_2_0[qp_i][4] * Node_Value[2][kc[4]] + Geo_Basis_Val_0_2_0[qp_i][5] * Node_Value[2][kc[5]];
        }
    // compute the 2nd fundamental form of the local map
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // sum over geometric dimension
        MAT_2x2& Map_PHI_2nd_Fund_Form_qp_i = Map_PHI_2nd_Fund_Form[qp_i];
        Compute_2nd_Fundamental_Form(Map_PHI_Hess[qp_i], Map_Normal_Vector[qp_i], Map_PHI_2nd_Fund_Form_qp_i);
        }
    // compute the total curvature of the manifold
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Total_Curvature_qp_i = Map_Total_Curvature[qp_i];
        Compute_Total_Curvature(Map_PHI_2nd_Fund_Form[qp_i], Map_PHI_Inv_Metric[qp_i], Map_Total_Curvature_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

#undef MGC

#undef MAP_type
#undef GLOBAL_TD
#undef SUB_TD
#undef DOI_TD
#undef GD
#undef NQ
#undef NB
#undef ORIENT

/***/
