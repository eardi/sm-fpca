
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  integrand = geom_Gamma_embedded_in_Omega_restricted_to_Gamma->Map_PHI[qp].v[0];
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
