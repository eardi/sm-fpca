/*
============================================================================================
   This class encapsulates storage and access to an MxC array where M can change,
   but C is fixed.  This is meant to work with incoming and outgoing MATLAB data (matrices).

   Copyright (c) 09-12-2011,  Shawn W. Walker
============================================================================================
*/

#include <vector>
#include <typeinfo>

/* C++ Generic Matrix Data class definition */
#define GTD   Generic_Data
template <class myType, unsigned int NUM_COLS>
class GTD
{
public:
    GTD (); // constructor
    ~GTD ();   // DE-structor
    const char*  Get_Name ()          { return Name; }
    unsigned int Get_Orig_Num_Rows () { return Orig_Num_Rows; }
    unsigned int Get_Num_Rows ()      { return Num_Rows; }
    unsigned int Get_Num_Cols ()      { return Actual_Num_Cols; }

    void Setup_Data(const char*, const mxArray*, const unsigned int&);
    void Setup_Data(const char*, const mxArray*, const unsigned int&, const myType&, const myType&);
    void Do_Max_Min_Check(const myType&, const myType&);

    void Read(const int&, myType*) const;
    void Read(const int&, const int&, myType&) const;
    void Overwrite(const int&, const myType*);
    void Append_Data_To_End(const myType*);
    mxArray* Copy_Final_Data();

private:
    const char*    Name;              // identifier for the data
    unsigned int   Orig_Num_Rows;     // original number of rows (i.e. M)
    unsigned int   Num_Rows;          //  current number of rows (i.e. \tilde M)
    unsigned int   Actual_Num_Cols;   // only for internal use

    unsigned int   Additional_Reserve; // extra memory chunks to reserve

    const myType*  Data[NUM_COLS]; // access to (original) MxC data
                                   // we cannot change the contents here because they are in an outside
                                   // MATLAB matrix, and we want to avoid copying everything over to
                                   // a new massive matrix
    std::vector<int>  Replace_Ptr; // this points to Replace_Data
                                   // in other words, if a row in the original MxC array
                                   // gets replaced, it is placed in Replace_Data and
                                   // Replace_Ptr records where it is
    std::vector<myType>  Replace_Data[NUM_COLS]; // holds replacement data for the original array
    std::vector<myType>      New_Data[NUM_COLS]; // holds newly added rows to the original data
                                                 // this is treated as being directly appended to
                                                 // the end of Data
    void Error_Check_Row_Index(const int&) const;
    void Error_Check_Col_Index(const int&) const;
};

/***************************************************************************************/
/* constructor */
template <class myType, unsigned int NUM_COLS>
GTD<myType,NUM_COLS>::GTD ()
{
    // init data information to NULL
    Orig_Num_Rows   = 0;
    Num_Rows        = 0;
    Actual_Num_Cols = 0;
    Additional_Reserve = 0;
    for (unsigned int dof_i = 0; (dof_i < NUM_COLS); dof_i++)
        Data[dof_i] = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
template <class myType, unsigned int NUM_COLS>
GTD<myType,NUM_COLS>::~GTD ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming data from MATLAB into a nice struct */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Setup_Data(const char* Name_input,                                // inputs
                    const mxArray* mxData,           const unsigned int& Predicted_New_Data, // inputs
                    const myType&  Min_Data_Entry,   const myType& Max_Data_Entry)           // inputs
{
    Setup_Data(Name_input, mxData, Predicted_New_Data);
    Do_Max_Min_Check(Min_Data_Entry, Max_Data_Entry);
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming data from MATLAB into a nice struct */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Setup_Data(const char* Name_input,                      // inputs
                    const mxArray* mxData, const unsigned int& Predicted_New_Data) // inputs
{
    // store the name
    Name = Name_input;

    // get the number of elements
    Orig_Num_Rows   = (unsigned int) mxGetM(mxData);
         Num_Rows   = Orig_Num_Rows; // init
    // get the number of cols for each element
    Actual_Num_Cols = (unsigned int) mxGetN(mxData);


    /* BEGIN: Simple Error Checking */
    if (typeid(myType) == typeid(unsigned int))
        {
        if (mxGetClassID(mxData)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Data must be of type uint32!");
        }
    else if (typeid(myType) == typeid(int))
        {
        if (mxGetClassID(mxData)!=mxINT32_CLASS) mexErrMsgTxt("ERROR: Data must be of type int32!");
        }
    else if (typeid(myType) == typeid(double))
        {
        if (mxGetClassID(mxData)!=mxDOUBLE_CLASS) mexErrMsgTxt("ERROR: Data must be of type double!");
        }
    else
        {
        mexErrMsgTxt("ERROR: Data type not recognized; C++ class must be extended!");
        }
    if (Actual_Num_Cols > NUM_COLS)
        {
        mexPrintf("ERROR: Data has %d columns; cannot have more than %d columns.\n", Actual_Num_Cols, NUM_COLS);
        mexErrMsgTxt("ERROR: fix your Data!");
        }
    /* END: Simple Error Checking */


    // split up the columns of the element data
    Data[0] = (const myType*) mxGetPr(mxData);
    for (unsigned int dof_i = 1; (dof_i < Actual_Num_Cols); dof_i++)
        Data[dof_i] = Data[dof_i-1] + Orig_Num_Rows;

    // init data containers for new and replacement rows
    Replace_Ptr.resize(Orig_Num_Rows,-1); // init to indicate that no replacements have been made
    Additional_Reserve = 3*Predicted_New_Data;
    if (Additional_Reserve > Orig_Num_Rows)
        Additional_Reserve = Orig_Num_Rows;
    for (unsigned int dof_i = 0; (dof_i < Actual_Num_Cols); dof_i++)
        Replace_Data[dof_i].reserve(Additional_Reserve);
    for (unsigned int dof_i = 0; (dof_i < Actual_Num_Cols); dof_i++)
        New_Data[dof_i].reserve(Additional_Reserve);
}
/***************************************************************************************/


/***************************************************************************************/
/* check the max and min of the input data */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Do_Max_Min_Check(const myType&  Min_Data_Entry, const myType& Max_Data_Entry) // inputs
{
    // get max and min DoF present in Data
    myType Max_DoF  = *std::max_element(Data[0],Data[0] + (Orig_Num_Rows*Actual_Num_Cols));
    myType Min_DoF  = *std::min_element(Data[0],Data[0] + (Orig_Num_Rows*Actual_Num_Cols));
    if ((Min_DoF < Min_Data_Entry) || (Max_DoF < Min_Data_Entry))
        {
        mexPrintf("ERROR: There are Data entries less than the minimum allowed value of %d!\n",Min_Data_Entry);
        mexPrintf("       There is a problem with this data: %s\n",Name);
        mexPrintf("       w/ size info [num rows, num cols]: [%d, %d]\n",Orig_Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: Fix your Data array!");
        }
    if (Max_DoF > Max_Data_Entry)
        {
        mexPrintf("ERROR: There are Data entries greater than the maximum allowed value of %d!\n",Max_Data_Entry);
        mexPrintf("       There is a problem with this data: %s\n",Name);
        mexPrintf("       w/ size info [num rows, num cols]: [%d, %d]\n",Orig_Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: Fix your Data array!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this reads an existing row */
/* note: you want the row input to be an integer to catch errors related to non-positive indices */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Read(const int& row, myType* read_data) const // inputs
{
    Error_Check_Row_Index(row);
	const unsigned int uint_row = (unsigned int) row;

    if (uint_row < Orig_Num_Rows) // reading the original data
        {
        const int replace_index = Replace_Ptr[uint_row];
        if (replace_index==-1) // original data has NOT been replaced
            {
            // read from original data
            for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
                read_data[i] = Data[i][uint_row];
            }
        else // original data has been replaced previously
            {
            // read from replacement
            for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
                read_data[i] = Replace_Data[i][(unsigned int) replace_index];
            }
        }
    else if (uint_row < Num_Rows) // reading new data
        {
        // shift index
        const unsigned int new_index = uint_row - Orig_Num_Rows;
        // read from new
        for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
            read_data[i] = New_Data[i][new_index];
        }
    else
        mexErrMsgTxt("ERROR: row index exceeds range of MxC data array!  This should have been caught earlier");
}
/***************************************************************************************/


/***************************************************************************************/
/* this reads an existing (row,col) entry */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Read(const int& row, const int& col,  // inputs
                                myType& read_data) const         // inputs
{
    Error_Check_Row_Index(row);
    Error_Check_Col_Index(col);
	const unsigned int uint_row = (unsigned int) row;

    if (uint_row < Orig_Num_Rows) // reading the original data
        {
        const int replace_index = Replace_Ptr[uint_row];
        if (replace_index==-1) // original data has NOT been replaced
            {
            // read from original data
            read_data = Data[col][uint_row];
            }
        else // original data has been replaced previously
            {
            // read from replacement
            read_data = Replace_Data[col][(unsigned int) replace_index];
            }
        }
    else if (uint_row < Num_Rows) // reading new data
        {
        // shift index
        const unsigned int new_index = uint_row - Orig_Num_Rows;
        // read from new
        read_data = New_Data[col][new_index];
        }
    else
        mexErrMsgTxt("ERROR: row index exceeds range of MxC data array!  This should have been caught earlier");
}
/***************************************************************************************/


/***************************************************************************************/
/* this overwrites an existing row */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Overwrite(const int& row, const myType* overwrite_data)  // inputs
{
    Error_Check_Row_Index(row);
	const unsigned int uint_row = (unsigned int) row;

    if (uint_row < Orig_Num_Rows) // modifying the original data
        {
        const int replace_index = Replace_Ptr[uint_row];
        if (replace_index==-1) // first time the original data is replaced
            {
            // add new replacement data
            for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
                Replace_Data[i].push_back(overwrite_data[i]);
            Replace_Ptr[uint_row] = ((int) Replace_Data[0].size())-1; // record where it is (with C-style indexing)
            }
        else // original data has been replaced previously
            {
            // overwrite previous replacement data
            for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
                Replace_Data[i][(unsigned int) replace_index] = overwrite_data[i];
            }
        }
    else if (uint_row < Num_Rows) // modifying new data
        {
        // shift index
        const unsigned int new_index = uint_row - Orig_Num_Rows;
        // overwrite previously added new data
        for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
            New_Data[i][new_index] = overwrite_data[i];
        }
    else
        mexErrMsgTxt("ERROR: row index exceeds range of MxC data array!  This should have been caught earlier");
}
/***************************************************************************************/


/***************************************************************************************/
/* this appends a new row */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Append_Data_To_End(const myType* append_data)  // inputs
{
    // add new data to end of the MxC array
    for (unsigned int i = 0; (i < Actual_Num_Cols); i++)
        New_Data[i].push_back(append_data[i]);

    // update the number of rows (M)
    Num_Rows++;
}
/***************************************************************************************/


/***************************************************************************************/
/* copy data over to a self-contained MATLAB matrix */
template <class myType, unsigned int NUM_COLS>
mxArray* GTD<myType,NUM_COLS>::Copy_Final_Data()
{
    mxArray* Output_Data = NULL;
    if (typeid(myType) == typeid(unsigned int))
        Output_Data = mxCreateNumericMatrix((mwSize) Num_Rows, (mwSize) Actual_Num_Cols,
                                                     mxUINT32_CLASS, mxREAL);
    else if (typeid(myType) == typeid(int))
        Output_Data = mxCreateNumericMatrix((mwSize) Num_Rows, (mwSize) Actual_Num_Cols,
                                                     mxINT32_CLASS, mxREAL);
    else
        Output_Data = mxCreateNumericMatrix((mwSize) Num_Rows, (mwSize) Actual_Num_Cols,
                                                     mxDOUBLE_CLASS, mxREAL);
    myType* Output_Data_Val = (myType*) mxGetPr(Output_Data);

    // copy original data over (initially)
    for (unsigned int j = 0; (j < Actual_Num_Cols); j++)
        std::copy(Data[j], Data[j] + Orig_Num_Rows, Output_Data_Val + j*Num_Rows);

    // overwrite original data with replacements
    for (unsigned int ri = 0; (ri < Orig_Num_Rows); ri++)
        {
        const int replace_index = Replace_Ptr[ri];
        if (replace_index >= 0) // then that row was replaced
            {
            // copy replacement over original
            for (unsigned int j = 0; (j < Actual_Num_Cols); j++)
                Output_Data_Val[ri + j*Num_Rows] = Replace_Data[j][(unsigned int) replace_index];
            }
        }

    // copy new data that was appended to the end of the original data
    for (unsigned int j = 0; (j < Actual_Num_Cols); j++)
        std::copy(New_Data[j].begin(), New_Data[j].end(), (Output_Data_Val + Orig_Num_Rows) + j*Num_Rows);

    return Output_Data;
}
/***************************************************************************************/


/***************************************************************************************/
/* this checks that the row index is valid */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Error_Check_Row_Index(const int& row_index) const // inputs
{
    if (row_index < 0)
        {
        mexPrintf("ERROR: A non-positive row index (%d) was used to access this data: %s!\n",row_index+1,Name);
        mexPrintf("       size info for data [num rows, num cols]: [%d, %d]\n",Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: check the consistency of your data!");
        }
    if ((unsigned int) row_index >= Num_Rows)
        {
        mexPrintf("ERROR: A row index (%d) was used to access this data: %s,\n",row_index+1,Name);
        mexPrintf("       but it exceeds the range of the data!\n");
        mexPrintf("       size info for data [num rows, num cols]: [%d, %d]\n",Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: check the consistency of your data!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this checks that the col index is valid */
template <class myType, unsigned int NUM_COLS>
void GTD<myType,NUM_COLS>::Error_Check_Col_Index(const int& col_index) const // inputs
{
    if (col_index < 0)
        {
        mexPrintf("ERROR: A non-positive col index (%d) was used to access this data: %s!\n",col_index+1,Name);
        mexPrintf("       size info for data [num rows, num cols]: [%d, %d]\n",Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: check the consistency of your data!");
        }
    if ((unsigned int) col_index >= Actual_Num_Cols)
        {
        mexPrintf("ERROR: A col index (%d) was used to access this data: %s,\n",col_index+1,Name);
        mexPrintf("       but it exceeds the range of the data!\n");
        mexPrintf("       size info for data [num rows, num cols]: [%d, %d]\n",Num_Rows,Actual_Num_Cols);
        mexErrMsgTxt("ERROR: check the consistency of your data!");
        }
}
/***************************************************************************************/

#undef GTD

/***/
