
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  integrand = my_f_restricted_to_Sigma->Func_f_d_ds[0][qp].a;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
