
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = 0; i < ROW_NB; i++)
                {
                double  integrand = (*M_Space_phi_restricted_to_Gamma->Func_f_Value)[j][qp].a*(*E_Space_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a;
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }
