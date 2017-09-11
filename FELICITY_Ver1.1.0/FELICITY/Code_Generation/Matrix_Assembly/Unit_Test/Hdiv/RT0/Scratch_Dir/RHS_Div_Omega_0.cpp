
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = (*P0_phi_restricted_to_Omega->Func_f_Value)[i][qp].a*sin(geom_Omega_embedded_in_Omega_restricted_to_Omega->Map_PHI[qp].v[0]*3.141592653589793)*sin(geom_Omega_embedded_in_Omega_restricted_to_Omega->Map_PHI[qp].v[1]*3.141592653589793)*1.973920880217872E1;
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
