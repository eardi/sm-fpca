/*
============================================================================================
   Some simple routines for computing transformations of basis functions.

   Copyright (c) 10-28-2016,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* sort integers into ascending order.
   Note: this only returns the ordering (0,1,2,3) in "A", where
   i = 0
   j = 1
   k = 2
   l = 3 */
void Sort_Four_Ints(const int& i, const int& j, const int& k, const int& l, int A[4])
{
    if (i < j)
        {
        if (j < k)
            {
            if      (k < l) {A[0] = 0; A[1] = 1; A[2] = 2; A[3] = 3;} // [i,j,k,l]
            else if (j < l) {A[0] = 0; A[1] = 1; A[2] = 3; A[3] = 2;} // [i,j,l,k]
            else if (i < l) {A[0] = 0; A[1] = 3; A[2] = 1; A[3] = 2;} // [i,l,j,k]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 0; A[2] = 1; A[3] = 2;} // [l,i,j,k]
            }
        else if (i < k)
            {
            if      (j < l) {A[0] = 0; A[1] = 2; A[2] = 1; A[3] = 3;} // [i,k,j,l]
            else if (k < l) {A[0] = 0; A[1] = 2; A[2] = 3; A[3] = 1;} // [i,k,l,j]
            else if (i < l) {A[0] = 0; A[1] = 3; A[2] = 2; A[3] = 1;} // [i,l,k,j]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 0; A[2] = 2; A[3] = 1;} // [l,i,k,j]
            }
        else // (k < i)
            {
            if      (j < l) {A[0] = 2; A[1] = 0; A[2] = 1; A[3] = 3;} // [k,i,j,l]
            else if (i < l) {A[0] = 2; A[1] = 0; A[2] = 3; A[3] = 1;} // [k,i,l,j]
            else if (k < l) {A[0] = 2; A[1] = 3; A[2] = 0; A[3] = 1;} // [k,l,i,j]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 2; A[2] = 0; A[3] = 1;} // [l,k,i,j]
            }
        }
    else // (j < i)
        {
        if (i < k)
            {
            if      (k < l) {A[0] = 1; A[1] = 0; A[2] = 2; A[3] = 3;} // [j,i,k,l]
            else if (i < l) {A[0] = 1; A[1] = 0; A[2] = 3; A[3] = 2;} // [j,i,l,k]
            else if (j < l) {A[0] = 1; A[1] = 3; A[2] = 0; A[3] = 2;} // [j,l,i,k]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 1; A[2] = 0; A[3] = 2;} // [l,j,i,k]
            }
        else if (j < k)
            {
            if      (i < l) {A[0] = 1; A[1] = 2; A[2] = 0; A[3] = 3;} // [j,k,i,l]
            else if (k < l) {A[0] = 1; A[1] = 2; A[2] = 3; A[3] = 0;} // [j,k,l,i]
            else if (j < l) {A[0] = 1; A[1] = 3; A[2] = 2; A[3] = 0;} // [j,l,k,i]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 1; A[2] = 2; A[3] = 0;} // [l,j,k,i]
            }
        else // (k < j)
            {
            if      (i < l) {A[0] = 2; A[1] = 1; A[2] = 0; A[3] = 3;} // [k,j,i,l]
            else if (j < l) {A[0] = 2; A[1] = 1; A[2] = 3; A[3] = 0;} // [k,j,l,i]
            else if (k < l) {A[0] = 2; A[1] = 3; A[2] = 1; A[3] = 0;} // [k,l,j,i]
            else // (l is smallest)
                            {A[0] = 3; A[1] = 2; A[2] = 1; A[3] = 0;} // [l,k,j,i]
            }
        }
}
/***************************************************************************************/


/***/
