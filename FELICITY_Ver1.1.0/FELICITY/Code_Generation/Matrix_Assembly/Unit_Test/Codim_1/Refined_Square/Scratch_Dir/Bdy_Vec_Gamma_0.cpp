
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = M_Space_phi_restricted_to_Gamma->Func_f_d_ds[i][qp].a*old_soln_restricted_to_Gamma->Func_f_Grad[0][qp].v[1];
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
