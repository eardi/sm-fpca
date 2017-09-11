
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = geom_Sigma_embedded_in_Sigma_restricted_to_Sigma->Map_Total_Curvature[qp].a*(*Scalar_P2_phi_restricted_to_Sigma->Func_f_Value)[i][qp].a;
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
