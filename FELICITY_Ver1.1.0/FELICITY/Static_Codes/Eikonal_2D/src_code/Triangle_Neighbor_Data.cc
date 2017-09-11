/*
============================================================================================
   Methods for manipulating triangle neighbor data.
   
   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

#define TND Tri_Neighbor_Data

/***************************************************************************************/
/* constructor */
TND::TND ()
{
	Star.Col1 = NULL;
	Star.Col2 = NULL;
	Star.Col3 = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
TND::~TND ()
{
	if (Star.Col1!=NULL)
		{
		mxFree(Star.Col1);
		mxFree(Star.Col2);
		mxFree(Star.Col3);
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* initializer */
void TND::Init (const mxArray *Sparse_TND_Matrix, PARAM_STRUCT Param)
{
	// minor error checking
	if (!mxIsSparse(Sparse_TND_Matrix)) mexErrMsgTxt("ERROR: Triangle Neighbor Data must be sparse!");
	
	// get the pointers
    TriNeighborSparse.Vtx_Indices =  (size_t*) mxGetJc(Sparse_TND_Matrix);
	TriNeighborSparse.Tri_Indices =  mxGetPr(Sparse_TND_Matrix);
	
	// setup of local star data
	Star.Max_Tri = Param.Max_Tri_per_Star;
	Star.First_Tri_Index = 0; // init
	Star.Last_Tri_Index  = 0; // init
	Star.Num_Tri         = 0; // init
	// allocate memory for triangle star data structure
	Star.Col1    = (int *) mxMalloc((Star.Max_Tri+1) * sizeof(int));
	Star.Col2    = (int *) mxMalloc((Star.Max_Tri+1) * sizeof(int));
	Star.Col3    = (int *) mxMalloc((Star.Max_Tri+1) * sizeof(int));
	
	// init
	for (int index = 0; (index < Star.Max_Tri+1); index++)
		{
		Star.Col1[index] = 0;
		Star.Col2[index] = 0;
		Star.Col3[index] = 0;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* get the star of triangles around the given vertex */
void TND::Get_Star (int C_Vtx_Index, TRI_MESH_DATA_STRUCT Mesh)
{
	// note: we have already accounted for C - style indexing (i.e. by subtracting off 1)
	
    Star.First_Tri_Index = (int) TriNeighborSparse.Vtx_Indices[C_Vtx_Index];
    Star.Last_Tri_Index  = ((int) TriNeighborSparse.Vtx_Indices[C_Vtx_Index+1]) - 1;
    Star.Num_Tri         = Star.Last_Tri_Index - Star.First_Tri_Index + 1;;
    Star.Col1[0]         = Star.Num_Tri;
    Star.Col2[0]         = Star.Num_Tri;
    Star.Col3[0]         = Star.Num_Tri;
    
    int Count = 0;
    // loop through the triangles contained in the local star
    for (int t_index = Star.First_Tri_Index; (t_index <= Star.Last_Tri_Index); t_index++)
        {
        Count++;

        int Current_Tri = (int)TriNeighborSparse.Tri_Indices[t_index] - 1;
        // put into C - style indexing
        int V1 = Mesh.Tri_Elem[0][Current_Tri] - 1;
        int V2 = Mesh.Tri_Elem[1][Current_Tri] - 1;
        int V3 = Mesh.Tri_Elem[2][Current_Tri] - 1;
        // we want them ordered so that the current center vertex (of the star) is listed first
        if (C_Vtx_Index == V1)
           {
           Star.Col1[Count] = V1;
           Star.Col2[Count] = V2;
           Star.Col3[Count] = V3;
           }
        else if (C_Vtx_Index == V3)
           {
           Star.Col1[Count] = V3;
           Star.Col2[Count] = V1;
           Star.Col3[Count] = V2;
           }
        else
           {
           Star.Col1[Count] = V2;
           Star.Col2[Count] = V3;
           Star.Col3[Count] = V1;
           }
        }
}
/***************************************************************************************/

#undef TND

/***/
