/*
============================================================================================
   Some simple structs for representing small-scale linear algebra.

   Copyright (c) 08-09-2014,  Shawn W. Walker
============================================================================================
*/

static const double         PI = 3.14159265358979323846264338327950288419716939;
static const double     SQRT_2 = 1.4142135623730950488016887242097;
static const double INV_SQRT_2 = 0.7071067811865475244008443621048;

// define basic linear algebra structures

/***************************************************************************************/
/* scalars */
struct SCALAR
{
    double a;
    SCALAR () {}
    SCALAR (const double& a_in) : a(a_in) {}
    inline void Set_To_Zero () { a = 0.0; }
    inline void Set_Equal_To (const double& A0) { a = A0; }
};

/***************************************************************************************/
/* vectors */
struct VEC_1x1
{
    double v[1];
    VEC_1x1 () {}
    VEC_1x1 (const double& v0) { Set_Equal_To(v0); }
    VEC_1x1 (const double v_in[1]) { Set_Equal_To(v_in); }
    VEC_1x1 (const VEC_1x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { v[0] = 0.0; }
    inline void Set_Equal_To (const double& v0)  { v[0] = v0; }
    inline void Set_Equal_To (const double A[1]) { v[0] = A[0]; }
    inline void Set_Equal_To (const VEC_1x1& A)  { v[0] = A.v[0]; }
    inline void Copy_To_Array (double* A) const  { A[0] = v[0]; }
};
struct VEC_2x1
{
    double v[2];
    VEC_2x1 () {}
    VEC_2x1 (const double& v0, const double& v1) { Set_Equal_To(v0,v1); }
    VEC_2x1 (const double v_in[2]) { Set_Equal_To(v_in); }
    VEC_2x1 (const VEC_2x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { v[0] = 0.0; v[1] = 0.0; }
    inline void Set_Equal_To (const double& v0, const double& v1) { v[0] = v0; v[1] = v1; }
    inline void Set_Equal_To (const double A[2]) { v[0] = A[0]; v[1] = A[1]; }
    inline void Set_Equal_To (const VEC_2x1& A) { v[0] = A.v[0]; v[1] = A.v[1]; }
    inline void Copy_To_Array (double* A) const { A[0] = v[0]; A[1] = v[1]; }
};
struct VEC_3x1
{
    double v[3];
    VEC_3x1 () {}
    VEC_3x1 (const double& v0, const double& v1, const double& v2) { Set_Equal_To(v0,v1,v2); }
    VEC_3x1 (const double v_in[3]) { Set_Equal_To(v_in); }
    VEC_3x1 (const VEC_3x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { v[0] = 0.0; v[1] = 0.0; v[2] = 0.0; }
    inline void Set_Equal_To (const double& v0, const double& v1, const double& v2) { v[0] = v0; v[1] = v1; v[2] = v2; }
    inline void Set_Equal_To (const double A[3]) { v[0] = A[0]; v[1] = A[1]; v[2] = A[2]; }
    inline void Set_Equal_To (const VEC_3x1& A) { v[0] = A.v[0]; v[1] = A.v[1]; v[2] = A.v[2]; }
    inline void Copy_To_Array (double* A) const { A[0] = v[0]; A[1] = v[1]; A[2] = v[2]; }
};

/***************************************************************************************/
/* matrices */
struct MAT_1x1
{
    double m[1][1];
    MAT_1x1 () {}
    MAT_1x1 (const MAT_1x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0; }
    inline void Set_Equal_To (const MAT_1x1& A)
                               { m[0][0] = A.m[0][0]; }
};
struct MAT_2x1
{
    double m[2][1];
    MAT_2x1 () {}
    MAT_2x1 (const MAT_2x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0;
                                 m[1][0] = 0.0; }
    inline void Set_Equal_To (const MAT_2x1& A)
                               { m[0][0] = A.m[0][0];
                                 m[1][0] = A.m[1][0]; }
};
struct MAT_2x2
{
    double m[2][2];
    MAT_2x2 () {}
    MAT_2x2 (const MAT_2x2& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0; m[0][1] = 0.0;
                                 m[1][0] = 0.0; m[1][1] = 0.0; }
    inline void Set_Equal_To (const MAT_2x2& A)
                               { m[0][0] = A.m[0][0]; m[0][1] = A.m[0][1];
                                 m[1][0] = A.m[1][0]; m[1][1] = A.m[1][1]; }
};
struct MAT_3x1
{
    double m[3][1];
    MAT_3x1 () {}
    MAT_3x1 (const MAT_3x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0;
                                 m[1][0] = 0.0;
                                 m[2][0] = 0.0; }
    inline void Set_Equal_To (const MAT_3x1& A)
                               { m[0][0] = A.m[0][0];
                                 m[1][0] = A.m[1][0];
                                 m[2][0] = A.m[2][0]; }
};
struct MAT_3x2
{
    double m[3][2];
    MAT_3x2 () {}
    MAT_3x2 (const MAT_3x2& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0; m[0][1] = 0.0;
                                 m[1][0] = 0.0; m[1][1] = 0.0;
                                 m[2][0] = 0.0; m[2][1] = 0.0; }
    inline void Set_Equal_To (const MAT_3x2& A)
                               { m[0][0] = A.m[0][0]; m[0][1] = A.m[0][1];
                                 m[1][0] = A.m[1][0]; m[1][1] = A.m[1][1];
                                 m[2][0] = A.m[2][0]; m[2][1] = A.m[2][1]; }
};
struct MAT_3x3
{
    double m[3][3];
    MAT_3x3 () {}
    MAT_3x3 (const MAT_3x3& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0] = 0.0; m[0][1] = 0.0; m[0][2] = 0.0;
                                 m[1][0] = 0.0; m[1][1] = 0.0; m[1][2] = 0.0;
                                 m[2][0] = 0.0; m[2][1] = 0.0; m[2][2] = 0.0; }
    inline void Set_Equal_To (const MAT_3x3& A)
                               { m[0][0] = A.m[0][0]; m[0][1] = A.m[0][1]; m[0][2] = A.m[0][2];
                                 m[1][0] = A.m[1][0]; m[1][1] = A.m[1][1]; m[1][2] = A.m[1][2];
                                 m[2][0] = A.m[2][0]; m[2][1] = A.m[2][1]; m[2][2] = A.m[2][2]; }
    inline void Set_Cross_Product (const double& v0, const double& v1, const double& v2)
	// define matrix to represent the cross-product operation in 3-D
	{ m[0][0] = 0.0;
	  m[0][1] = -v2;
	  m[0][2] =  v1;

	  m[1][0] =  v2;
	  m[1][1] = 0.0;
	  m[1][2] = -v0;

	  m[2][0] = -v1;
	  m[2][1] =  v0;
	  m[2][2] = 0.0; }
};

/***************************************************************************************/
/* 3rd order tensors (i.e. multi-matrix) */
struct MAT_1x1x1
{
    double m[1][1][1];
    MAT_1x1x1 () {}
    MAT_1x1x1 (const MAT_1x1x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero () { m[0][0][0] = 0.0; }
    inline void Set_Equal_To (const MAT_1x1x1& A) { m[0][0][0] = A.m[0][0][0]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_1x1& A) const
    { A.m[0][0] = m[k][0][0]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_1x1& A)
    { m[k][0][0] = A.m[0][0]; }
};
struct MAT_2x1x1
{
    double m[2][1][1];
    MAT_2x1x1 () {}
    MAT_2x1x1 (const MAT_2x1x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero ()
    { m[0][0][0] = 0.0;
      m[1][0][0] = 0.0; }
    inline void Set_Equal_To (const MAT_2x1x1& A)
    { m[0][0][0] = A.m[0][0][0];
      m[1][0][0] = A.m[1][0][0]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_1x1& A) const
    { A.m[0][0] = m[k][0][0]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_1x1& A)
    { m[k][0][0] = A.m[0][0]; }
};
struct MAT_2x2x2
{
    double m[2][2][2];
    MAT_2x2x2 () {}
    MAT_2x2x2 (const MAT_2x2x2& A) { Set_Equal_To(A); }
    inline void Set_To_Zero ()
    { m[0][0][0] = 0.0;
      m[0][0][1] = 0.0;
      m[0][1][0] = 0.0;
      m[0][1][1] = 0.0;

      m[1][0][0] = 0.0;
      m[1][0][1] = 0.0;
      m[1][1][0] = 0.0;
      m[1][1][1] = 0.0; }
    inline void Set_Equal_To (const MAT_2x2x2& A)
    { m[0][0][0] = A.m[0][0][0];
      m[0][0][1] = A.m[0][0][1];
      m[0][1][0] = A.m[0][1][0];
      m[0][1][1] = A.m[0][1][1];

      m[1][0][0] = A.m[1][0][0];
      m[1][0][1] = A.m[1][0][1];
      m[1][1][0] = A.m[1][1][0];
      m[1][1][1] = A.m[1][1][1]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_2x2& A) const
    { A.m[0][0] = m[k][0][0];
      A.m[0][1] = m[k][0][1];
      A.m[1][0] = m[k][1][0];
      A.m[1][1] = m[k][1][1]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_2x2& A)
    { m[k][0][0] = A.m[0][0];
      m[k][0][1] = A.m[0][1];
      m[k][1][0] = A.m[1][0];
      m[k][1][1] = A.m[1][1]; }
};
struct MAT_3x1x1
{
    double m[3][1][1];
    MAT_3x1x1 () {}
    MAT_3x1x1 (const MAT_3x1x1& A) { Set_Equal_To(A); }
    inline void Set_To_Zero ()
    { m[0][0][0] = 0.0;
      m[1][0][0] = 0.0;
      m[2][0][0] = 0.0; }
    inline void Set_Equal_To (const MAT_3x1x1& A)
    { m[0][0][0] = A.m[0][0][0];
      m[1][0][0] = A.m[1][0][0];
      m[2][0][0] = A.m[2][0][0]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_1x1& A) const
    { A.m[0][0] = m[k][0][0]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_1x1& A)
    { m[k][0][0] = A.m[0][0]; }
};
struct MAT_3x2x2
{
    double m[3][2][2];
    MAT_3x2x2 () {}
    MAT_3x2x2 (const MAT_3x2x2& A) { Set_Equal_To(A); }
    inline void Set_To_Zero ()
    { m[0][0][0] = 0.0;
      m[0][0][1] = 0.0;
      m[0][1][0] = 0.0;
      m[0][1][1] = 0.0;

      m[1][0][0] = 0.0;
      m[1][0][1] = 0.0;
      m[1][1][0] = 0.0;
      m[1][1][1] = 0.0;

      m[2][0][0] = 0.0;
      m[2][0][1] = 0.0;
      m[2][1][0] = 0.0;
      m[2][1][1] = 0.0; }
    inline void Set_Equal_To (const MAT_3x2x2& A)
    { m[0][0][0] = A.m[0][0][0];
      m[0][0][1] = A.m[0][0][1];
      m[0][1][0] = A.m[0][1][0];
      m[0][1][1] = A.m[0][1][1];

      m[1][0][0] = A.m[1][0][0];
      m[1][0][1] = A.m[1][0][1];
      m[1][1][0] = A.m[1][1][0];
      m[1][1][1] = A.m[1][1][1];

      m[2][0][0] = A.m[2][0][0];
      m[2][0][1] = A.m[2][0][1];
      m[2][1][0] = A.m[2][1][0];
      m[2][1][1] = A.m[2][1][1]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_2x2& A) const
    { A.m[0][0] = m[k][0][0];
      A.m[0][1] = m[k][0][1];
      A.m[1][0] = m[k][1][0];
      A.m[1][1] = m[k][1][1]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_2x2& A)
    { m[k][0][0] = A.m[0][0];
      m[k][0][1] = A.m[0][1];
      m[k][1][0] = A.m[1][0];
      m[k][1][1] = A.m[1][1]; }
};
struct MAT_3x3x3
{
    double m[3][3][3];
    MAT_3x3x3 () {}
    MAT_3x3x3 (const MAT_3x3x3& A) { Set_Equal_To(A); }
    inline void Set_To_Zero ()
    { m[0][0][0] = 0.0;
      m[0][0][1] = 0.0;
      m[0][0][2] = 0.0;
      m[0][1][0] = 0.0;
      m[0][1][1] = 0.0;
      m[0][1][2] = 0.0;
      m[0][2][0] = 0.0;
      m[0][2][1] = 0.0;
      m[0][2][2] = 0.0;

      m[1][0][0] = 0.0;
      m[1][0][1] = 0.0;
      m[1][0][2] = 0.0;
      m[1][1][0] = 0.0;
      m[1][1][1] = 0.0;
      m[1][1][2] = 0.0;
      m[1][2][0] = 0.0;
      m[1][2][1] = 0.0;
      m[1][2][2] = 0.0;

      m[2][0][0] = 0.0;
      m[2][0][1] = 0.0;
      m[2][0][2] = 0.0;
      m[2][1][0] = 0.0;
      m[2][1][1] = 0.0;
      m[2][1][2] = 0.0;
      m[2][2][0] = 0.0;
      m[2][2][1] = 0.0;
      m[2][2][2] = 0.0; }
    inline void Set_Equal_To (const MAT_3x3x3& A)
    { m[0][0][0] = A.m[0][0][0];
      m[0][0][1] = A.m[0][0][1];
      m[0][0][2] = A.m[0][0][2];
      m[0][1][0] = A.m[0][1][0];
      m[0][1][1] = A.m[0][1][1];
      m[0][1][2] = A.m[0][1][2];
      m[0][2][0] = A.m[0][2][0];
      m[0][2][1] = A.m[0][2][1];
      m[0][2][2] = A.m[0][2][2];

      m[1][0][0] = A.m[1][0][0];
      m[1][0][1] = A.m[1][0][1];
      m[1][0][2] = A.m[1][0][2];
      m[1][1][0] = A.m[1][1][0];
      m[1][1][1] = A.m[1][1][1];
      m[1][1][2] = A.m[1][1][2];
      m[1][2][0] = A.m[1][2][0];
      m[1][2][1] = A.m[1][2][1];
      m[1][2][2] = A.m[1][2][2];

      m[2][0][0] = A.m[2][0][0];
      m[2][0][1] = A.m[2][0][1];
      m[2][0][2] = A.m[2][0][2];
      m[2][1][0] = A.m[2][1][0];
      m[2][1][1] = A.m[2][1][1];
      m[2][1][2] = A.m[2][1][2];
      m[2][2][0] = A.m[2][2][0];
      m[2][2][1] = A.m[2][2][1];
      m[2][2][2] = A.m[2][2][2]; }
    inline void Extract_Comp_Matrix (const unsigned int& k, MAT_3x3& A) const
    { A.m[0][0] = m[k][0][0];
      A.m[0][1] = m[k][0][1];
      A.m[0][2] = m[k][0][2];

      A.m[1][0] = m[k][1][0];
      A.m[1][1] = m[k][1][1];
      A.m[1][2] = m[k][1][2];

      A.m[2][0] = m[k][2][0];
      A.m[2][1] = m[k][2][1];
      A.m[2][2] = m[k][2][2]; }
    inline void Set_Comp_Matrix (const unsigned int& k, const MAT_3x3& A)
    { m[k][0][0] = A.m[0][0];
      m[k][0][1] = A.m[0][1];
      m[k][0][2] = A.m[0][2];

      m[k][1][0] = A.m[1][0];
      m[k][1][1] = A.m[1][1];
      m[k][1][2] = A.m[1][2];

      m[k][2][0] = A.m[2][0];
      m[k][2][1] = A.m[2][1];
      m[k][2][2] = A.m[2][2]; }
};

/***/
