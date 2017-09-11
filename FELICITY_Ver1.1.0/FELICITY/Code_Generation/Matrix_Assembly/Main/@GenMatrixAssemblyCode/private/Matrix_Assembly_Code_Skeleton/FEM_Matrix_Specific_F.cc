    // init by clearing data
    for (int row_i = 0; (row_i < ROW_NB); row_i++)
        Row_Indices[row_i] = 0;
    for (int col_i = 0; (col_i < COL_NB); col_i++)
        Col_Indices[col_i] = 0;
    for (int sub = 0; (sub < Num_Sub_Matrices); sub++)
        for (int rc_i = 0; (rc_i < ROW_NB*COL_NB); rc_i++)
            SubMAT_Info[sub].Local_Mat_Data[rc_i] = 0.0;

    Init_Matrix_Assembler_Object(simple_assembler);
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor: should not usually need to be modified */
SpecificFEM::~SpecificFEM ()
{
    delete(MAT);
}
/***************************************************************************************/


/***************************************************************************************/
/* this just initializes the object that handles matrix assembly */
void SpecificFEM::Init_Matrix_Assembler_Object(bool use_simple_assembler)
{
    if (use_simple_assembler)
    	// create SimpleMatrixAssembler object
		MAT = new SimpleMatrixAssembler(global_num_row,global_num_col); // assemble from scratch
    else if (Sparse_Data->valid)
        {
        int str_diff = strcmp(Sparse_Data->name,Name);
        if (str_diff!=0)
            {
            mexPrintf("Matrix names do not match!\n");
            mexPrintf("Previously assembled matrix name is:  %s.\n", Sparse_Data->name);
            mexPrintf("The name SHOULD have been:            %s.\n", Name);
            mexErrMsgTxt("Check the previously assembled matrix structure!\n");
            }
        if (Sparse_Data->m!=global_num_row)
            {
            mexPrintf("Error with this matrix:   %s.\n", Name);
            mexErrMsgTxt("Number of rows in previous matrix does not match what the new matrix should be.\n");
            }
        if (Sparse_Data->n!=global_num_col)
            {
            mexPrintf("Error with this matrix:   %s.\n", Name);
            mexErrMsgTxt("Number of columns in previous matrix does not match what the new matrix should be.\n");
            }
        // create MatrixReassembler object (cf. David Bindel)
        MAT = new MatrixReassembler(Sparse_Data->jc,Sparse_Data->ir,Sparse_Data->pr,global_num_row,global_num_col);
        // use previous sparse structure
        }
    else // create MatrixAssembler object (cf. David Bindel)
        MAT = new MatrixAssembler(global_num_row,global_num_col); // assemble from scratch
}
/***************************************************************************************/

