/*
============================================================================================
   This file contains an implementation of a derived C++ Class from the abstract base class
   in 'FEM_Matrix.cc'.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-20-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// FEM matrix is:
//
// \int_{Omega}  u_v1_t1_grad1*v_v1_t1_grad1 + u_v1_t1_grad2*v_v1_t1_grad2 + u_v1_t1_grad3*v_v1_t1_grad3
//
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
// define the name of the FEM matrix (should be the same as the filename of this file)
#define SpecificFEM        Stiff_Matrix
#define SpecificFEM_str   "Stiff_Matrix"

// the row function space is Type = CG, Name = "lagrange_deg1_dim3"

// set the number of vector components
#define ROW_NC  1
// set the number of basis functions on each element
#define ROW_NB  4

// the col function space is Type = CG, Name = "lagrange_deg1_dim3"

// set the number of vector components
#define COL_NC  1
// set the number of basis functions on each element
#define COL_NB  4
/*------------   END: Auto Generate ------------*/


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

    /*------------ BEGIN: Auto Generate ------------*/
    // access local mesh geometry info
    const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega*  geom_Omega_embedded_in_Omega_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers for accessing FE basis functions
    const Data_Type_Scalar_P1_phi_restricted_to_Omega*  Scalar_P1_phi_restricted_to_Omega;
    const Data_Type_Vector_P1_phi_restricted_to_Omega*  Vector_P1_phi_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers for accessing coefficient functions
    const Data_Type_my_f_restricted_to_Omega*  my_f_restricted_to_Omega;
    const Data_Type_old_soln_restricted_to_Omega*  old_soln_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // constructor
    SpecificFEM (const PTR_TO_SPARSE*, const ABSTRACT_FEM_Function_Class*, const ABSTRACT_FEM_Function_Class*);
    ~SpecificFEM (); // destructor
    void Init_Matrix_Assembler_Object(bool);
    void Add_Entries_To_Global_Matrix (const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega&);
    /*------------   END: Auto Generate ------------*/
private:
    /*------------ BEGIN: Auto Generate ------------*/
    void Tabulate_Tensor_0(double*, const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega&);
    /*------------   END: Auto Generate ------------*/
};


/***************************************************************************************/
/* constructor */
/*------------ BEGIN: Auto Generate ------------*/
SpecificFEM::SpecificFEM (const PTR_TO_SPARSE* Prev_Sparse_Data,
                          const ABSTRACT_FEM_Function_Class* row_basis_func,
                          const ABSTRACT_FEM_Function_Class* col_basis_func) :
/*------------   END: Auto Generate ------------*/
FEM_MATRIX_Class () // call the base class constructor
{
    bool simple_assembler;
    Sparse_Data = Prev_Sparse_Data;
    /*------------ BEGIN: Auto Generate ------------*/
    simple_assembler = false; // use sparse matrix format
    /*------------   END: Auto Generate ------------*/

	// BEGIN: simple error check
	if (row_basis_func->Num_Comp!=ROW_NC)
		{
        mexPrintf("ERROR: The number of components for the row FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d row components.\n",SpecificFEM_str,ROW_NC);
        mexPrintf("Actual number of row components is %d.\n",row_basis_func->Num_Comp);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (col_basis_func->Num_Comp!=COL_NC)
		{
        mexPrintf("ERROR: The number of components for the column FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d col components.\n",SpecificFEM_str,COL_NC);
        mexPrintf("Actual number of col components is %d.\n",col_basis_func->Num_Comp);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (row_basis_func->Num_Basis!=ROW_NB)
		{
        mexPrintf("ERROR: The number of basis functions in the row FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d row basis functions.\n",SpecificFEM_str,ROW_NB);
        mexPrintf("Actual number of row components is %d.\n",row_basis_func->Num_Basis);
        mexErrMsgTxt("Please report this error!\n");
        }
	if (col_basis_func->Num_Basis!=COL_NB)
		{
        mexPrintf("ERROR: The number of basis functions in the column FEM space is NOT correct!\n");
        mexPrintf("The FEM matrix '%s' expects %d col basis functions.\n",SpecificFEM_str,COL_NB);
        mexPrintf("Actual number of row components is %d.\n",col_basis_func->Num_Basis);
        mexErrMsgTxt("Please report this error!\n");
        }
	//   END: simple error check

    // set the 'Name' of the FEM matrix
    Name = (char*) SpecificFEM_str;      // this should be the same as the Class identifier
    Num_Sub_Matrices = row_basis_func->Num_Comp*col_basis_func->Num_Comp; // may not use all of these...
    
    // get the size of the global matrix
    global_num_row = row_basis_func->Num_Comp*row_basis_func->Num_Nodes;
    global_num_col = col_basis_func->Num_Comp*col_basis_func->Num_Nodes;

    /*------------ BEGIN: Auto Generate ------------*/
    // input information for each of the sub-matrices
    SubMAT_Info[0].Shift_Row_Index = 0*row_basis_func->Num_Nodes;
    SubMAT_Info[0].Shift_Col_Index = 0*col_basis_func->Num_Nodes;
    /*------------   END: Auto Generate ------------*/

    // init by clearing data
    for (int row_i = 0; (row_i < ROW_NB); row_i++)
        Row_Indices[row_i] = 0;
    for (int col_i = 0; (col_i < COL_NB); col_i++)
        Col_Indices[col_i] = 0;
    for (int sub = 0; (sub < Num_Sub_Matrices); sub++)
        for (int rc_i = 0; (rc_i < ROW_NB*COL_NB); rc_i++)
            SubMAT_Info[sub].Local_Mat_Data[rc_i] = 0.0;

    Init_Matrix_Assembler_Object(simple_assembler);
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor: should not usually need to be modified */
SpecificFEM::~SpecificFEM ()
{
    delete(MAT);
}
/***************************************************************************************/


/***************************************************************************************/
/* this just initializes the object that handles matrix assembly */
void SpecificFEM::Init_Matrix_Assembler_Object(bool use_simple_assembler)
{
    if (use_simple_assembler)
    	// create SimpleMatrixAssembler object
		MAT = new SimpleMatrixAssembler(global_num_row,global_num_col); // assemble from scratch
    else if (Sparse_Data->valid)
        {
        int str_diff = strcmp(Sparse_Data->name,Name);
        if (str_diff!=0)
            {
            mexPrintf("Matrix names do not match!\n");
            mexPrintf("Previously assembled matrix name is:  %s.\n", Sparse_Data->name);
            mexPrintf("The name SHOULD have been:            %s.\n", Name);
            mexErrMsgTxt("Check the previously assembled matrix structure!\n");
            }
        if (Sparse_Data->m!=global_num_row)
            {
            mexPrintf("Error with this matrix:   %s.\n", Name);
            mexErrMsgTxt("Number of rows in previous matrix does not match what the new matrix should be.\n");
            }
        if (Sparse_Data->n!=global_num_col)
            {
            mexPrintf("Error with this matrix:   %s.\n", Name);
            mexErrMsgTxt("Number of columns in previous matrix does not match what the new matrix should be.\n");
            }
        // create MatrixReassembler object (cf. David Bindel)
        MAT = new MatrixReassembler(Sparse_Data->jc,Sparse_Data->ir,Sparse_Data->pr,global_num_row,global_num_col);
        // use previous sparse structure
        }
    else // create MatrixAssembler object (cf. David Bindel)
        MAT = new MatrixAssembler(global_num_row,global_num_col); // assemble from scratch
}
/***************************************************************************************/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* assemble a local FEM matrix */
void SpecificFEM::Add_Entries_To_Global_Matrix(const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega& Mesh)
{
    // get local to global index map for the current ROW element
    const int row_elem_index = Scalar_P1_phi_restricted_to_Omega->Mesh->Domain->Sub_Cell_Index;
    Scalar_P1_phi_restricted_to_Omega->Get_Local_to_Global_DoFmap(row_elem_index, Row_Indices);
    // get local to global index map for the current COL element
    const int col_elem_index = Scalar_P1_phi_restricted_to_Omega->Mesh->Domain->Sub_Cell_Index;
    Scalar_P1_phi_restricted_to_Omega->Get_Local_to_Global_DoFmap(col_elem_index, Col_Indices);

    Tabulate_Tensor_0(SubMAT_Info[0].Local_Mat_Data, Mesh);
    MAT->add_entries(Row_Indices,     Col_Indices,    SubMAT_Info[0].Local_Mat_Data,
                     ROW_NB,          COL_NB,
                     SubMAT_Info[0].Shift_Row_Index,  SubMAT_Info[0].Shift_Col_Index);

}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* Tabulate the tensor for the local element contribution */
void SpecificFEM::Tabulate_Tensor_0(double* A, 
                           const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega& Mesh)
{
    const unsigned int NQ = 24;

    // clear it first
    for (unsigned int ij = 0; ij < ROW_NB*COL_NB; ij++)
        A[ij] = 0.0;

    // Compute element tensor using quadrature

    // Loop quadrature points for integral
    for (unsigned int qp = 0; qp < NQ; qp++)
        {
        for (unsigned int j = 0; j < COL_NB; j++)
            {
            for (unsigned int i = j; i < ROW_NB; i++)
                {
                double  integrand = Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[j][qp].v[0]*Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[i][qp].v[0]+Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[j][qp].v[1]*Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[i][qp].v[1]+Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[j][qp].v[2]*Scalar_P1_phi_restricted_to_Omega->Func_f_Grad[i][qp].v[2];
                A[j*ROW_NB + i] += integrand * Mesh.Map_Det_Jac_w_Weight[qp].a;
                }
            }
        }

    // Copy the lower triangular entries to the upper triangular part (by symmetry)
    for (unsigned int j = 0; j < COL_NB; j++)
        {
        for (unsigned int i = j+1; i < ROW_NB; i++)
            {
            A[i*ROW_NB + j] = A[j*ROW_NB + i];
            }
        }
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

// remove those macros!
#undef SpecificFEM
#undef SpecificFEM_str

#undef ROW_NC
#undef ROW_NB
#undef COL_NC
#undef COL_NB

/***/
