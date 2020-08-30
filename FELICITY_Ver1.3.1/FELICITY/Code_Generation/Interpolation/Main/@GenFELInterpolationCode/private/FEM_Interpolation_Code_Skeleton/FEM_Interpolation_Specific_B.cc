/***************************************************************************************/
/* C++ (Specific) FEM interpolation class */
class SpecificFEM: public FEM_Interpolation_Class // derive from base class
{
public:
    // pointers to arrays of interpolation data
	// (lengths of those arrays correspond to number of interpolation points)
    double*   Interp_Data[ROW_NC][COL_NC];

