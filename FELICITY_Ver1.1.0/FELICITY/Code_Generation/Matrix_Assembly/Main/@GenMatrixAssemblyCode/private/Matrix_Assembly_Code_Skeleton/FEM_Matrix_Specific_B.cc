
/***************************************************************************************/
/* C++ (Specific) FEM class definition */
class SpecificFEM: public FEM_MATRIX_Class // derive from base class
{
public:
    // temporary variables for storing shifted local to global DoFmap
    int      Row_Indices[ROW_NB];
    int      Col_Indices[COL_NB];

    // data structure for sub-matrices of the BIG FEM matrix
    struct SUB_MATRIX_STRUCT
    {
        // vector component offset for inserting into global matrix
        int     Shift_Row_Index;
        int     Shift_Col_Index;
        // temporary variable for storing local element (sub) matrix
        double  Local_Mat_Data[ROW_NB*COL_NB];
    }
    SubMAT_Info[ROW_NC*COL_NC];

