
    // Compute single entry using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        double  integrand = geom_Sigma_embedded_in_Sigma_restricted_to_Sigma->Map_Mesh_Size[0].a;
        A[0] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
        }
