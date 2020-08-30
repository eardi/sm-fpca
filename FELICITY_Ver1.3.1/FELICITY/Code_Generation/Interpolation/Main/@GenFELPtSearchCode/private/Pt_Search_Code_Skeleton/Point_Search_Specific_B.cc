/***************************************************************************************/
/* constructor */
SpecificSEARCH::SpecificSEARCH (const Subdomain_Search_Data_Class* INPUT_SD, Unstructured_Local_Points_Class* INPUT_FP) :
Mesh_Point_Search_Class (INPUT_SD, INPUT_FP) // call the base class constructor
{
    // set the ''Name'' of the point search
    Name = (char*) SpecificSEARCH_str;      // this should be the same as the Class identifier
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor: should not usually need to be modified */
SpecificSEARCH::~SpecificSEARCH ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* this runs a consistency check */
void SpecificSEARCH::Consistency_Check()
{
    // make sure neighbor struct matches sub-domain cells
    // if ( (Search_Data->Num_Cells!=Domain->Get_Num_Elem()) || (Search_Data->Num_Cells!=GeomFunc->Get_Num_Elem()) )
	if (Search_Data->Num_Cells!=Domain->Get_Num_Elem())
        {
		// mexPrintf("Num_Cells = %d, Domain->Get_Num_Elem = %d, GeomFunc->Get_Num_Elem = %d.\n",Search_Data->Num_Cells,Domain->Get_Num_Elem(),GeomFunc->Get_Num_Elem());
        mexPrintf("ERROR: This concerns the search data for the sub-Domain: %s\n",Search_Data->Domain_Name);
        mexPrintf("ERROR: The number of rows of the sub-Domain neighbor data does not match the\n");
        mexPrintf("ERROR:     number of cells in the sub-Domain!\n");
        mexErrMsgTxt("Make sure your search data is in the correct format!\n");
        }
    if (Search_Data->Geo_Dim!=GeomFunc->Get_GeoDim())
        {
        mexPrintf("ERROR: This concerns the search data for the sub-Domain: %s\n",Search_Data->Domain_Name);
        mexPrintf("ERROR: The number of columns of the global point coordinate data does not match\n");
        mexPrintf("ERROR:     the geometric dimension of the sub-Domain!\n");
        mexErrMsgTxt("Make sure your search data is in the correct format!\n");
        }
    if ( (Search_Data->Top_Dim!=Found_Points->Top_Dim) || (Search_Data->Top_Dim!=GeomFunc->Get_Sub_TopDim()) )
        {
        mexPrintf("ERROR: This concerns the search data for the sub-Domain: %s\n",Search_Data->Domain_Name);
        mexPrintf("ERROR: The topological dimension of the sub-Domain does not match the\n");
        mexPrintf("ERROR:     topological dimension implied by the sub-Domain neighbor data!\n");
        mexErrMsgTxt("Make sure your search data is in the correct format!\n");
        }
}
/***************************************************************************************/


