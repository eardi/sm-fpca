
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = 0; i < ROW_NB; i++)
                {
                double  integrand = (*Scalar_P2_phi_restricted_to_Sigma->Func_f_Value)[j][qp].a*(*Scalar_P2_phi_restricted_to_Sigma->Func_f_Value)[i][qp].a;
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }
