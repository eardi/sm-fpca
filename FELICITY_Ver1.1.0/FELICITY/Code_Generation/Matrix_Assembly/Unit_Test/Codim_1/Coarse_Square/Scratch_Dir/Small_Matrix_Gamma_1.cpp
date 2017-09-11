
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  integrand = sqrt(2.0)*(geom_Gamma_embedded_in_Omega_restricted_to_Gamma->Map_Normal_Vector[0].v[0]+geom_Gamma_embedded_in_Omega_restricted_to_Gamma->Map_Normal_Vector[0].v[1])*(1.0/2.0);
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
