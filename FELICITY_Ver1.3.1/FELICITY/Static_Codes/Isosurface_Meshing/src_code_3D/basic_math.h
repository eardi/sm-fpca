/*
============================================================================================
   Some simple math routines...
   
   Copyright (c) 01-03-2012,  Shawn W. Walker
============================================================================================
*/

static const double PI = 3.14159265358979323846264338327950288419716939;

/***************************************************************************************/
/* special ``sign'' function.  basically, assume that 0 has sign +1. */
int LS_SIGN(const double& VAL)
{
    if (VAL < 0)
        return -1;
    else
        return +1;
}
/***************************************************************************************/


/***************************************************************************************/
/* generic routine:  compute the min of two numbers */
inline double Get_Min (const double Val1, const double Val2)
{
	if (Val1 <= Val2) return Val1;
	else              return Val2;
}
/***************************************************************************************/
/* generic routine:  compute the max of two numbers */
inline double Get_Max (const double Val1, const double Val2)
{
	if (Val1 >= Val2) return Val1;
	else              return Val2;
}
/***************************************************************************************/
/* generic routine:  compute vector between two points */
inline void Get_Vec_Difference (const double head[3], const double tail[3], double Vec_Diff[3])
{
    Vec_Diff[0] = (head[0] - tail[0]);
    Vec_Diff[1] = (head[1] - tail[1]);
    Vec_Diff[2] = (head[2] - tail[2]);
}
/***************************************************************************************/
/* generic routine:  distance calculation */
double Euclidean_Distance (const double Vec1[3], const double Vec2[3])
{
	double vec_diff[3];
	Get_Vec_Difference(Vec1, Vec2, vec_diff);
    double value = sqrt(vec_diff[0]*vec_diff[0] + vec_diff[1]*vec_diff[1] + vec_diff[2]*vec_diff[2]);

    return value;
}
/***************************************************************************************/
/* generic routine:  compute cross-product of two vectors, i.e.
   V = a x b.
 */
inline void Cross_Product (const double a[3], const double b[3], double V[3])
{
	V[0] = a[1]*b[2] - a[2]*b[1];
	V[1] = a[2]*b[0] - a[0]*b[2];
	V[2] = a[0]*b[1] - a[1]*b[0];
}
/***************************************************************************************/
/* generic routine:  normalize vector */
double Normalize (const double Vec_in[3], double Vec_out[3])
{
	const double LENGTH = sqrt(Vec_in[0]*Vec_in[0] + Vec_in[1]*Vec_in[1] + Vec_in[2]*Vec_in[2]);
	
	// normalize!
	Vec_out[0] = Vec_in[0] / LENGTH;
	Vec_out[1] = Vec_in[1] / LENGTH;
	Vec_out[2] = Vec_in[2] / LENGTH;

    return LENGTH;
}
/***************************************************************************************/
/* generic routine:  compute cross-product of two vectors, then normalize it, i.e.
   VN = a x b / |a x b|.
 */
double Normalized_Cross_Product (const double a[3], const double b[3], double VN[3])
{
	double temp_vec[3];
	Cross_Product(a, b, temp_vec);
	const double VEC_LENGTH = Normalize(temp_vec, VN);
	return VEC_LENGTH;
}
/***************************************************************************************/
/* generic routine:  compute dot-product of two vectors
 */
inline double Dot_Product (const double a[3], const double b[3])
{
	double val = a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
	return val;
}
/***************************************************************************************/
/* generic routine:  compute angle from dot product of normalized vectors
 */
double Get_Angle (const double& DP_in)
{
    double DP = DP_in; // init
    // prevent truncation error issues
    if (DP > +1.0)
        DP = +1.0;
    else if (DP < -1.0)
        DP = -1.0;

    // compute angle (now safely)
    double theta = acos(DP);
    return theta;
}
/***************************************************************************************/
/* generic routine:  compute angle between two NORMALIZED vectors
   NOTE: there is a MINUS sign here!!!!!
 */
double Get_Angle (const double Na[3], const double Nb[3])
{
    double DP = Dot_Product(Na,Nb);
    return Get_Angle(-DP);
}
/***************************************************************************************/

/***/
