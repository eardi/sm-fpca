function status = Write_SUBRoutine_Compute_Map(obj,fid,Geo_CODE,Compute_Map)
%Write_SUBRoutine_Compute_Map
%
%   This generates a sub-routine of the Mesh_Geometry_Class for computing
%   transformations of the local element map.

% Copyright (c) 03-10-2012,  Shawn W. Walker

ENDL = '\n';

% insert code snippet
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* compute the local transformation from the standard reference element', ENDL]);
fprintf(fid, ['          to an element in the Mesh    */', ENDL]);
fprintf(fid, ['void MGC::', Compute_Map.CPP_Name,...
                         '(const int& elem_index)           // current mesh element index', ENDL]);
fprintf(fid, ['{', ENDL]);
% fprintf(fid, ['int kc[NB];      // for indexing through the mesh DoFmap', ENDL]);
% fprintf(fid, ['', ENDL]);
fprintf(fid, ['Get_Local_to_Global_DoFmap(elem_index, kc);', ENDL]);
fprintf(fid, ['', ENDL]);
% get number of derivatives to compute
Num_Deriv = obj.GeoTrans.Number_Of_Derivatives_For_Opt(obj.Opt);

% insert basis function evaluations at the quad points
if obj.INTERPOLATION
    % no quad points here
    status = obj.Write_Geometry_Basis_Eval_Interpolation_snip(fid,Num_Deriv,Compute_Map);
else
    status = obj.Write_Geometry_Basis_Eval_snip(fid,Num_Deriv,Compute_Map);
end

% insert basis function evaluations at the local vertex coordinates
special_case_for_mesh_size(obj,fid,Compute_Map);

% now insert the geometry computation code
obj.Write_Geometry_Computation_Code_snippets(fid,Geo_CODE);

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end

function status = special_case_for_mesh_size(obj,fid,Compute_Map)

% if you want the mesh size
if (obj.Opt.Mesh_Size)
    % then you need some extra basis function evaluations
    
    % get bogus quadrature rule on the ref elem
    Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type);
    % get basis functions on reference element
    Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,0);
    
    % map geometric basis functions onto local mesh entity
    CDMap = Codim_Map(obj);
    Eval_Basis = CDMap.Map_Geometric_Basis_Function_Evals(Eval_Basis,Compute_Map.Codim_Map);
    
    % get the "corner vertices" of the local topological entity
    Quad.Pt = Get_Local_Simplex_Vertex_Coordinates(Compute_Map);
    Num_Quad_str = num2str(size(Quad.Pt,1));
    for bb = 1:length(Eval_Basis)
        % evaluate all of the basis functions at the corner vertices
        % (on the local mesh entity)
        Eval_Basis(bb) = Eval_Basis(bb).Fill_Eval(Quad.Pt);
    end
    
    ENDL = '\n';
    % output text-lines
    fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
    OUTSTR = ['// basis function evaluations at the local element vertices'];
    fprintf(fid, [OUTSTR, ENDL]);
    Pick_Deriv = [0];
    status = obj.Generic_Write_Basis_Eval_to_CPP_Code_OLD('Geo_Vtx',Num_Quad_str,'NB',Eval_Basis,[1 1],Pick_Deriv,fid,'');
    
    % NEXT, quad points
    COMMENT = '// ';
    status = obj.Gen_Quad_Point_CPP_Code(Quad.Pt,fid,COMMENT,'GLOBAL_TD');
    
    fprintf(fid, [obj.END_Auto_Gen, ENDL]);
end

end