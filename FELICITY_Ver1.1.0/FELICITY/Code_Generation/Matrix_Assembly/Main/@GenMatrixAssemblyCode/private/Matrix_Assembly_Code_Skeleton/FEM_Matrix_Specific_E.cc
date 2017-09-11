
	// BEGIN: simple error check
	if (row_basis_func->Num_Comp!=ROW_NC)
		{
        mexPrintf("ERROR: The number of components for the row FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d row components.\n",SpecificFEM_str,ROW_NC);
        mexPrintf("Actual number of row components is %d.\n",row_basis_func->Num_Comp);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (col_basis_func->Num_Comp!=COL_NC)
		{
        mexPrintf("ERROR: The number of components for the column FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d col components.\n",SpecificFEM_str,COL_NC);
        mexPrintf("Actual number of col components is %d.\n",col_basis_func->Num_Comp);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (row_basis_func->Num_Basis!=ROW_NB)
		{
        mexPrintf("ERROR: The number of basis functions in the row FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d row basis functions.\n",SpecificFEM_str,ROW_NB);
        mexPrintf("Actual number of row components is %d.\n",row_basis_func->Num_Basis);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (col_basis_func->Num_Basis!=COL_NB)
		{
        mexPrintf("ERROR: The number of basis functions in the column FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d col basis functions.\n",SpecificFEM_str,COL_NB);
        mexPrintf("Actual number of row components is %d.\n",col_basis_func->Num_Basis);
        mexErrMsgTxt("Please report this error!\n");
        }
	//   END: simple error check

    // set the 'Name' of the FEM matrix
    Name = (char*) SpecificFEM_str;      // this should be the same as the Class identifier
    Num_Sub_Matrices = row_basis_func->Num_Comp*col_basis_func->Num_Comp; // may not use all of these...
    
    // get the size of the global matrix
    global_num_row = row_basis_func->Num_Comp*row_basis_func->Num_Nodes;
    global_num_col = col_basis_func->Num_Comp*col_basis_func->Num_Nodes;

