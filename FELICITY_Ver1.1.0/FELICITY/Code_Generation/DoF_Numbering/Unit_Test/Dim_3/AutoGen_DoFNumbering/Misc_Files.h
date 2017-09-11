/*
============================================================================================
   This header just contains some useful routines, etc...

   Copyright (c) 12-10-2010,  Shawn W. Walker
============================================================================================
*/

//#include <algorithm>
#include <vector>
using namespace std;


/***************************************************************************************/
int max_of_two(int& a, int& b)
{
	int max;
	if (a > b)
		max = a;
	else
		max = b;
    return(max);
}
/***************************************************************************************/


/***************************************************************************************/
int max_of_three(int& a, int& b, int& c)
{
	int max = max_of_two(a, b);
	max = max_of_two(max, c);
    return(max);
}
/***************************************************************************************/


/***************************************************************************************/
/* max element in an array */
int max_array(int* a, int num_elements)
{
    int i, max=0;
    for (i=0; i < num_elements; i++)
        {
        if (a[i]>max)
            {
            max=a[i];
            }
        }
    return(max);
}
/***************************************************************************************/


// /***************************************************************************************/
// /* sum bool array */
// int sum_bool_array(vector<bool>& a)
// {
//     unsigned int i;
//     int sum=0;
//     for (i=0; i < a.size(); i++)
//         {
//         if (a[i]==true)
//             {
//             sum++;
//             }
//         }
//     return(sum);
// }
// /***************************************************************************************/


// /***************************************************************************************/
// /* make given array have unique elements */
// void unique_array(vector<int>& unique_a, int* a, int num_elements)
// {
//     // declare "pointer"
//     vector<int>::iterator it;
//     
//     // need to do double copy to make it unique
//     it=unique_copy(a, a+num_elements, unique_a.begin());
//     sort(unique_a.begin(), it);
//     it=unique_copy(unique_a.begin(), it, unique_a.begin());
//     
//     // free excess memory
//     unique_a.resize( it - unique_a.begin() );
//     
// //  // print out content:
// //  printf("unique_a contains:\n");
// //  for (it=unique_a.begin(); it!=unique_a.end(); ++it)
// //      printf(" %d",*it);
// //  printf("\n");
// }
// /***************************************************************************************/

//     // test code!!!
//     vector<int> myvector (3*Tri_Edge_Search.Num_Tri);
//  unique_array(myvector, Tri_Edge_Search.Tri_DoF[0], 3*Tri_Edge_Search.Num_Tri);
    
//  map<int,int>* mymap = new map<int,int>[3];
//  printf("mymap.size() is %d.\n",(int) mymap[0].size());
//  printf("mymap.max_size() is %d.\n",(int) mymap[1].max_size());

/***/
