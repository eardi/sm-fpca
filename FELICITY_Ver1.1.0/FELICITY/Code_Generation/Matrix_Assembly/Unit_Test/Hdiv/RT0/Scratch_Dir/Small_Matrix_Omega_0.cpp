
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  integrand = old_vel_restricted_to_Omega->Func_vv_Div[0][qp].a;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
