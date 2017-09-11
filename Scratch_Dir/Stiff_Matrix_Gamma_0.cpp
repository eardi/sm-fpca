
    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = j; i < ROW_NB; i++)
                {
                double  integrand = Vh_phi_restricted_to_Gamma->Func_f_Grad[j][qp].v[0]*Vh_phi_restricted_to_Gamma->Func_f_Grad[i][qp].v[0]+Vh_phi_restricted_to_Gamma->Func_f_Grad[j][qp].v[1]*Vh_phi_restricted_to_Gamma->Func_f_Grad[i][qp].v[1]+Vh_phi_restricted_to_Gamma->Func_f_Grad[j][qp].v[2]*Vh_phi_restricted_to_Gamma->Func_f_Grad[i][qp].v[2];
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }

    // Copy the lower triangular entries to the upper triangular part (by symmetry)
    for (unsigned int j = 0; j < COL_NB; j++)
        {
        for (unsigned int i = j+1; i < ROW_NB; i++)
            {
            A[i*ROW_NB + j] = A[j*ROW_NB + i];
            }
        }
