function status = Gen_Basis_Function_Class_Defn(obj,fid,BF_CODE)
%Gen_Basis_Function_Class_Defn
%
%   This declares the Basis_Function_Class definition.

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/* C++ (Specific) FEM Function class definition */', ENDL]);
fprintf(fid, ['class SpecificFUNC: public ABSTRACT_FEM_Function_Class // derive from base class', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, [TAB, 'int*     Elem_DoF[NB];    // element DoF list', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// data structure containing information on the function evaluations.', ENDL]);
fprintf(fid, [TAB, '// Note: this data is evaluated at several quadrature points!', ENDL]);
% write the basis function variable declarations
VAL_CODE = special_case(obj);
if ~isempty(VAL_CODE)
    DECLARE = VAL_CODE.Defn;
    for di=1:length(DECLARE)
        fprintf(fid, [TAB, DECLARE(di).line, ENDL]);
    end
end
for ind=1:length(BF_CODE)
    DECLARE = BF_CODE(ind).Defn;
    for di=1:length(DECLARE)
        fprintf(fid, [TAB, DECLARE(di).line, ENDL]);
    end
end

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// constructor', ENDL]);
fprintf(fid, [TAB, 'SpecificFUNC ();', ENDL]);
fprintf(fid, [TAB, '~SpecificFUNC (); // destructor', ENDL]);
fprintf(fid, [TAB, 'void Setup_Function_Space(const mxArray*);', ENDL]);
fprintf(fid, [TAB, 'void Get_Local_to_Global_DoFmap(const int&, int*) const;', ENDL]);
fprintf(fid, [TAB, '               // need the "const" to ENSURE that nothing in this object will change!', ENDL]);
fprintf(fid, [TAB, 'void Transform_Basis_Functions();', ENDL]);
fprintf(fid, [TAB, 'const ', obj.GeomFunc.CPP.Data_Type_Name, '*  Mesh;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['private:', ENDL]);

CDMap = Codim_Map(obj.GeomFunc);
Compute_Local_Transformation = CDMap.Get_Basis_Function_Local_Transformation;
for ind = 1:Compute_Local_Transformation.Num_Map_Basis
    % Map_Basis...
    fprintf(fid, [TAB, 'void ', Compute_Local_Transformation.Map_Basis(ind).CPP_Name, '();', ENDL]);
end
if ~isempty(VAL_CODE) % special case code for H^1 function evaluation
    for ind = 1:Compute_Local_Transformation.Num_Map_Basis
        fprintf(fid, [TAB, Compute_Local_Transformation.Map_Basis(ind).Val.Declare_CPP, ENDL]);
    end
    for ind = 1:Compute_Local_Transformation.Num_Map_Basis
        fprintf(fid, [TAB, 'void ', Compute_Local_Transformation.Map_Basis(ind).Val.CPP_Routine,...
                           '(SCALAR V[NB][NQ]);', ENDL]);
    end
end

status = fprintf(fid, ['};', ENDL]);
status = fprintf(fid, ['', ENDL]);

end

function VAL_CODE = special_case(obj)

% SPECIAL CASE
% only do this for H^1 functions (and only if we are not generating
%      interpolation code)
if and(isa(obj.FuncTrans,'H1_Trans'),~obj.INTERPOLATION)
    % we will compute this ONCE for all elements
    VAL_CODE = obj.FuncTrans(1).FUNC_Val_C_Code; % we can just take the first one
else
    VAL_CODE = [];
end

end