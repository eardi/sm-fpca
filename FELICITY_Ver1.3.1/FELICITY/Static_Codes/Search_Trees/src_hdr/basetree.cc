/*
============================================================================================
   This is an abstract point-region (PR) search tree class.  The basic use is to partition
   points for fast searching operations.

   Copyright (c) 01-14-2014,  Shawn W. Walker
============================================================================================
*/

#include <vector>
#include <algorithm>
#include <cmath>        // std::abs

typedef double pt_type;
typedef unsigned int UINT_type;
struct trCell; // proto-type

/***************************************************************************************/
/* keeps track of the new node (cell) that a point has traveled to. */
typedef struct
{
    trCell*                 new_node;   // pointer to cell that the point now lies in.
    UINT_type               pt_index;   // global point index
} ExitPoint;
// this is used for sorting a vector of these structs
bool order_by_cell(const ExitPoint& i, const ExitPoint& j)
{
    return (i.new_node < j.new_node); // sort by pointer value
}
/***************************************************************************************/

/***************************************************************************************/
/* used for doing k-nearest neighbor searches. */
typedef struct
{
    UINT_type    index;
    pt_type      dist;
} IndexDist;
// this is used for sorting a vector of these structs
bool order_by_dist(const IndexDist& i, const IndexDist& j)
{
    return (i.dist < j.dist);
}
/***************************************************************************************/

// /* Maximum tree depth and related constants */
// #define tr_num_levels 16     // Number of possible levels in the tree
// #define tr_root_level 15     // Level of root cell (tr_num_levels - 1)
// #define tr_max_val 32768.0f  // For converting positions to locational codes
//                                 (tr_max_val = 2^tr_root_level)

/***************************************************************************************/
/* C++ (abstract) class */
#define  BT  basetree
class BT
{
public:
    BT (); // constructor
    ~BT (); // DE-structor

    // initializing
    void Setup_Levels(const UINT_type);

    // used for closest point
    const std::vector<IndexDist>& Get_Closest_Point_Data() const {return ind_dist;}

protected:
    // maximum tree depth and related constants
    UINT_type  tr_num_levels;
    UINT_type  tr_root_level;
    UINT_type  tr_max_val;

    // maximum number of points to store in a tree leaf cell
    UINT_type  bucket_size;

    // the ROOT node
    trCell*  root;

    // track which point indices need to be updated
    std::vector<ExitPoint> exited_point;

    // counter for making sure the tree print-out lists all of the points (used for error checking)
    UINT_type  print_count;

    // variables for closest point calculations
    UINT_type  num_neighbors;
    std::vector<IndexDist> ind_dist;

    // helper
	//inline pt_type my_abs(const pt_type&);
    inline pt_type clamp(const pt_type&, const pt_type&, const pt_type&);
	inline bool in_interval(const pt_type&, const pt_type&, const pt_type&);
	inline UINT_type my_trunc(const pt_type&);
};

/***************************************************************************************/
/* constructor */
BT::BT ()
{
    // init
    root = NULL;

    tr_num_levels = 32; // default value
    tr_root_level = tr_num_levels - 1;
    tr_max_val    = 1 << tr_root_level;
    bucket_size   = 20; // default value

    exited_point.clear();
    print_count   = 0;
    num_neighbors = 0;
    ind_dist.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
BT::~BT ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup tree levels and depth */
void BT::Setup_Levels(const UINT_type Max_Levels)
{
    tr_num_levels = Max_Levels;
    if (tr_num_levels < 2)  mexErrMsgTxt("Maximum number of tree levels must be at least 2!\n");
    if (tr_num_levels > 32) mexErrMsgTxt("Maximum number of tree levels must not exceed 32!\n");
    // set these for future use
    tr_root_level = tr_num_levels - 1;
    tr_max_val = 1 << tr_root_level;
}
/***************************************************************************************/


// /***************************************************************************************/
// /* simple absolute value! */
// inline pt_type BT::my_abs(const pt_type& x)
// {
    // if (x < 0)
        // return -x;
    // else
        // return x;
// }
// /***************************************************************************************/


/***************************************************************************************/
/* clamp the value x to the range [a, b]
   Note: must have a <= b. */
inline pt_type BT::clamp(const pt_type& x, const pt_type& a, const pt_type& b)
{
    if (x <= a)
        return a;
    else if (x >= b)
        return b;
    else
        return x;
}
/***************************************************************************************/


/***************************************************************************************/
/* Test whether x is in the interval [a,b).
   Note: must have a <= b. */
inline bool BT::in_interval(const pt_type& x, const pt_type& a, const pt_type& b)
{
    if ( (x >= a) && (x < b) )
        return true;
    else
        return false;
}
/***************************************************************************************/


/***************************************************************************************/
/* truncate ``real'' number. */
inline UINT_type BT::my_trunc(const pt_type& VAL)
{
    return (UINT_type) VAL;
}
/***************************************************************************************/

#undef  BT

/***/
