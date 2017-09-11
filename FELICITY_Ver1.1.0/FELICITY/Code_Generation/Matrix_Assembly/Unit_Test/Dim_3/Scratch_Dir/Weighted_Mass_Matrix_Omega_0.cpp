
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = 0; i < ROW_NB; i++)
                {
                double  integrand = my_f_restricted_to_Omega->Func_f_Value[0][qp].a*my_f_restricted_to_Omega->Func_f_Grad[1][qp].v[1]*(*Scalar_P1_phi_restricted_to_Omega->Func_f_Value)[j][qp].a*(*Scalar_P1_phi_restricted_to_Omega->Func_f_Value)[i][qp].a;
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }
