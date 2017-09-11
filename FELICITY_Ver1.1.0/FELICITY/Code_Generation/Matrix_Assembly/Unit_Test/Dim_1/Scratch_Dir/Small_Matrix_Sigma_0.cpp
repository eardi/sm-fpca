
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  t2 = old_soln_restricted_to_Sigma->Func_f_Value[0][qp].a-exp(geom_Sigma_embedded_in_Sigma_restricted_to_Sigma->Map_PHI[qp].v[0]);
        double  integrand = t2*t2;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
