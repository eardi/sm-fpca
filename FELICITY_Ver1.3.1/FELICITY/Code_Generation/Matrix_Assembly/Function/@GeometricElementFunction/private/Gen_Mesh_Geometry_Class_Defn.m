function status = Gen_Mesh_Geometry_Class_Defn(obj,fid,Geo_CODE,Compute_Local_Transformation)
%Gen_Mesh_Geometry_Class_Defn
%
%   This declares the Mesh_Geometry_Class definition.

% Copyright (c) 06-15-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/* C++ (Specific) Mesh class definition */', ENDL]);
fprintf(fid, ['class MGC: public Abstract_MESH_GEOMETRY_Class // derive from base class', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, [TAB, '/***************************************************************************************/', ENDL]);
fprintf(fid, [TAB, '// data structures containing information about the local mapping from a', ENDL]);
fprintf(fid, [TAB, '// reference simplex to the actual element in the mesh.', ENDL]);
fprintf(fid, [TAB, '// Note: this data is evaluated at several quadrature points.', ENDL]);

% write the geometry variable declarations
for ind=1:length(Geo_CODE)
    DECLARE = Geo_CODE(ind).Defn;
    for di=1:length(DECLARE)
        fprintf(fid, [TAB, DECLARE(di).line, ENDL]);
    end
end

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, 'MGC (); // constructor', ENDL]);
fprintf(fid, [TAB, '~MGC ();   // DE-structor', ENDL]);
fprintf(fid, [TAB, 'void Setup_Mesh_Geometry(const mxArray*, const mxArray*, const mxArray*);', ENDL]);
fprintf(fid, [TAB, 'void Compute_Local_Transformation();', ENDL]);

fprintf(fid, [TAB, 'void Get_Current_Cell_Vertex_Indices(int Vtx_Indices[SUB_TD+1]) const', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// transfer global vertex indices from kc[:]', ENDL]);
fprintf(fid, [TAB2, '// Note: this code is custom made for this geometry class', ENDL]);
% determine which DoFs are associated with the vertex indices: V0, V1, V2, V3
Vtx_DoFs = obj.Elem.Nodal_Top.V{1}; % only need the first set
Vtx_Indices = Vtx_DoFs(:,1); % local DoF indices
for ii = 1:length(Vtx_Indices)
    fprintf(fid, [TAB2, 'Vtx_Indices[', num2str(ii-1), '] = kc[', num2str(Vtx_Indices(ii)-1), '];', ENDL]);
end
fprintf(fid, [TAB2, '}', ENDL]);

fprintf(fid, [TAB, 'double Orientation[SUB_TD+1]; // mesh "facet" orientation direction for the current subdomain element', ENDL]);
fprintf(fid, [TAB, '// pointer to Domain class', ENDL]);
CPP = obj.Domain.Determine_CPP_Info;
fprintf(fid, [TAB, 'const ', CPP.Data_Type_Name, '*', '   ', 'Domain;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['private:', ENDL]);
fprintf(fid, [TAB, 'double*  Node_Value[GD];    // mesh node values', ENDL]);
fprintf(fid, [TAB, 'int*     Elem_DoF[NB];      // element DoF list', ENDL]);
fprintf(fid, [TAB, 'bool*    Elem_Orient[SUB_TD+1]; // element facet orientation', ENDL]);
fprintf(fid, [TAB, '                                // true  = face has an outward normal vector (+1)', ENDL]);
fprintf(fid, [TAB, '                                // false = face has an  inward normal vector (-1)', ENDL]);
fprintf(fid, [TAB, 'int      kc[NB];            // for storing the local mesh element DoFmap', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, 'void Get_Local_to_Global_DoFmap(const int&, int*);', ENDL]);
fprintf(fid, [TAB, 'void Get_Local_Orientation(const int&);', ENDL]);

for ind = 1:Compute_Local_Transformation.Num_Compute_Map
    fprintf(fid, [TAB, 'void ', Compute_Local_Transformation.Compute_Map(ind).CPP_Name, '(const int&);', ENDL]);
end

fprintf(fid, ['};', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end