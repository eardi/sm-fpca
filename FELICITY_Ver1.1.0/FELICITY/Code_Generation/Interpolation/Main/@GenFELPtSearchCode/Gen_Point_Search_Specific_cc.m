function Gen_Point_Search_Specific_cc(obj,FPS,Search_Domain)
%Gen_Point_Search_Specific_cc
%
%   This generates the file: "CLASS_Search_SPECIFIC.cc", except with a more
%   specific filename!

% Copyright (c) 07-26-2014,  Shawn W. Walker

ENDL = '\n';

% get specific domain search information
CPP_PTS  = FPS.Get_CPP_Point_Search_Vars(Search_Domain.Name);

% start with A part
File1 = [CPP_PTS.Search_Obj_CPP_Type, '.cc'];
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Point_Search_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Point_Search_Specific_A.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // This class finds points (i.e. their enclosing cell index and local reference coordinates)
% // in this domain:  Omega,
% //                   with topological dimension = 2
% //                    and   geometric dimension = 2
% /*------------   END: Auto Generate ------------*/
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// This class finds points (i.e. their enclosing cell index and local reference coordinates)', ENDL]);
fprintf(fid, ['// in this domain:  ', Search_Domain.Name, ',', ENDL]);
fprintf(fid, ['//                   with topological dimension = ', num2str(Search_Domain.Top_Dim), ENDL]);
fprintf(fid, ['//                    and   geometric dimension = ', num2str(Search_Domain.GeoDim), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the search domain (should be the same as the filename of this file)
% #define SpecificSEARCH        CLASS_Search_Omega
% #define SpecificSEARCH_str   "CLASS_Search_Omega"
% /*------------   END: Auto Generate ------------*/

% get geometric function for the current search domain
GF = FPS.GeomFuncs(Search_Domain.Name);
TD = Search_Domain.Top_Dim();
Num_V = TD + 1;
Degree_Estimate = round(GF.Elem.Num_Basis / Num_V);
Num_Intermediate_Pts = 2 * Degree_Estimate - 1;
if strncmpi(GF.Elem.Element_Name,'lagrange_deg1',13)
    % when each cell is linear, we do not need to evaluate intermediate points
    Num_Intermediate_Pts = 0;
    LINEAR = true;
else
    LINEAR = false;
end
[Pound_Defines, C_Proto, Append_FileName] = get_c_code_bits(Search_Domain,Num_Intermediate_Pts,LINEAR);

% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define the name of the search domain (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificSEARCH        ', CPP_PTS.Search_Obj_CPP_Type, ENDL]);
fprintf(fid, ['#define SpecificSEARCH_str   "', CPP_PTS.Search_Obj_CPP_Type, '"', ENDL]);
fprintf(fid, ['', ENDL]);
% define a bunch of tolerance and max iter stuff...
if ~isempty(Pound_Defines)
    fprintf(fid, ['// define optimization parameters', ENDL]);
end
for ind = 1:length(Pound_Defines)
    fprintf(fid, [Pound_Defines(ind).def, ENDL]);
end
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* C++ (Specific) Point Search class */', ENDL]);
fprintf(fid, ['class SpecificSEARCH: public Mesh_Point_Search_Class // derive from base class', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // access and compute domain embedding info
%     CLASS_Domain_Omega_embedded_in_Omega_restricted_to_Omega*  Domain;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// access and compute domain embedding info', ENDL]);
Domain_CPP = GF.Domain.Determine_CPP_Info;
fprintf(fid, ['    ', Domain_CPP.Data_Type_Name, '*  ',...
                      'Domain', ';', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // access and compute local mesh geometry info
%     CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega*  GeomFunc;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// access and compute local mesh geometry info', ENDL]);
fprintf(fid, ['    ', GF.CPP.Data_Type_Name, '*  ',...
                      'GeomFunc', ';', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% this will write the pre-declarations
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// constructor', ENDL]);
CONSTRUCTOR_STR = ['SpecificSEARCH (const Subdomain_Search_Data_Class*, Unstructured_Local_Points_Class*);'];
fprintf(fid, ['    ', CONSTRUCTOR_STR, ENDL]);
fprintf(fid, ['    ', '~SpecificSEARCH (); // destructor', ENDL]);
fprintf(fid, ['    ', 'void Consistency_Check();', ENDL]);
% write routines that are specific to the search domain's topological and geometric dimension!
for ind = 1:length(C_Proto)
    fprintf(fid, ['    ', C_Proto(ind).func_prototype, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'private:', ENDL]);

fprintf(fid, ['};', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% append the next part
Fixed_File = fullfile(obj.Skeleton_Dir, 'Point_Search_Specific_B.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% now append file that is specific to the search domain's topological and geometric dimension!
Fixed_File = fullfile(obj.Skeleton_Dir, Append_FileName);
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

fprintf(fid, ['', '// remove those macros!', ENDL]);
fprintf(fid, ['', '#undef SpecificSEARCH', ENDL]);
fprintf(fid, ['', '#undef SpecificSEARCH_str', ENDL]);
fprintf(fid, ['', '', ENDL]);
for ind = 1:length(Pound_Defines)
    fprintf(fid, [Pound_Defines(ind).undef, ENDL]);
end
if ~isempty(Pound_Defines)
    fprintf(fid, ['', '', ENDL]);
end
fprintf(fid, ['', '/***/', ENDL]);

% DONE!
fclose(fid);

end

function [Pound_Defines, C_Proto, Append_FileName] =...
                      get_c_code_bits(Search_Domain,Num_Intermediate_Pts,LINEAR)

TopDim = Search_Domain.Top_Dim;
GeoDim = Search_Domain.GeoDim;

% the #defines depend on the search domain

% the function prototypes depend on the topological and geometric dimension
%     of the search domain

Pound_Defines.def = []; % init
Pound_Defines.undef = []; % init
C_Proto.func_prototype = []; % init

if (TopDim==1)
    
    if (GeoDim==1) % TopDim=GeoDim
        Pound_Defines(4).def = []; % init
        Pound_Defines(1).def = '#define NEWTON_TOL  1E-13';
        Pound_Defines(1).undef = '#undef NEWTON_TOL';
        Pound_Defines(2).def = '#define REF_CELL_TOL  1E-12';
        Pound_Defines(2).undef = '#undef REF_CELL_TOL';
        Pound_Defines(3).def = '#define PT_DATA_TOPDIM_GEODIM_TYPE  PT_DATA_Top1_Geo1';
        Pound_Defines(3).undef = '#undef PT_DATA_TOPDIM_GEODIM_TYPE';
        Pound_Defines(4).def = '#define VEC_DIM_TYPE  VEC_1x1';
        Pound_Defines(4).undef = '#undef VEC_DIM_TYPE';
        if LINEAR
            Pound_Defines(5).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(5).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(3).func_prototype = []; % init
        C_Proto(1).func_prototype = 'void Find_Points();';
        C_Proto(2).func_prototype = 'bool Find_Single_Point(PT_DATA_Top1_Geo1&);';
        C_Proto(3).func_prototype = 'int  One_Iteration(PT_DATA_Top1_Geo1&);';
        Append_FileName = 'Point_Search_Specific_TopDim_EQUAL_GeoDim.cc';
    elseif (GeoDim==2)
        Pound_Defines(8).def = []; % init
        Pound_Defines(1).def = ['#define NUM_INTERMEDIATE_PTS  ', num2str(Num_Intermediate_Pts)];
        Pound_Defines(1).undef = '#undef NUM_INTERMEDIATE_PTS';
        Pound_Defines(2).def = '#define OPT_TOL  1E-8';
        Pound_Defines(2).undef = '#undef OPT_TOL';
        Pound_Defines(3).def = '#define BIAS_TOL  0.25'; % positive and smaller than 0.5
        Pound_Defines(3).undef = '#undef BIAS_TOL';
        Pound_Defines(4).def = '#define MAX_QUEUE_SIZE  200';
        Pound_Defines(4).undef = '#undef MAX_QUEUE_SIZE';
        Pound_Defines(5).def = '#define MAX_LINE_SEARCH_ITER  300';
        Pound_Defines(5).undef = '#undef MAX_LINE_SEARCH_ITER';
        Pound_Defines(6).def = '#define PT_DATA_TOPDIM_GEODIM_TYPE  PT_DATA_Top1_Geo2';
        Pound_Defines(6).undef = '#undef PT_DATA_TOPDIM_GEODIM_TYPE';
        Pound_Defines(7).def = '#define VEC_DIM_TYPE  VEC_2x1';
        Pound_Defines(7).undef = '#undef VEC_DIM_TYPE';
        Pound_Defines(8).def = '#define MAT_DIM_TYPE  MAT_2x1';
        Pound_Defines(8).undef = '#undef MAT_DIM_TYPE';
        if LINEAR
            Pound_Defines(9).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(9).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(14).func_prototype = []; % init
        C_Proto( 1).func_prototype = 'void Find_Points();';
        C_Proto( 2).func_prototype = 'bool Get_Valid_Neighbor(unsigned int&, const int&,';
        C_Proto( 3).func_prototype = '                        const unsigned int*, const unsigned int&);';
        C_Proto( 4).func_prototype = 'bool Find_Single_Point(PT_DATA_Top1_Geo2&);';
        C_Proto( 5).func_prototype = 'bool Find_Single_Point_Sub_Iter(const VEC_2x1&, unsigned int&,';
        C_Proto( 6).func_prototype = '                                unsigned int*,  unsigned int&,';
        C_Proto( 7).func_prototype = '                                Min_On_Cell_Top1&, int&);';
        C_Proto( 8).func_prototype = 'void Compute_Min_On_Interval(const VEC_2x1&, const unsigned int&,';
        C_Proto( 9).func_prototype = '                             unsigned int*, unsigned int&,';
        C_Proto(10).func_prototype = '                             Min_On_Cell_Top1&, int&);';
        C_Proto(11).func_prototype = 'double Eval_Cost(const VEC_2x1&, const VEC_1x1&);';
        C_Proto(12).func_prototype = 'void Eval_Cost_And_Gradient(const VEC_2x1&, const VEC_1x1&, SCALAR&, VEC_1x1&);';
        C_Proto(13).func_prototype = 'void Bisection_And_Cubic_Line_Search(const VEC_2x1&, const unsigned int&,';
        C_Proto(14).func_prototype = '                                     const double&, Min_On_Cell_Top1&, Min_On_Cell_Top1&);';
        Append_FileName = 'Point_Search_Specific_TopDim1_GeoDim2or3.cc';
    elseif (GeoDim==3)
        Pound_Defines(8).def = []; % init
        Pound_Defines(1).def = ['#define NUM_INTERMEDIATE_PTS  ', num2str(Num_Intermediate_Pts)];
        Pound_Defines(1).undef = '#undef NUM_INTERMEDIATE_PTS';
        Pound_Defines(2).def = '#define OPT_TOL  1E-8';
        Pound_Defines(2).undef = '#undef OPT_TOL';
        Pound_Defines(3).def = '#define BIAS_TOL  0.25'; % positive and smaller than 0.5
        Pound_Defines(3).undef = '#undef BIAS_TOL';
        Pound_Defines(4).def = '#define MAX_QUEUE_SIZE  200';
        Pound_Defines(4).undef = '#undef MAX_QUEUE_SIZE';
        Pound_Defines(5).def = '#define MAX_LINE_SEARCH_ITER  300';
        Pound_Defines(5).undef = '#undef MAX_LINE_SEARCH_ITER';
        Pound_Defines(6).def = '#define PT_DATA_TOPDIM_GEODIM_TYPE  PT_DATA_Top1_Geo3';
        Pound_Defines(6).undef = '#undef PT_DATA_TOPDIM_GEODIM_TYPE';
        Pound_Defines(7).def = '#define VEC_DIM_TYPE  VEC_3x1';
        Pound_Defines(7).undef = '#undef VEC_DIM_TYPE';
        Pound_Defines(8).def = '#define MAT_DIM_TYPE  MAT_3x1';
        Pound_Defines(8).undef = '#undef MAT_DIM_TYPE';
        if LINEAR
            Pound_Defines(9).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(9).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(14).func_prototype = []; % init
        C_Proto( 1).func_prototype = 'void Find_Points();';
        C_Proto( 2).func_prototype = 'bool Get_Valid_Neighbor(unsigned int&, const int&,';
        C_Proto( 3).func_prototype = '                        const unsigned int*, const unsigned int&);';
        C_Proto( 4).func_prototype = 'bool Find_Single_Point(PT_DATA_Top1_Geo3&);';
        C_Proto( 5).func_prototype = 'bool Find_Single_Point_Sub_Iter(const VEC_3x1&, unsigned int&,';
        C_Proto( 6).func_prototype = '                                unsigned int*,  unsigned int&,';
        C_Proto( 7).func_prototype = '                                Min_On_Cell_Top1&, int&);';
        C_Proto( 8).func_prototype = 'void Compute_Min_On_Interval(const VEC_3x1&, const unsigned int&,';
        C_Proto( 9).func_prototype = '                             unsigned int*, unsigned int&,';
        C_Proto(10).func_prototype = '                             Min_On_Cell_Top1&, int&);';
        C_Proto(11).func_prototype = 'double Eval_Cost(const VEC_3x1&, const VEC_1x1&);';
        C_Proto(12).func_prototype = 'void Eval_Cost_And_Gradient(const VEC_3x1&, const VEC_1x1&, SCALAR&, VEC_1x1&);';
        C_Proto(13).func_prototype = 'void Bisection_And_Cubic_Line_Search(const VEC_3x1&, const unsigned int&,';
        C_Proto(14).func_prototype = '                                     const double&, Min_On_Cell_Top1&, Min_On_Cell_Top1&);';
        Append_FileName = 'Point_Search_Specific_TopDim1_GeoDim2or3.cc';
    else
        error('Invalid!');
    end

elseif (TopDim==2)
    
    if (GeoDim==2) % TopDim=GeoDim
        Pound_Defines(4).def = []; % init
        Pound_Defines(1).def = '#define NEWTON_TOL  1E-13';
        Pound_Defines(1).undef = '#undef NEWTON_TOL';
        Pound_Defines(2).def = '#define REF_CELL_TOL  1E-12';
        Pound_Defines(2).undef = '#undef REF_CELL_TOL';
        Pound_Defines(3).def = '#define PT_DATA_TOPDIM_GEODIM_TYPE  PT_DATA_Top2_Geo2';
        Pound_Defines(3).undef = '#undef PT_DATA_TOPDIM_GEODIM_TYPE';
        Pound_Defines(4).def = '#define VEC_DIM_TYPE  VEC_2x1';
        Pound_Defines(4).undef = '#undef VEC_DIM_TYPE';
        if LINEAR
            Pound_Defines(5).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(5).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(3).func_prototype = []; % init
        C_Proto(1).func_prototype = 'void Find_Points();';
        C_Proto(2).func_prototype = 'bool Find_Single_Point(PT_DATA_Top2_Geo2&);';
        C_Proto(3).func_prototype = 'int  One_Iteration(PT_DATA_Top2_Geo2&);';
        Append_FileName = 'Point_Search_Specific_TopDim_EQUAL_GeoDim.cc';
    elseif (GeoDim==3)
        Pound_Defines(6).def = []; % init
        Pound_Defines(1).def = ['#define NUM_INTERMEDIATE_PTS  ', num2str(Num_Intermediate_Pts)];
        Pound_Defines(1).undef = '#undef NUM_INTERMEDIATE_PTS';
        Pound_Defines(2).def = '#define OPT_TOL  1E-8';
        Pound_Defines(2).undef = '#undef OPT_TOL';
        Pound_Defines(3).def = '#define BIAS_TOL  0.25'; % positive and smaller than 0.5
        Pound_Defines(3).undef = '#undef BIAS_TOL';
        Pound_Defines(4).def = '#define MAX_QUEUE_SIZE  200';
        Pound_Defines(4).undef = '#undef MAX_QUEUE_SIZE';
        Pound_Defines(5).def = '#define MAX_GRADIENT_DESCENT_ITER  500';
        Pound_Defines(5).undef = '#undef MAX_GRADIENT_DESCENT_ITER';
        Pound_Defines(6).def = '#define MAX_LINE_SEARCH_ITER  300';
        Pound_Defines(6).undef = '#undef MAX_LINE_SEARCH_ITER';
        if LINEAR
            Pound_Defines(7).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(7).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(17).func_prototype = []; % init
        C_Proto( 1).func_prototype = 'void Find_Points();';
        C_Proto( 2).func_prototype = 'bool Get_Valid_Neighbor(unsigned int&, int&, const int&,';
        C_Proto( 3).func_prototype = '                        const unsigned int*, const unsigned int&);';
        C_Proto( 4).func_prototype = 'bool Find_Single_Point(PT_DATA_Top2_Geo3&);';
        C_Proto( 5).func_prototype = 'bool Find_Single_Point_Sub_Iter(const VEC_3x1& GX, unsigned int& ci,';
        C_Proto( 6).func_prototype = '                                unsigned int* ciq, unsigned int& qs,';
        C_Proto( 7).func_prototype = '                                Min_On_Cell_Top2& M, int ln[2]);';
        C_Proto( 8).func_prototype = 'void Compute_Min_On_Triangle(const VEC_3x1& GX, const unsigned int& ci,';
        C_Proto( 9).func_prototype = '                             const int& asi, const int& pmsi,';
        C_Proto(10).func_prototype = '                             unsigned int* ciq, unsigned int& qs,';
        C_Proto(11).func_prototype = '                             Min_On_Cell_Top2& M, int ln[2]);';
        C_Proto(12).func_prototype = 'bool Run_Gradient_Descent(const VEC_3x1&, Min_On_Cell_Top2&, const double&);';
        C_Proto(13).func_prototype = 'double Eval_Cost(const VEC_3x1&, const VEC_2x1&);';
        C_Proto(14).func_prototype = 'void Eval_Cost_And_Gradient(const VEC_3x1&, const VEC_2x1&, SCALAR&, VEC_2x1&);';
        C_Proto(15).func_prototype = 'void Eval_Cost_And_Directional_Deriv(const VEC_3x1&, const VEC_2x1&, const VEC_2x1&, SCALAR&, SCALAR&);';
        C_Proto(16).func_prototype = 'void Bisection_And_Cubic_Line_Search(const VEC_3x1&, const VEC_2x1&, const unsigned int&,';
        C_Proto(17).func_prototype = '                                     const double&, Min_On_Cell_Top2&, Min_On_Cell_Top2&);';
        Append_FileName = 'Point_Search_Specific_TopDim2_GeoDim3.cc';
    else
        error('Invalid!');
    end
    
elseif (TopDim==3)
    
    if (GeoDim==3) % TopDim=GeoDim
        Pound_Defines(4).def = []; % init
        Pound_Defines(1).def = '#define NEWTON_TOL  1E-13';
        Pound_Defines(1).undef = '#undef NEWTON_TOL';
        Pound_Defines(2).def = '#define REF_CELL_TOL  1E-12';
        Pound_Defines(2).undef = '#undef REF_CELL_TOL';
        Pound_Defines(3).def = '#define PT_DATA_TOPDIM_GEODIM_TYPE  PT_DATA_Top3_Geo3';
        Pound_Defines(3).undef = '#undef PT_DATA_TOPDIM_GEODIM_TYPE';
        Pound_Defines(4).def = '#define VEC_DIM_TYPE  VEC_3x1';
        Pound_Defines(4).undef = '#undef VEC_DIM_TYPE';
        if LINEAR
            Pound_Defines(5).def = '#define LINEAR_CELL'; % faster min finding can be used here
            Pound_Defines(5).undef = '#undef LINEAR_CELL';
        end
        
        C_Proto(3).func_prototype = []; % init
        C_Proto(1).func_prototype = 'void Find_Points();';
        C_Proto(2).func_prototype = 'bool Find_Single_Point(PT_DATA_Top3_Geo3&);';
        C_Proto(3).func_prototype = 'int  One_Iteration(PT_DATA_Top3_Geo3&);';
        Append_FileName = 'Point_Search_Specific_TopDim_EQUAL_GeoDim.cc';
    else
        error('Invalid!');
    end
    
else
    error('Invalid!');
end

end