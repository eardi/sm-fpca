function status = Gen_Local_Transformations_Code(obj,fid,BF_CODE,Premap_CODE)
%Gen_Local_Transformations_Code
%
%   This creates the necessary transformations for computing with or without
%   subdomains of Codim > 0.

% Copyright (c) 03-19-2012,  Shawn W. Walker

%%%%%% get info about this particular mesh geometry
%%%MESH_GEOMETRY_Class_str = obj.GeomFunc.CPP.Data_Type_Name;

% get the local transformations needed for every possible trace.  if this is
% intrinsic, then this is a simple struct
CDMap = Codim_Map(obj.GeomFunc);
Compute_Local_Transformation = CDMap.Get_Basis_Function_Local_Transformation();

% write the generic calling routine
status = obj.Write_SUBRoutine_Transform_Basis_Functions(fid,Compute_Local_Transformation);

% only write this when the basis function is NOT a global constant!
if ~isa(obj.FuncTrans,'Constant_Trans')
    % write every subroutine for each local mesh entity (there is more than one if
    % we are computing traces of the basis functions)
    for map_i = 1:Compute_Local_Transformation.Num_Map_Basis
        status = obj.Write_SUBRoutine_Map_Basis_Function(fid,BF_CODE,Premap_CODE,...
                                      Compute_Local_Transformation.Map_Basis(map_i));
    end
end

% write basis function (direct) evaluations
% for H^1 only and only when not generating code for interpolation
if and(isa(obj.FuncTrans,'H1_Trans'),~obj.INTERPOLATION)
    Val_CODE = obj.FuncTrans.FUNC_Val_special_C_Code;
    % write basis function (direct) evaluations
    for map_i = 1:Compute_Local_Transformation.Num_Map_Basis
        status = obj.Write_SUBRoutine_Basis_Value(fid,Val_CODE,Compute_Local_Transformation.Map_Basis(map_i));
    end
end

end