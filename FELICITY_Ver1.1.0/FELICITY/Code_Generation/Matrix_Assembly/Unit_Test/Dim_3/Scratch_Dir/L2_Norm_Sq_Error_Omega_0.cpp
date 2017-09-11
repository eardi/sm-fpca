
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  t2 = old_soln_restricted_to_Omega->Func_f_Value[0][qp].a-exp(geom_Omega_embedded_in_Omega_restricted_to_Omega->Map_PHI[qp].v[0]);
        double  integrand = t2*t2;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
