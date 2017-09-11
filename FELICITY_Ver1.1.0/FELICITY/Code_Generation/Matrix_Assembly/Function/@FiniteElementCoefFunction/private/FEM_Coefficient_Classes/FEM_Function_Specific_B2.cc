
    // get the number of columns (components)
    int CHK_Num_Comp = (int) mxGetN(Values);
    // get the number of vertices
    int Temp_Num_Nodes = (int) mxGetM(Values);

    /* BEGIN: Error Checking */
    if (CHK_Num_Comp != Num_Comp)
        {
        mexPrintf("ERROR: Function Nodal Value List for %s has %d columns; expected %d columns.\n", Name, CHK_Num_Comp, Num_Comp);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s!\n",Name,Type);
        mexErrMsgTxt("ERROR: number of function components must match!");
        }
    if (Temp_Num_Nodes < basis_func->Num_Nodes)
        {
        mexPrintf("ERROR: Function Nodal Value List for %s has %d rows; expected at least %d rows.\n", Name, Temp_Num_Nodes, basis_func->Num_Nodes);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s, \n",Name,Type);
        mexPrintf("ERROR:     and make sure you are using the correct DoFmap.\n");
        mexErrMsgTxt("ERROR: number of given function values must >= what the DoFmap references!");
        }
    if (basis_func->Num_Basis != NB)
        {
        mexPrintf("ERROR: Coefficient Function %s has %d basis functions,\n", Name, NB);
        mexPrintf("ERROR:         but reference function space has %d basis functions,\n", basis_func->Num_Basis);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s, \n",Name,Type);
        mexPrintf("ERROR:     and make sure you are using the correct DoFmap.\n");
        mexErrMsgTxt("ERROR: number of basis functions describing function must match!");
        }
    /* END: Error Checking */

    // if we make it here, then update the number of DoFs
    Num_Nodes = Temp_Num_Nodes;
    // split up the columns of the node data
    Node_Value[0] = mxGetPr(Values);
    for (int nc_i = 1; (nc_i < Num_Comp); nc_i++)
        Node_Value[nc_i] = Node_Value[nc_i-1] + Num_Nodes;
}
/***************************************************************************************/

