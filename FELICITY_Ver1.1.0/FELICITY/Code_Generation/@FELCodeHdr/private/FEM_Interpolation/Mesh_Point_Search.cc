/*
============================================================================================
   This (abstract base) class is for searching meshes.

   Copyright (c) 10-02-2015,  Shawn W. Walker
============================================================================================
*/

#include <algorithm>

// define the diagonal projection tolerance
#define  DIAG_TOL  1E-15
// #define  SQ_RT_2   1.41421356237309504880168872420969807856967187537694807317667973799
// #define  SQ_RT_3   1.73205080756887729352744634150587236694280525381038062805580697945

/* define some elementary routines */

/***************************************************************************************/
/* this is useful for arrays of small length.
   note: this assumes length > 0 */
void simple_argminmax(const double* array, const int& length,
                      int& argmin, int& argmax)
{
    // init
    argmin = 0;
    argmax = 0;

    for (int ii = 1; ii < length; ii++)
        {
        if (array[ii] < array[argmin])
            argmin = ii;
        else if (array[ii] > array[argmax])
            argmax = ii;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this is useful for arrays of small length.
   note: this assumes length > 0 */
void simple_argmin(const double* array, const int& length, int& argmin)
{
    // init
    argmin = 0;

    for (int ii = 1; ii < length; ii++)
        {
        if (array[ii] < array[argmin])
            argmin = ii;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* determine if given element is in the array. */
bool is_element_in_array(const unsigned int* array, const unsigned int& array_size,
                         const unsigned int& element)
{
    const unsigned int* array_END = (const unsigned int*) (array + array_size);
    // search the array
    const unsigned int* found_index = std::find(array, array_END, element);

    // it was found  <=>  found_index < array_END
    if ( found_index < array_END )
        return true;
    else
        return false;
}
/***************************************************************************************/

/* define structs and routines that are useful for enabling point searches */

/***************************************************************************************/
/* Topological Dimension: 1, Geometric Dimension 1 */
// point search data
typedef struct
{
    VEC_1x1        global_pt;
    unsigned int   cell_index;
    VEC_1x1        local_pt;
} PT_DATA_Top1_Geo1;

inline int Selection_Criterium(const VEC_1x1& local_pt, double& min_N, double& max_N)
{
	// init
	min_N = 1.0 - local_pt.v[0];
	max_N = 1.0 - local_pt.v[0];
	int argmin = 0;
	int argmax = 0;
	
    // apply selection criterium
	if (local_pt.v[0] < min_N)
		{
		min_N = local_pt.v[0];
		argmin = 1;
		}
	else if (local_pt.v[0] > max_N)
		{
		max_N = local_pt.v[0];
		argmax = 1;
		}
	return argmin; // return ARGMIN
}
inline void Init_Barycenter(VEC_1x1& local_pt)
{
	// set to center of the reference cell
	local_pt.v[0] = 0.5;
}
inline void Init_Bogus_Pt(VEC_1x1& local_pt)
{
	// set to a point way outside the reference cell
	local_pt.v[0] = -1;
}

/***************************************************************************************/
/* Topological Dimension: 1, Geometric Dimension 2 */
// point search data
typedef struct
{
    VEC_2x1        global_pt;
    unsigned int   cell_index;
    VEC_1x1        local_pt;

} PT_DATA_Top1_Geo2;

// minimum data on reference triangle for a particular mesh cell
typedef struct
{
    VEC_1x1        x;          // location of minimum
	SCALAR         Cx;         // cost at minimum
	VEC_1x1        Grad_Cx;    // gradient of cost at minimum
} Min_On_Cell_Top1;

inline void Copy_Min_On_Cell(const Min_On_Cell_Top1& A_in, Min_On_Cell_Top1& A_out)
{
	// copy over
	A_out.x.v[0]       = A_in.x.v[0];
	A_out.Cx.a         = A_in.Cx.a;
	A_out.Grad_Cx.v[0] = A_in.Grad_Cx.v[0];
}
inline void Project_Onto_Ref_Cell(VEC_1x1& PT, const double& TOL)
{
    // ensure the point is inside the closure of the ref triangle
    // i.e. project it onto the reference triangle
    if (PT.v[0] > 1.0) PT.v[0] = 1.0;
    if (PT.v[0] < 0.0) PT.v[0] = 0.0;

	// if the point is "close" to an end vertex,
	// then "snap" it to the end vertex.
	const bool p_close_to_zero = PT.v[0] < TOL;         // 0 <= p < TOL
	const bool p_close_to_one  = (1.0 - TOL) < PT.v[0]; // 1 - TOL < p <= 1
	if ( (p_close_to_zero) ) // close to (0)
		{
		// snap
		PT.v[0] = 0.0;
		}
	else if ( (p_close_to_one) ) // close to (1)
		{
		// snap
		PT.v[0] = 1.0;
		}
}

/***************************************************************************************/
/* Topological Dimension: 1, Geometric Dimension 3 */
// point search data
typedef struct
{
    VEC_3x1        global_pt;
    unsigned int   cell_index;
    VEC_1x1        local_pt;

} PT_DATA_Top1_Geo3;

/***************************************************************************************/
/* Topological Dimension: 2, Geometric Dimension 2 */
// point search data
typedef struct
{
    VEC_2x1        global_pt;
    unsigned int   cell_index;
    VEC_2x1        local_pt;
} PT_DATA_Top2_Geo2;

inline int Selection_Criterium(const VEC_2x1& local_pt, double& min_N, double& max_N)
{
    // apply selection criterium
    const double N[3] = {1.0 - local_pt.v[0] - local_pt.v[1],
                               local_pt.v[0],  local_pt.v[1]};

    int argmin, argmax;
    simple_argminmax(N, 3, argmin, argmax);
    min_N = N[argmin];
    max_N = N[argmax];
	return argmin; // return ARGMIN
}
inline void Init_Barycenter(VEC_2x1& local_pt)
{
	// set to center of the reference cell
	local_pt.v[0] = 1.0/3.0;
	local_pt.v[1] = 1.0/3.0;
}
inline void Init_Bogus_Pt(VEC_2x1& local_pt)
{
	// set to a point way outside the reference cell
	local_pt.v[0] = -1;
	local_pt.v[1] = -1;
}

/***************************************************************************************/
/* Topological Dimension: 2, Geometric Dimension 3 */
// point search data
typedef struct
{
    VEC_3x1        global_pt;
    unsigned int   cell_index;
    VEC_2x1        local_pt;

} PT_DATA_Top2_Geo3;

// minimum data on reference triangle for a particular mesh cell
typedef struct
{
    VEC_2x1        x;          // location of minimum
	SCALAR         Cx;         // cost at minimum
	VEC_2x1        Grad_Cx;    // gradient of cost at minimum
} Min_On_Cell_Top2;

inline void Copy_Min_On_Cell(const Min_On_Cell_Top2& A_in, Min_On_Cell_Top2& A_out)
{
	// copy over
	A_out.x.v[0]       = A_in.x.v[0];
	A_out.x.v[1]       = A_in.x.v[1];
	A_out.Cx.a         = A_in.Cx.a;
	A_out.Grad_Cx.v[0] = A_in.Grad_Cx.v[0];
	A_out.Grad_Cx.v[1] = A_in.Grad_Cx.v[1];
}
inline void Project_Onto_Ref_Cell(VEC_2x1& PT, const double& TOL)
{
    // ensure the point is inside the closure of the ref triangle
    // i.e. project it onto the reference triangle
    if (PT.v[0] > 1.0) PT.v[0] = 1.0;
    if (PT.v[1] > 1.0) PT.v[1] = 1.0;
    if (PT.v[0] < 0.0) PT.v[0] = 0.0;
    if (PT.v[1] < 0.0) PT.v[1] = 0.0;

    // project onto diagonal edge
	const double check_diag = 1.0 - PT.v[0] - PT.v[1];
    if ( check_diag < 0.0 )
        {
        // shrink it back
        PT.v[0] = PT.v[0] + (0.5 + DIAG_TOL) * check_diag;
        PT.v[1] = PT.v[1] + (0.5 + DIAG_TOL) * check_diag;
        }

	// if the point is "close" to a corner vertex,
	// then "snap" it to the corner vertex.
	const bool p_close_to_zero = PT.v[0] < TOL;         // 0 <= p < TOL
	const bool p_close_to_one  = (1.0 - TOL) < PT.v[0]; // 1 - TOL < p <= 1
	const bool q_close_to_zero = PT.v[1] < TOL;         // 0 <= q < TOL
	const bool q_close_to_one  = (1.0 - TOL) < PT.v[1]; // 1 - TOL < q <= 1
	if ( (p_close_to_zero) && (q_close_to_zero) ) // close to (0,0)
		{
		// snap
		PT.v[0] = 0.0;
		PT.v[1] = 0.0;
		}
	else if ( (p_close_to_one) && (q_close_to_zero) ) // close to (1,0)
		{
		// snap
		PT.v[0] = 1.0;
		PT.v[1] = 0.0;
		}
	else if ( (p_close_to_zero) && (q_close_to_one) ) // close to (0,1)
		{
		// snap
		PT.v[0] = 0.0;
		PT.v[1] = 1.0;
		}
}

/***************************************************************************************/
/* Topological Dimension: 3, Geometric Dimension 3 */
// point search data
typedef struct
{
    VEC_3x1        global_pt;
    unsigned int   cell_index;
    VEC_3x1        local_pt;
} PT_DATA_Top3_Geo3;

inline int Selection_Criterium(const VEC_3x1& local_pt, double& min_N, double& max_N)
{
    // apply selection criterium
    const double N[4] = {1.0 - local_pt.v[0] - local_pt.v[1] - local_pt.v[2],
                               local_pt.v[0],  local_pt.v[1],  local_pt.v[2]};

    int argmin, argmax;
    simple_argminmax(N, 4, argmin, argmax);
    min_N = N[argmin];
    max_N = N[argmax];
	return argmin; // return ARGMIN
}
inline void Init_Barycenter(VEC_3x1& local_pt)
{
	// set to center of the reference cell
	local_pt.v[0] = 1.0/4.0;
	local_pt.v[1] = 1.0/4.0;
	local_pt.v[2] = 1.0/4.0;
}
inline void Init_Bogus_Pt(VEC_3x1& local_pt)
{
	// set to a point way outside the reference cell
	local_pt.v[0] = -1;
	local_pt.v[1] = -1;
	local_pt.v[2] = -1;
}

inline void Project_Onto_Ref_Cell(VEC_3x1& PT, const double& TOL)
{
    // ensure the point is inside the closure of the ref tetrahedron
    // i.e. project it onto the reference tetrahedron
    if (PT.v[0] > 1.0) PT.v[0] = 1.0;
    if (PT.v[1] > 1.0) PT.v[1] = 1.0;
	if (PT.v[2] > 1.0) PT.v[2] = 1.0;
    if (PT.v[0] < 0.0) PT.v[0] = 0.0;
    if (PT.v[1] < 0.0) PT.v[1] = 0.0;
	if (PT.v[2] < 0.0) PT.v[2] = 0.0;

    // project onto diagonal face
	const double check_diag = 1.0 - PT.v[0] - PT.v[1] - PT.v[2];
    if ( check_diag < 0.0 )
        {
        // shrink it back
        PT.v[0] = PT.v[0] + ((1.0/3.0) + DIAG_TOL) * check_diag;
        PT.v[1] = PT.v[1] + ((1.0/3.0) + DIAG_TOL) * check_diag;
		PT.v[2] = PT.v[2] + ((1.0/3.0) + DIAG_TOL) * check_diag;
        }

	// if the point is "close" to a corner vertex,
	// then "snap" it to the corner vertex.
	const bool p_close_to_zero = PT.v[0] < TOL;         // 0 <= p < TOL
	const bool p_close_to_one  = (1.0 - TOL) < PT.v[0]; // 1 - TOL < p <= 1
	const bool q_close_to_zero = PT.v[1] < TOL;         // 0 <= q < TOL
	const bool q_close_to_one  = (1.0 - TOL) < PT.v[1]; // 1 - TOL < q <= 1
	const bool r_close_to_zero = PT.v[2] < TOL;         // 0 <= r < TOL
	const bool r_close_to_one  = (1.0 - TOL) < PT.v[2]; // 1 - TOL < r <= 1
	if ( (p_close_to_zero) && (q_close_to_zero) && (r_close_to_zero) ) // close to (0,0,0)
		{
		// snap
		PT.v[0] = 0.0;
		PT.v[1] = 0.0;
		PT.v[2] = 0.0;
		}
	else if ( (p_close_to_one) && (q_close_to_zero) && (r_close_to_zero) ) // close to (1,0,0)
		{
		// snap
		PT.v[0] = 1.0;
		PT.v[1] = 0.0;
		PT.v[2] = 0.0;
		}
	else if ( (p_close_to_zero) && (q_close_to_one) && (r_close_to_zero) ) // close to (0,1,0)
		{
		// snap
		PT.v[0] = 0.0;
		PT.v[1] = 1.0;
		PT.v[2] = 0.0;
		}
	else if ( (p_close_to_zero) && (q_close_to_zero) && (r_close_to_one) ) // close to (0,0,1)
		{
		// snap
		PT.v[0] = 0.0;
		PT.v[1] = 0.0;
		PT.v[2] = 1.0;
		}
}

/***************************************************************************************/
/* C++ abstract base class */
#define MPSC Mesh_Point_Search_Class
class MPSC
{
protected:

public:
    char*      Name; // name of the particular point search class

    // pointers to the search data (which holds the neighbor data)
    //     and the found point data to be computed
    const Subdomain_Search_Data_Class* Search_Data;
    Unstructured_Local_Points_Class*   Found_Points;

    //MPSC (); // constructor
    MPSC (const Subdomain_Search_Data_Class*, Unstructured_Local_Points_Class*); // constructor
    ~MPSC (); // DE-structor
};

/***************************************************************************************/
/* constructor */
MPSC::MPSC (const Subdomain_Search_Data_Class* INPUT_SD, Unstructured_Local_Points_Class* INPUT_FP)
{
    Name          = NULL;
    Search_Data   = INPUT_SD;
    Found_Points  = INPUT_FP;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
MPSC::~MPSC ()
{
}
/***************************************************************************************/

#undef DIAG_TOL
#undef MPSC

/***/
