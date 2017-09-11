

    // declare the FEM interpolation object
    Generic_FEM_Interpolation*   FEM_Interp_obj;
    FEM_Interp_obj = new Generic_FEM_Interpolation(prhs);

    /*** Interpolate! ***/
    FEM_Interp_obj->Evaluate_Interpolations();
	
	// output interpolations back to MATLAB
    FEM_Interp_obj->Init_Output_Data(plhs);
