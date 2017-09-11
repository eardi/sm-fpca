
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = (*Scalar_P2_phi_restricted_to_Sigma->Func_f_Value)[i][qp].a*foo(geom_Sigma_embedded_in_Sigma_restricted_to_Sigma->Map_PHI[qp].v[2]*3.141592653589793);
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
