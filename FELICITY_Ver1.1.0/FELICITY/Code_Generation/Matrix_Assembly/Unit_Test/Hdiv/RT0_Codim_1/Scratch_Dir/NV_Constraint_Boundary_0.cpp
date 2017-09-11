
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = 0; i < ROW_NB; i++)
                {
                double  integrand = (*P0_phi_restricted_to_Boundary->Func_f_Value)[i][qp].a*(geom_Boundary_embedded_in_Omega_restricted_to_Boundary->Map_Normal_Vector[0].v[0]*RT0_phi_restricted_to_Boundary->Func_vv_Value[j][qp].v[0]+geom_Boundary_embedded_in_Omega_restricted_to_Boundary->Map_Normal_Vector[0].v[1]*RT0_phi_restricted_to_Boundary->Func_vv_Value[j][qp].v[1]);
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }
