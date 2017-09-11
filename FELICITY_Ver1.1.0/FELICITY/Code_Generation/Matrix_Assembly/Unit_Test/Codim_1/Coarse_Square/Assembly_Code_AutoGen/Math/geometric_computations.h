/*
============================================================================================
   Some simple routines for computing geometric quantities.
   
   Copyright (c) 02-26-2012,  Shawn W. Walker
============================================================================================
*/

// define geometric computations

/***************************************************************************************/
/* compute normal vector */
void Compute_Normal_Vector (const MAT_2x1& G, const SCALAR& Inv_Det_Jac, VEC_2x1& N)
{
	// rotate the tangent vector
	N.v[0] =  G.m[1][0] * Inv_Det_Jac.a;
	N.v[1] = -G.m[0][0] * Inv_Det_Jac.a;
}
void Compute_Normal_Vector (const MAT_3x2& G, const SCALAR& Inv_Det_Jac, VEC_3x1& N)
{
	// compute cross product and normalize it
	N.v[0] =  Inv_Det_Jac.a * (G.m[1][0]*G.m[2][1] - G.m[1][1]*G.m[2][0]);
	N.v[1] = -Inv_Det_Jac.a * (G.m[0][0]*G.m[2][1] - G.m[0][1]*G.m[2][0]);
	N.v[2] =  Inv_Det_Jac.a * (G.m[0][0]*G.m[1][1] - G.m[0][1]*G.m[1][0]);
}

/***************************************************************************************/
/* compute tangent space projection */
void Compute_Tangent_Space_Projection_TopDim_1 (const VEC_2x1& TV, MAT_2x2& Proj)
{
	Proj.m[0][0] = TV.v[0] * TV.v[0];
	Proj.m[0][1] = TV.v[0] * TV.v[1];
	Proj.m[1][0] = Proj.m[0][1];
	Proj.m[1][1] = TV.v[1] * TV.v[1];
}
void Compute_Tangent_Space_Projection_TopDim_1 (const VEC_3x1& TV, MAT_3x3& Proj)
{
	Proj.m[0][0] = TV.v[0] * TV.v[0];
	Proj.m[0][1] = TV.v[0] * TV.v[1];
	Proj.m[0][2] = TV.v[0] * TV.v[2];
	
	Proj.m[1][0] = Proj.m[0][1];
	Proj.m[1][1] = TV.v[1] * TV.v[1];
	Proj.m[1][2] = TV.v[1] * TV.v[2];
	
	Proj.m[2][0] = Proj.m[0][2];
	Proj.m[2][1] = Proj.m[1][2];
	Proj.m[2][2] = TV.v[2] * TV.v[2];
}
void Compute_Tangent_Space_Projection_TopDim_2 (MAT_2x2& Proj)
{
	Proj.m[0][0] = 1.0;
	Proj.m[0][1] = 0.0;
	Proj.m[1][0] = 0.0;
	Proj.m[1][1] = 1.0;
}
void Compute_Tangent_Space_Projection_TopDim_2 (const VEC_3x1& NV, MAT_3x3& Proj)
{
	Proj.m[0][0] = 1.0 - NV.v[0] * NV.v[0];
	Proj.m[0][1] = 0.0 - NV.v[0] * NV.v[1];
	Proj.m[0][2] = 0.0 - NV.v[0] * NV.v[2];
	
	Proj.m[1][0] = Proj.m[0][1];
	Proj.m[1][1] = 1.0 - NV.v[1] * NV.v[1];
	Proj.m[1][2] = 0.0 - NV.v[1] * NV.v[2];
	
	Proj.m[2][0] = Proj.m[0][2];
	Proj.m[2][1] = Proj.m[1][2];
	Proj.m[2][2] = 1.0 - NV.v[2] * NV.v[2];
}
void Compute_Tangent_Space_Projection_TopDim_3 (MAT_3x3& Proj)
{
	Proj.m[0][0] = 1.0;
	Proj.m[0][1] = 0.0;
	Proj.m[0][2] = 0.0;
	
	Proj.m[1][0] = 0.0;
	Proj.m[1][1] = 1.0;
	Proj.m[1][2] = 0.0;
	
	Proj.m[2][0] = 0.0;
	Proj.m[2][1] = 0.0;
	Proj.m[2][2] = 1.0;
}

/***************************************************************************************/
/* compute second fundamental form (differential geometry) */
void Compute_2nd_Fundamental_Form (const MAT_2x1x1& Hess, const VEC_2x1& NV, MAT_1x1& Form)
{
	// compute dot-product with normal vector
	Form.m[0][0] = Hess.m[0][0][0] * NV.v[0] + Hess.m[1][0][0] * NV.v[1];
}
void Compute_2nd_Fundamental_Form (const MAT_3x2x2& Hess, const VEC_3x1& NV, MAT_2x2& Form)
{
	// compute dot-product with normal vector
	Form.m[0][0] = Hess.m[0][0][0] * NV.v[0] + Hess.m[1][0][0] * NV.v[1] + Hess.m[2][0][0] * NV.v[2];
	Form.m[0][1] = Hess.m[0][0][1] * NV.v[0] + Hess.m[1][0][1] * NV.v[1] + Hess.m[2][0][1] * NV.v[2];
	Form.m[1][0] = Form.m[0][1]; // symmetry!
	Form.m[1][1] = Hess.m[0][1][1] * NV.v[0] + Hess.m[1][1][1] * NV.v[1] + Hess.m[2][1][1] * NV.v[2];
}

/***************************************************************************************/
/* compute total curvature vector (differential geometry) */
void Compute_Total_Curvature_Vector (const VEC_2x1& NV, const SCALAR& Curv, VEC_2x1& CV)
{
	// multiply scalar (signed) curvature by normal vector
	CV.v[0] = Curv.a * NV.v[0];
	CV.v[1] = Curv.a * NV.v[1];
}
void Compute_Total_Curvature_Vector (const MAT_3x1x1& Hess, const MAT_1x1& Inv_Metric,
                                     const VEC_3x1& TV, VEC_3x1& CV)
{
	// compute total curvature vector (basic differential geometry)
	const double T_dot_H = Hess.m[0][0][0]*TV.v[0] + Hess.m[1][0][0]*TV.v[1] + Hess.m[2][0][0]*TV.v[2];
	CV.v[0] = (-Hess.m[0][0][0] + T_dot_H*TV.v[0]) * Inv_Metric.m[0][0];
	CV.v[1] = (-Hess.m[1][0][0] + T_dot_H*TV.v[1]) * Inv_Metric.m[0][0];
	CV.v[2] = (-Hess.m[2][0][0] + T_dot_H*TV.v[2]) * Inv_Metric.m[0][0];
}
void Compute_Total_Curvature_Vector (const VEC_3x1& NV, const SCALAR& Curv, VEC_3x1& CV)
{
	// multiply total curvature by normal vector
	CV.v[0] = Curv.a * NV.v[0];
	CV.v[1] = Curv.a * NV.v[1];
	CV.v[2] = Curv.a * NV.v[2];
}

/***************************************************************************************/
/* compute total curvature (differential geometry) */
void Compute_Total_Curvature (const MAT_1x1& Form_2nd, const MAT_1x1& Inv_Metric, SCALAR& Total_Curv)
{
	// total curvature = - S : M^{-1} (contract the second fundamental form tensor with the inverse metric tensor)
	Total_Curv.a = -(Form_2nd.m[0][0] * Inv_Metric.m[0][0]);
}
void Compute_Total_Curvature (const MAT_2x2& Form_2nd, const MAT_2x2& Inv_Metric, SCALAR& Total_Curv)
{
	// total curvature = - S : M^{-1} (contract the second fundamental form tensor with the inverse metric tensor)
	Total_Curv.a = -(Form_2nd.m[0][0] * Inv_Metric.m[0][0] + 2*Form_2nd.m[0][1] * Inv_Metric.m[0][1] +
	                 Form_2nd.m[1][1] * Inv_Metric.m[1][1]); // used symmetry here
}
void Compute_Total_Curvature (const VEC_3x1& CV, SCALAR& Curv)
{
	// compute the magnitude of the curvature vector
	Curv.a = sqrt(CV.v[0]*CV.v[0] + CV.v[1]*CV.v[1] + CV.v[2]*CV.v[2]);
}

/***/
