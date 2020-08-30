
/* include classes and other sub-routines */
#include "Misc_Stuff.h"
#include "Generic_FEM_Interpolation.h"
#include "Generic_FEM_Interpolation.cc"

// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
