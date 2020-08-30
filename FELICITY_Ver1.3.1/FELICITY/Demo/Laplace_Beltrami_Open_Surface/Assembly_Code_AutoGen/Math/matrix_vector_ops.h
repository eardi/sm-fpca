/*
============================================================================================
   Some simple math routines for computing small-scale linear algebra.

   Copyright (c) 03-27-2018,  Shawn W. Walker
============================================================================================
*/

// simple absolute value!
inline double my_abs(const double& value)
{
    if (value < 0)
        return -value;
    else
        return value;
}

// define basic scalar operations

/***************************************************************************************/
/* multiply: c = a * b ; square it c = a*a*/
inline void Scalar_Mult_Scalar (const SCALAR& A, const SCALAR& B, SCALAR& C)
{
    C.a = A.a * B.a;
}
inline void Scalar_Squared (const SCALAR& A, SCALAR& C)
{
    C.a = A.a * A.a;
}

// define basic vector operations

/***************************************************************************************/
/* dot-product: a.b */
inline double Dot_Product (const VEC_2x1& A, const VEC_2x1& B)
{
    return A.v[0]*B.v[0] + A.v[1]*B.v[1];
}
inline double Dot_Product (const VEC_3x1& A, const VEC_3x1& B)
{
    return A.v[0]*B.v[0] + A.v[1]*B.v[1] + A.v[2]*B.v[2];
}

/***************************************************************************************/
/* Euclidean length of a vector |V| */
inline double l2_norm (const VEC_1x1& A)
{
    if (A.v[0] < 0)
        return -A.v[0];
    else
        return  A.v[0];
}
inline double l2_norm (const VEC_2x1& A)
{
    return sqrt(Dot_Product(A,A));
}
inline double l2_norm (const VEC_3x1& A)
{
    return sqrt(Dot_Product(A,A));
}

/***************************************************************************************/
/* cross-product: c = a x b */
inline void Cross_Product (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[1]*B.v[2] - A.v[2]*B.v[1];
    C.v[1] = A.v[2]*B.v[0] - A.v[0]*B.v[2];
    C.v[2] = A.v[0]*B.v[1] - A.v[1]*B.v[0];
}
/* cross-product matrix:  a x b = A * b, where A = [a]_x */
inline void Cross_Product_Matrix (const VEC_3x1& V, MAT_3x3& A)
{
    A.m[0][0] = 0.0;
    A.m[0][1] = -V.v[2];
    A.m[0][2] =  V.v[1];

    A.m[1][0] =  V.v[2];
    A.m[1][1] = 0.0;
    A.m[1][2] = -V.v[0];

    A.m[2][0] = -V.v[1];
    A.m[2][1] =  V.v[0];
    A.m[2][2] = 0.0;
}

/***************************************************************************************/
/* normalize vector */
inline double Normalize (const VEC_2x1& Vec_in, VEC_2x1& Vec_out)
{
    const double LENGTH = l2_norm(Vec_in);

    // normalize!
    Vec_out.v[0] = Vec_in.v[0] / LENGTH;
    Vec_out.v[1] = Vec_in.v[1] / LENGTH;

    return LENGTH;
}
inline double Normalize (const VEC_3x1& Vec_in, VEC_3x1& Vec_out)
{
    const double LENGTH = l2_norm(Vec_in);

    // normalize!
    Vec_out.v[0] = Vec_in.v[0] / LENGTH;
    Vec_out.v[1] = Vec_in.v[1] / LENGTH;
    Vec_out.v[2] = Vec_in.v[2] / LENGTH;

    return LENGTH;
}

/***************************************************************************************/
/* scale vector */
inline void Scalar_Mult_Vector (const VEC_1x1& Vec_in, const SCALAR& S, VEC_1x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
}
inline void Scalar_Mult_Vector (const VEC_2x1& Vec_in, const SCALAR& S, VEC_2x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
    Vec_out.v[1] = S.a * Vec_in.v[1];
}
inline void Scalar_Mult_Vector (const VEC_3x1& Vec_in, const SCALAR& S, VEC_3x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
    Vec_out.v[1] = S.a * Vec_in.v[1];
    Vec_out.v[2] = S.a * Vec_in.v[2];
}
inline void Scalar_Mult_Vector (const VEC_1x1& Vec_in, const double& a, VEC_1x1& Vec_out)
{
    Vec_out.v[0] = a * Vec_in.v[0];
}
inline void Scalar_Mult_Vector (const VEC_2x1& Vec_in, const double& a, VEC_2x1& Vec_out)
{
    Vec_out.v[0] = a * Vec_in.v[0];
    Vec_out.v[1] = a * Vec_in.v[1];
}
inline void Scalar_Mult_Vector (const VEC_3x1& Vec_in, const double& a, VEC_3x1& Vec_out)
{
    Vec_out.v[0] = a * Vec_in.v[0];
    Vec_out.v[1] = a * Vec_in.v[1];
    Vec_out.v[2] = a * Vec_in.v[2];
}

/***************************************************************************************/
/* add vectors: C = A + B */
inline void Add_Vector (const VEC_1x1& A, const VEC_1x1& B, VEC_1x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
}
inline void Add_Vector (const VEC_2x1& A, const VEC_2x1& B, VEC_2x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
    C.v[1] = A.v[1] + B.v[1];
}
inline void Add_Vector (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
    C.v[1] = A.v[1] + B.v[1];
    C.v[2] = A.v[2] + B.v[2];
}

/***************************************************************************************/
/* subtract vectors: C = A - B */
inline void Subtract_Vector (const VEC_1x1& A, const VEC_1x1& B, VEC_1x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
}
inline void Subtract_Vector (const VEC_2x1& A, const VEC_2x1& B, VEC_2x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
    C.v[1] = A.v[1] - B.v[1];
}
inline void Subtract_Vector (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
    C.v[1] = A.v[1] - B.v[1];
    C.v[2] = A.v[2] - B.v[2];
}

/***************************************************************************************/
/* add vectors: V_out = V_in + V_out */
inline void Add_Vector_Self (const VEC_1x1& V_in, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
}
inline void Add_Vector_Self (const VEC_2x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
    V_out.v[1] = V_in.v[1] + V_out.v[1];
}
inline void Add_Vector_Self (const VEC_3x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
    V_out.v[1] = V_in.v[1] + V_out.v[1];
    V_out.v[2] = V_in.v[2] + V_out.v[2];
}


// define basic matrix-vector operations

/***************************************************************************************/
/* scalar multiply matrix */
inline void Scalar_Mult_Matrix (const MAT_1x1& Mat_in, const SCALAR& S, MAT_1x1& Mat_out)
{
    Mat_out.m[0][0] = S.a * Mat_in.m[0][0];
}
inline void Scalar_Mult_Matrix (const MAT_2x2& Mat_in, const SCALAR& S, MAT_2x2& Mat_out)
{
    Mat_out.m[0][0] = S.a * Mat_in.m[0][0];
    Mat_out.m[0][1] = S.a * Mat_in.m[0][1];
    Mat_out.m[1][0] = S.a * Mat_in.m[1][0];
    Mat_out.m[1][1] = S.a * Mat_in.m[1][1];
}
inline void Scalar_Mult_Matrix (const MAT_3x3& Mat_in, const SCALAR& S, MAT_3x3& Mat_out)
{
    Mat_out.m[0][0] = S.a * Mat_in.m[0][0];
    Mat_out.m[0][1] = S.a * Mat_in.m[0][1];
    Mat_out.m[0][2] = S.a * Mat_in.m[0][2];
    Mat_out.m[1][0] = S.a * Mat_in.m[1][0];
    Mat_out.m[1][1] = S.a * Mat_in.m[1][1];
    Mat_out.m[1][2] = S.a * Mat_in.m[1][2];
    Mat_out.m[2][0] = S.a * Mat_in.m[2][0];
    Mat_out.m[2][1] = S.a * Mat_in.m[2][1];
    Mat_out.m[2][2] = S.a * Mat_in.m[2][2];
}
inline void Scalar_Mult_Matrix (const MAT_1x1& Mat_in, const double& a, MAT_1x1& Mat_out)
{
    Mat_out.m[0][0] = a * Mat_in.m[0][0];
}
inline void Scalar_Mult_Matrix (const MAT_2x2& Mat_in, const double& a, MAT_2x2& Mat_out)
{
    Mat_out.m[0][0] = a * Mat_in.m[0][0];
    Mat_out.m[0][1] = a * Mat_in.m[0][1];
    Mat_out.m[1][0] = a * Mat_in.m[1][0];
    Mat_out.m[1][1] = a * Mat_in.m[1][1];
}
inline void Scalar_Mult_Matrix (const MAT_3x2& Mat_in, const double& a, MAT_3x2& Mat_out)
{
    Mat_out.m[0][0] = a * Mat_in.m[0][0];
    Mat_out.m[0][1] = a * Mat_in.m[0][1];
    Mat_out.m[1][0] = a * Mat_in.m[1][0];
    Mat_out.m[1][1] = a * Mat_in.m[1][1];
    Mat_out.m[2][0] = a * Mat_in.m[2][0];
    Mat_out.m[2][1] = a * Mat_in.m[2][1];
}
inline void Scalar_Mult_Matrix (const MAT_3x3& Mat_in, const double& a, MAT_3x3& Mat_out)
{
    Mat_out.m[0][0] = a * Mat_in.m[0][0];
    Mat_out.m[0][1] = a * Mat_in.m[0][1];
    Mat_out.m[0][2] = a * Mat_in.m[0][2];
    Mat_out.m[1][0] = a * Mat_in.m[1][0];
    Mat_out.m[1][1] = a * Mat_in.m[1][1];
    Mat_out.m[1][2] = a * Mat_in.m[1][2];
    Mat_out.m[2][0] = a * Mat_in.m[2][0];
    Mat_out.m[2][1] = a * Mat_in.m[2][1];
    Mat_out.m[2][2] = a * Mat_in.m[2][2];
}

/***************************************************************************************/
/* add matrices: C = A + B */
inline void Add_Matrix (const MAT_1x1& A, const MAT_1x1& B, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0] + B.m[0][0];
}
inline void Add_Matrix (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] + B.m[0][0];
    C.m[0][1] = A.m[0][1] + B.m[0][1];
    C.m[1][0] = A.m[1][0] + B.m[1][0];
    C.m[1][1] = A.m[1][1] + B.m[1][1];
}
inline void Add_Matrix (const MAT_3x2& A, const MAT_3x2& B, MAT_3x2& C)
{
    C.m[0][0] = A.m[0][0] + B.m[0][0];
    C.m[0][1] = A.m[0][1] + B.m[0][1];
    C.m[1][0] = A.m[1][0] + B.m[1][0];
    C.m[1][1] = A.m[1][1] + B.m[1][1];
    C.m[2][0] = A.m[2][0] + B.m[2][0];
    C.m[2][1] = A.m[2][1] + B.m[2][1];
}
inline void Add_Matrix (const MAT_3x3& A, const MAT_3x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] + B.m[0][0];
    C.m[0][1] = A.m[0][1] + B.m[0][1];
    C.m[0][2] = A.m[0][2] + B.m[0][2];
    C.m[1][0] = A.m[1][0] + B.m[1][0];
    C.m[1][1] = A.m[1][1] + B.m[1][1];
    C.m[1][2] = A.m[1][2] + B.m[1][2];
    C.m[2][0] = A.m[2][0] + B.m[2][0];
    C.m[2][1] = A.m[2][1] + B.m[2][1];
    C.m[2][2] = A.m[2][2] + B.m[2][2];
}

/***************************************************************************************/
/* add matrices: B = A + B */
inline void Add_Matrix_Self (const MAT_1x1& A, MAT_1x1& B)
{
    B.m[0][0] = A.m[0][0] + B.m[0][0];
}
inline void Add_Matrix_Self (const MAT_2x2& A, MAT_2x2& B)
{
    B.m[0][0] = A.m[0][0] + B.m[0][0];
    B.m[0][1] = A.m[0][1] + B.m[0][1];
    B.m[1][0] = A.m[1][0] + B.m[1][0];
    B.m[1][1] = A.m[1][1] + B.m[1][1];
}
inline void Add_Matrix_Self (const MAT_3x2& A, MAT_3x2& B)
{
    B.m[0][0] = A.m[0][0] + B.m[0][0];
    B.m[0][1] = A.m[0][1] + B.m[0][1];
    B.m[1][0] = A.m[1][0] + B.m[1][0];
    B.m[1][1] = A.m[1][1] + B.m[1][1];
    B.m[2][0] = A.m[2][0] + B.m[2][0];
    B.m[2][1] = A.m[2][1] + B.m[2][1];
}
inline void Add_Matrix_Self (const MAT_3x3& A, MAT_3x3& B)
{
    B.m[0][0] = A.m[0][0] + B.m[0][0];
    B.m[0][1] = A.m[0][1] + B.m[0][1];
    B.m[0][2] = A.m[0][2] + B.m[0][2];
    B.m[1][0] = A.m[1][0] + B.m[1][0];
    B.m[1][1] = A.m[1][1] + B.m[1][1];
    B.m[1][2] = A.m[1][2] + B.m[1][2];
    B.m[2][0] = A.m[2][0] + B.m[2][0];
    B.m[2][1] = A.m[2][1] + B.m[2][1];
    B.m[2][2] = A.m[2][2] + B.m[2][2];
}

/***************************************************************************************/
/* subtract matrices: C = A - B */
inline void Subtract_Matrix (const MAT_1x1& A, const MAT_1x1& B, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0] - B.m[0][0];
}
inline void Subtract_Matrix (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] - B.m[0][0];
    C.m[0][1] = A.m[0][1] - B.m[0][1];
    C.m[1][0] = A.m[1][0] - B.m[1][0];
    C.m[1][1] = A.m[1][1] - B.m[1][1];
}
inline void Subtract_Matrix (const MAT_3x3& A, const MAT_3x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] - B.m[0][0];
    C.m[0][1] = A.m[0][1] - B.m[0][1];
    C.m[0][2] = A.m[0][2] - B.m[0][2];
    C.m[1][0] = A.m[1][0] - B.m[1][0];
    C.m[1][1] = A.m[1][1] - B.m[1][1];
    C.m[1][2] = A.m[1][2] - B.m[1][2];
    C.m[2][0] = A.m[2][0] - B.m[2][0];
    C.m[2][1] = A.m[2][1] - B.m[2][1];
    C.m[2][2] = A.m[2][2] - B.m[2][2];
}

/***************************************************************************************/
/* trace of a matrix */
// e.g. tr(A) = A_11 + A_22 + A_33
inline double Trace_Mat (const MAT_1x1& A)
{
    return A.m[0][0];
}
inline double Trace_Mat (const MAT_2x2& A)
{
    return (A.m[0][0] + A.m[1][1]);
}
inline double Trace_Mat (const MAT_3x3& A)
{
    return (A.m[0][0] + A.m[1][1] + A.m[2][2]);
}

/***************************************************************************************/
/* matrix-vector products */
// A*x, where x is a column vector and output is a column vector
inline void Mat_Vec (const MAT_1x1& A, const VEC_1x1& V_in, VEC_1x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0];
}
inline void Mat_Vec (const MAT_2x2& A, const VEC_2x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1];
}
inline void Mat_Vec (const MAT_3x2& A, const VEC_2x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1];
    V_out.v[2] = A.m[2][0] * V_in.v[0] + A.m[2][1] * V_in.v[1];
}
inline void Mat_Vec (const MAT_3x3& A, const VEC_3x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1] + A.m[0][2] * V_in.v[2];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1] + A.m[1][2] * V_in.v[2];
    V_out.v[2] = A.m[2][0] * V_in.v[0] + A.m[2][1] * V_in.v[1] + A.m[2][2] * V_in.v[2];
}

// x^t * A, where x is a column vector and output is a row vector
inline void Vec_Transpose_Mat (const VEC_2x1& V_in, const MAT_2x1& A, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0];
}
inline void Vec_Transpose_Mat (const VEC_2x1& V_in, const MAT_2x2& A, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1];
}
inline void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x1& A, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
}
inline void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x2& A, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1] + V_in.v[2] * A.m[2][1];
}
inline void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x3& A, VEC_3x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1] + V_in.v[2] * A.m[2][1];
    V_out.v[2] = V_in.v[0] * A.m[0][2] + V_in.v[1] * A.m[1][2] + V_in.v[2] * A.m[2][2];
}

// A^t * x, where x is a column vector and output is a column vector
// Note: A^t is the transpose of matrix A
inline void Mat_Transpose_Vec (const MAT_1x1& A, const VEC_1x1& V_in, VEC_1x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0];
}
inline void Mat_Transpose_Vec (const MAT_2x2& A, const VEC_2x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[1][0] * V_in.v[1];
    V_out.v[1] = A.m[0][1] * V_in.v[0] + A.m[1][1] * V_in.v[1];
}
inline void Mat_Transpose_Vec (const MAT_3x2& A, const VEC_3x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[1][0] * V_in.v[1] + A.m[2][0] * V_in.v[2];
    V_out.v[1] = A.m[0][1] * V_in.v[0] + A.m[1][1] * V_in.v[1] + A.m[2][1] * V_in.v[2];
}
inline void Mat_Transpose_Vec (const MAT_3x3& A, const VEC_3x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[1][0] * V_in.v[1] + A.m[2][0] * V_in.v[2];
    V_out.v[1] = A.m[0][1] * V_in.v[0] + A.m[1][1] * V_in.v[1] + A.m[2][1] * V_in.v[2];
    V_out.v[2] = A.m[0][2] * V_in.v[0] + A.m[1][2] * V_in.v[1] + A.m[2][2] * V_in.v[2];
}

/***************************************************************************************/
/* ``outer'' product of two vectors:
     M = A \otimes B = A * B', where A, B are column vectors. */
inline void Outer_Product_Vec (const VEC_1x1& V_A, const VEC_1x1& V_B, MAT_1x1& M)
{
    M.m[0][0] = V_A.v[0] * V_B.v[0];
}
inline void Outer_Product_Vec (const VEC_2x1& V_A, const VEC_2x1& V_B, MAT_2x2& M)
{
    M.m[0][0] = V_A.v[0] * V_B.v[0];
    M.m[0][1] = V_A.v[0] * V_B.v[1];
    M.m[1][0] = V_A.v[1] * V_B.v[0];
    M.m[1][1] = V_A.v[1] * V_B.v[1];
}
inline void Outer_Product_Vec (const VEC_3x1& V_A, const VEC_3x1& V_B, MAT_3x3& M)
{
    M.m[0][0] = V_A.v[0] * V_B.v[0];
    M.m[0][1] = V_A.v[0] * V_B.v[1];
    M.m[0][2] = V_A.v[0] * V_B.v[2];
    M.m[1][0] = V_A.v[1] * V_B.v[0];
    M.m[1][1] = V_A.v[1] * V_B.v[1];
    M.m[1][2] = V_A.v[1] * V_B.v[2];
    M.m[2][0] = V_A.v[2] * V_B.v[0];
    M.m[2][1] = V_A.v[2] * V_B.v[1];
    M.m[2][2] = V_A.v[2] * V_B.v[2];
}

/***************************************************************************************/
/* concatenate vectors into matrix:
     M = [V1, V2]. */
inline void Concatenate_Vectors (const VEC_3x1& V_1, const VEC_3x1& V_2, MAT_3x2& A)
{
    A.m[0][0] = V_1.v[0];
    A.m[1][0] = V_1.v[1];
    A.m[2][0] = V_1.v[2];

    A.m[0][1] = V_2.v[0];
    A.m[1][1] = V_2.v[1];
    A.m[2][1] = V_2.v[2];
}

/***************************************************************************************/
/* split matrix into column vectors:
     M = [V1, V2]. */
inline void Split_Matrix (const MAT_3x2& A, VEC_3x1& V_1, VEC_3x1& V_2)
{
    V_1.v[0] = A.m[0][0];
    V_1.v[1] = A.m[1][0];
    V_1.v[2] = A.m[2][0];

    V_2.v[0] = A.m[0][1];
    V_2.v[1] = A.m[1][1];
    V_2.v[2] = A.m[2][1];
}

/***************************************************************************************/
/* matrix-matrix product: C = A*B */
inline void Mat_Mat (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1];
}
inline void Mat_Mat (const MAT_3x2& A, const MAT_2x2& B, MAT_3x2& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1];
    C.m[2][0] = A.m[2][0] * B.m[0][0] + A.m[2][1] * B.m[1][0];
    C.m[2][1] = A.m[2][0] * B.m[0][1] + A.m[2][1] * B.m[1][1];
}
inline void Mat_Mat (const MAT_3x2& A, const MAT_2x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1];
    C.m[0][2] = A.m[0][0] * B.m[0][2] + A.m[0][1] * B.m[1][2];

    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1];
    C.m[1][2] = A.m[1][0] * B.m[0][2] + A.m[1][1] * B.m[1][2];

    C.m[2][0] = A.m[2][0] * B.m[0][0] + A.m[2][1] * B.m[1][0];
    C.m[2][1] = A.m[2][0] * B.m[0][1] + A.m[2][1] * B.m[1][1];
    C.m[2][2] = A.m[2][0] * B.m[0][2] + A.m[2][1] * B.m[1][2];
}
inline void Mat_Mat (const MAT_3x3& A, const MAT_3x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0] + A.m[0][2] * B.m[2][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1] + A.m[0][2] * B.m[2][1];
    C.m[0][2] = A.m[0][0] * B.m[0][2] + A.m[0][1] * B.m[1][2] + A.m[0][2] * B.m[2][2];

    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0] + A.m[1][2] * B.m[2][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1] + A.m[1][2] * B.m[2][1];
    C.m[1][2] = A.m[1][0] * B.m[0][2] + A.m[1][1] * B.m[1][2] + A.m[1][2] * B.m[2][2];

    C.m[2][0] = A.m[2][0] * B.m[0][0] + A.m[2][1] * B.m[1][0] + A.m[2][2] * B.m[2][0];
    C.m[2][1] = A.m[2][0] * B.m[0][1] + A.m[2][1] * B.m[1][1] + A.m[2][2] * B.m[2][1];
    C.m[2][2] = A.m[2][0] * B.m[0][2] + A.m[2][1] * B.m[1][2] + A.m[2][2] * B.m[2][2];
}

/***************************************************************************************/
/* matrix-matrix product: C = A*B^t */
inline void Mat_Mat_Transpose (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1];
    C.m[0][1] = A.m[0][0] * B.m[1][0] + A.m[0][1] * B.m[1][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[0][1];
    C.m[1][1] = A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1];
}
inline void Mat_Mat_Transpose (const MAT_2x2& A, const MAT_3x2& B, MAT_2x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1];
    C.m[0][1] = A.m[0][0] * B.m[1][0] + A.m[0][1] * B.m[1][1];
    C.m[0][2] = A.m[0][0] * B.m[2][0] + A.m[0][1] * B.m[2][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[0][1];
    C.m[1][1] = A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1];
    C.m[1][2] = A.m[1][0] * B.m[2][0] + A.m[1][1] * B.m[2][1];
}
inline void Mat_Mat_Transpose (const MAT_3x2& A, const MAT_3x2& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1];
    C.m[0][1] = A.m[0][0] * B.m[1][0] + A.m[0][1] * B.m[1][1];
    C.m[0][2] = A.m[0][0] * B.m[2][0] + A.m[0][1] * B.m[2][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[0][1];
    C.m[1][1] = A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1];
    C.m[1][2] = A.m[1][0] * B.m[2][0] + A.m[1][1] * B.m[2][1];
    C.m[2][0] = A.m[2][0] * B.m[0][0] + A.m[2][1] * B.m[0][1];
    C.m[2][1] = A.m[2][0] * B.m[1][0] + A.m[2][1] * B.m[1][1];
    C.m[2][2] = A.m[2][0] * B.m[2][0] + A.m[2][1] * B.m[2][1];
}

/***************************************************************************************/
/* matrix-matrix product: C = A^t*B */
inline void Mat_Transpose_Mat (const MAT_1x1& A, const MAT_1x1& B, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0]*B.m[0][0];
}
inline void Mat_Transpose_Mat (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[1][0] * B.m[1][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[1][0] * B.m[1][1];
    C.m[1][0] = A.m[0][1] * B.m[0][0] + A.m[1][1] * B.m[1][0];
    C.m[1][1] = A.m[0][1] * B.m[0][1] + A.m[1][1] * B.m[1][1];
}
inline void Mat_Transpose_Mat (const MAT_3x3& A, const MAT_3x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[1][0] * B.m[1][0] + A.m[2][0] * B.m[2][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[1][0] * B.m[1][1] + A.m[2][0] * B.m[2][1];
    C.m[0][2] = A.m[0][0] * B.m[0][2] + A.m[1][0] * B.m[1][2] + A.m[2][0] * B.m[2][2];

    C.m[1][0] = A.m[0][1] * B.m[0][0] + A.m[1][1] * B.m[1][0] + A.m[2][1] * B.m[2][0];
    C.m[1][1] = A.m[0][1] * B.m[0][1] + A.m[1][1] * B.m[1][1] + A.m[2][1] * B.m[2][1];
    C.m[1][2] = A.m[0][1] * B.m[0][2] + A.m[1][1] * B.m[1][2] + A.m[2][1] * B.m[2][2];

    C.m[2][0] = A.m[0][2] * B.m[0][0] + A.m[1][2] * B.m[1][0] + A.m[2][2] * B.m[2][0];
    C.m[2][1] = A.m[0][2] * B.m[0][1] + A.m[1][2] * B.m[1][1] + A.m[2][2] * B.m[2][1];
    C.m[2][2] = A.m[0][2] * B.m[0][2] + A.m[1][2] * B.m[1][2] + A.m[2][2] * B.m[2][2];
}

/***************************************************************************************/
/* matrix-``inner'' product: C = A^t * A */
inline void Mat_Transpose_Mat_Self (const MAT_2x1& A, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0];
}
inline void Mat_Transpose_Mat_Self (const MAT_3x1& A, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0] + A.m[2][0]*A.m[2][0];
}
inline void Mat_Transpose_Mat_Self (const MAT_3x2& A, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0] + A.m[2][0]*A.m[2][0];
    C.m[0][1] = A.m[0][0]*A.m[0][1] + A.m[1][0]*A.m[1][1] + A.m[2][0]*A.m[2][1];
    C.m[1][0] = C.m[0][1]; // symmetry
    C.m[1][1] = A.m[0][1]*A.m[0][1] + A.m[1][1]*A.m[1][1] + A.m[2][1]*A.m[2][1];
}

/***************************************************************************************/
/* contract two square matrices:  A:B = SUM_{ij} a_ij b_ij */
inline double Contract_Square_Matrices (const MAT_2x2& A, const MAT_2x2& B)
{
    return (A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1] +
            A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1]);
}
inline double Contract_Square_Matrices (const MAT_3x3& A, const MAT_3x3& B)
{
    return (A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1] + A.m[0][2] * B.m[0][2] +
            A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1] + A.m[1][2] * B.m[1][2] +
            A.m[2][0] * B.m[2][0] + A.m[2][1] * B.m[2][1] + A.m[2][2] * B.m[2][2]);
}


// define basic matrix operations

/***************************************************************************************/
/* det of matrix */
inline double Determinant (const MAT_1x1& A)
{
    return A.m[0][0];
}
inline double Determinant (const MAT_2x2& A)
{
    return (A.m[0][0]*A.m[1][1] - A.m[0][1]*A.m[1][0]);
}
inline double Determinant (const MAT_3x3& A)
{
    // DET: a00*a11*a22 - a00*a12*a21 - a01*a10*a22 + a01*a12*a20 + a02*a10*a21 - a02*a11*a20
    return (A.m[0][0] * A.m[1][1] * A.m[2][2] -
            A.m[0][0] * A.m[1][2] * A.m[2][1] -
            A.m[0][1] * A.m[1][0] * A.m[2][2] +
            A.m[0][1] * A.m[1][2] * A.m[2][0] +
            A.m[0][2] * A.m[1][0] * A.m[2][1] -
            A.m[0][2] * A.m[1][1] * A.m[2][0]);
}

/***************************************************************************************/
/* inverse of matrix */
inline void Matrix_Inverse (const MAT_1x1& A, const SCALAR& Det_A_Inv, MAT_1x1& A_Inv)
{
    A_Inv.m[0][0] = 1.0 / A.m[0][0];
}
inline void Matrix_Inverse (const MAT_2x2& A, const SCALAR& Det_A_Inv, MAT_2x2& A_Inv)
{
    A_Inv.m[0][0] =  A.m[1][1] * Det_A_Inv.a;
    A_Inv.m[0][1] = -A.m[0][1] * Det_A_Inv.a;
    A_Inv.m[1][0] = -A.m[1][0] * Det_A_Inv.a;
    A_Inv.m[1][1] =  A.m[0][0] * Det_A_Inv.a;
}
inline void Matrix_Inverse (const MAT_3x3& A, const SCALAR& Det_A_Inv, MAT_3x3& A_Inv)
{
    A_Inv.m[0][0] = (A.m[1][1]*A.m[2][2] - A.m[1][2]*A.m[2][1]) * Det_A_Inv.a;
    A_Inv.m[0][1] = (A.m[0][2]*A.m[2][1] - A.m[0][1]*A.m[2][2]) * Det_A_Inv.a;
    A_Inv.m[0][2] = (A.m[0][1]*A.m[1][2] - A.m[0][2]*A.m[1][1]) * Det_A_Inv.a;

    A_Inv.m[1][0] = (A.m[1][2]*A.m[2][0] - A.m[1][0]*A.m[2][2]) * Det_A_Inv.a;
    A_Inv.m[1][1] = (A.m[0][0]*A.m[2][2] - A.m[0][2]*A.m[2][0]) * Det_A_Inv.a;
    A_Inv.m[1][2] = (A.m[0][2]*A.m[1][0] - A.m[0][0]*A.m[1][2]) * Det_A_Inv.a;

    A_Inv.m[2][0] = (A.m[1][0]*A.m[2][1] - A.m[1][1]*A.m[2][0]) * Det_A_Inv.a;
    A_Inv.m[2][1] = (A.m[0][1]*A.m[2][0] - A.m[0][0]*A.m[2][1]) * Det_A_Inv.a;
    A_Inv.m[2][2] = (A.m[0][0]*A.m[1][1] - A.m[0][1]*A.m[1][0]) * Det_A_Inv.a;
}

/***/
