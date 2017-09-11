
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  t2 = old_p_restricted_to_Omega->Func_f_Value[0][qp].a-sin(geom_Omega_embedded_in_Omega_restricted_to_Omega->Map_PHI[qp].v[0]*3.141592653589793)*sin(geom_Omega_embedded_in_Omega_restricted_to_Omega->Map_PHI[qp].v[1]*3.141592653589793);
        double  integrand = t2*t2;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
