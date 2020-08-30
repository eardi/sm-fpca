/*
============================================================================================
   This class accesses the mesh data and the bisection class.

   Copyright (c) 09-12-2011,  Shawn W. Walker
============================================================================================
*/

/* C++ Triangle Mesh class definition */
#define TMC  Triangle_Mesh_Class
class TMC
{
public:
    TMC (); // constructor
    ~TMC ();   // DE-structor
    void Setup_Data(const int&, const mxArray* []);
    std::vector<Subdomain_Data>* Read_Subdomain_Data(const mxArray*);
    void Output_Final_Data(const int&, mxArray* []);
    void Execute_Rivara_Bisection();

    unsigned int  GeoDim;            // geometric dimension
    // mesh data
    Generic_Data<double,3>        Vtx;
    Generic_Data<unsigned int,3>  Tri;
    Generic_Data<unsigned int,3>  Neighbor;
    // subdomains
    std::vector<Subdomain_Data>   SUB;

private:
    Rivara_Bisection_Class* Bisection_obj;
};

/***************************************************************************************/
/* constructor */
TMC::TMC()
{
    // init
    GeoDim = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
TMC::~TMC ()
{
    delete(Bisection_obj);
    SUB.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void TMC::Setup_Data(const int& nrhs, const mxArray* prhs[])      // inputs
{
    Bisection_obj = new Rivara_Bisection_Class();
    Bisection_obj->Setup_Marked_Triangle_List(prhs[PRHS_Marked_Triangles]);

    // access mesh data
    const mxArray* mxMesh = prhs[PRHS_Mesh];
    if (!mxIsCell(mxMesh))
        mexErrMsgTxt("Mesh data {Vtx Coord, Triangle Data} must be stored in a cell array!");
    // parse cell array
    const mxArray* mxVtx  = mxGetCell(mxMesh, (mwIndex) 0);
    const mxArray* mxTri  = mxGetCell(mxMesh, (mwIndex) 1);
    // get separate neighbor data
    const mxArray* mxNeighbor = prhs[PRHS_Triangle_Neighbor_Data];

    // setup vertex data handler
    const unsigned int Num_Marked = (unsigned int) Bisection_obj->Marked_Triangles.size();
    Vtx.Setup_Data("Vertex Coordinates", mxVtx, Num_Marked);
    GeoDim = Vtx.Get_Num_Cols();
    // setup triangle data handlers
    Tri.Setup_Data("Triangle Data (Vertex Indices)", mxTri, Num_Marked, 1, Vtx.Get_Orig_Num_Rows());
    Neighbor.Setup_Data("Triangle Neighbor Data (Triangle Indices)",
                        mxNeighbor, Num_Marked, 0, Tri.Get_Orig_Num_Rows());

    // get additional sub-domain data (if it is given)
    std::vector<Subdomain_Data>* SUB_ptr = NULL;
    if (nrhs > PRHS_Subdomain) SUB_ptr = Read_Subdomain_Data(prhs[PRHS_Subdomain]);

    // setup pointers within Rivara Bisection Object
    Bisection_obj->Setup_Data(GeoDim, &Vtx, &Tri, &Neighbor, SUB_ptr);
}
/***************************************************************************************/


/***************************************************************************************/
/* read in sub-domain data */
std::vector<Subdomain_Data>* TMC::Read_Subdomain_Data(const mxArray* mxSUB)
{
    // if there are no sub-domains...
    if (mxIsEmpty(mxSUB))
        {
        // then there is nothing to do!
        SUB.resize(0);
        }
    else
        {
        /* BEGIN: error checking */
        if (!mxIsStruct(mxSUB)) mexErrMsgTxt("Subdomain data must be a struct!");
        const unsigned int num_fields = (unsigned int) mxGetNumberOfFields(mxSUB);
        if (num_fields!=3) mexErrMsgTxt("Subdomain data must have 3 fields!");

        mxArray* SUB_Name = mxGetField(mxSUB, (mwIndex) 0, "Name");
        if (SUB_Name==NULL) mexErrMsgTxt("Subdomain data does not have a field called 'Name'!");
        mxArray* SUB_Dim  = mxGetField(mxSUB, (mwIndex) 0, "Dim");
        if (SUB_Dim==NULL)  mexErrMsgTxt("Subdomain data does not have a field called 'Dim'!");
        mxArray* SUB_Data = mxGetField(mxSUB, (mwIndex) 0, "Data");
        if (SUB_Data==NULL) mexErrMsgTxt("Subdomain data does not have a field called 'Data'!");
        /* END: error checking */

        // read in sub-domains into internal data structure
        //const unsigned int Num_Marked = (unsigned int) Bisection_obj->Marked_Triangles.size();
        const unsigned int num_sub_domains = (unsigned int) mxGetNumberOfElements(mxSUB);
        SUB.resize(num_sub_domains);
        for (unsigned int si = 0; (si < num_sub_domains); si++)
            {
            SUB_Name = mxGetField(mxSUB, (mwIndex) si, "Name");
            SUB_Dim  = mxGetField(mxSUB, (mwIndex) si, "Dim");
            SUB_Data = mxGetField(mxSUB, (mwIndex) si, "Data");
            const char* Name_string = mxArrayToString(SUB_Name);
            const unsigned int Sub_Top_Dim = (unsigned int) (*mxGetPr(SUB_Dim));
            const unsigned int max_tri = Tri.Get_Num_Rows();
            SUB[si].Setup_Data(Name_string, Sub_Top_Dim, SUB_Data, max_tri);
            }
        }
    std::vector<Subdomain_Data>* SUB_ptr = &SUB;
    return SUB_ptr;
}
/***************************************************************************************/


/***************************************************************************************/
/* copy data over */
void TMC::Output_Final_Data(const int& nlhs, mxArray* plhs[])
{
    if (nlhs > 0)
        {
        // create cell array to hold the vertex coordinates and triangle connectivity
        const mwSize dims[1] = {2};
        plhs[0] = mxCreateCellArray((mwSize) 1, dims);
        mxSetCell(plhs[0], (mwIndex) 0, Vtx.Copy_Final_Data());
        mxSetCell(plhs[0], (mwIndex) 1, Tri.Copy_Final_Data());
        }
    if (nlhs > 1) plhs[1] = Neighbor.Copy_Final_Data();
    // if there are sub-domains
    if (nlhs > 2)
        {
        // create array of structs
        const unsigned int num_sub_domains = (unsigned int) SUB.size();
        const mwSize dims[2] = {num_sub_domains, 1};
        const char* field_names[] = {"Name", "Dim", "Data"};
        plhs[2] = mxCreateStructArray((mwSize) 1, dims, (int) 3, field_names);
        for (unsigned int si = 0; (si < num_sub_domains); si++)
            {
            // output the data
            mxArray* mxName = mxCreateString(SUB[si].Get_Name());
            mxArray* mxDim  = mxCreateDoubleMatrix((mwSize) 1, (mwSize) 1, mxREAL);
            *mxGetPr(mxDim) = (double) SUB[si].Get_TopDim();
            mxSetField(plhs[2], (mwIndex) si, "Name", mxName);
            mxSetField(plhs[2], (mwIndex) si, "Dim",  mxDim);
            mxSetField(plhs[2], (mwIndex) si, "Data", SUB[si].Copy_Final_Data());
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* run the bisection routine */
void TMC::Execute_Rivara_Bisection()  // inputs
{
    // refine all
    Bisection_obj->Run_Bisection();
}
/***************************************************************************************/

#undef TMC

/***/
