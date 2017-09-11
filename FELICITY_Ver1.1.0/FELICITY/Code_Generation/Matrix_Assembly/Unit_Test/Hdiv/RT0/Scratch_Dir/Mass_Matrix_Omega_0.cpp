
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = 0; i < ROW_NB; i++)
                {
                double  integrand = RT0_phi_restricted_to_Omega->Func_vv_Value[j][qp].v[0]*RT0_phi_restricted_to_Omega->Func_vv_Value[i][qp].v[0]+RT0_phi_restricted_to_Omega->Func_vv_Value[j][qp].v[1]*RT0_phi_restricted_to_Omega->Func_vv_Value[i][qp].v[1];
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }
