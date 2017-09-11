
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int i = 0; i < ROW_NB; i++)
            {
            double  integrand = geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_Normal_Vector[qp].v[1]*(*Vector_P1_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a;
            A[i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
            }
        }
