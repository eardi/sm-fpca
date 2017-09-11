
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = (*Scalar_P2_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a*cos(geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_PHI[qp].v[1])*sin(geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_PHI[qp].v[0])*sin(geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_PHI[qp].v[2]);
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
