function status = Gen_Mesh_Geometry_Class_cc(obj,Output_Dir)
%Gen_Mesh_Geometry_Class_cc
%
%   This generates the file: "Mesh_Geometry_Class.cc".

% Copyright (c) 04-07-2010,  Shawn W. Walker

WRITE_File = fullfile(Output_Dir, obj.CPP.Data_Type_Name_cc);
GeoElem = obj.Elem; % for convenience

% start with A part
obj.Copy_File('Mesh_Geometry_Class_A.cc',WRITE_File);
% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // set mesh geometry data type name
% #define MGC        MESH_GEOMETRY_Class
% // set the type of map
% #define MAP_type  "P2 Lagrange Map"
% 
% // set the Global mesh topological dimension
% #define GLOBAL_TD  1
% // set the Subdomain topological dimension
% #define SUB_TD  1
% // set the Domain of Integration (DoI) topological dimension
% #define DOI_TD  1
% // set the (ambient) geometric dimension
% #define GD  3
% // set the number of quad points
% #define NQ  12
% // set the number of basis functions
% #define NB  3
% // set whether to access the local (subdomain) simplex (facet) orientation
% #define ORIENT  false
% /*------------   END: Auto Generate ------------*/

Actual_GD = obj.Domain.Subdomain.GeoDim; % should be the same for Global, Subdomain, and DoI

% create C++ code for evaluating various geometric quantities
[obj, Geo_CODE, Orientation_TF] = obj.Gen_Geometry_Code_Snippets();
% you should not need to update the geometric element function object OUTSIDE this routine.

ENDL = '\n';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// set mesh geometry data type name', ENDL]);
fprintf(fid, ['#define MGC        ', obj.CPP.Data_Type_Name, ENDL]);
fprintf(fid, ['// set the type of map', ENDL]);
TYPE_str = [GeoElem.Element_Type, ' - ', GeoElem.Element_Name];
fprintf(fid, ['#define MAP_type  "', TYPE_str, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the Global mesh topological dimension', ENDL]);
fprintf(fid, ['#define GLOBAL_TD  ', num2str(obj.Domain.Global.Top_Dim), ENDL]);
fprintf(fid, ['// set the Subdomain topological dimension', ENDL]);
fprintf(fid, ['#define SUB_TD  ', num2str(obj.Domain.Subdomain.Top_Dim), ENDL]);
fprintf(fid, ['// set the Domain of Integration (DoI) topological dimension', ENDL]);
fprintf(fid, ['#define DOI_TD  ', num2str(obj.Domain.Integration_Domain.Top_Dim), ENDL]);
fprintf(fid, ['// set the (ambient) geometric dimension', ENDL]);
fprintf(fid, ['#define GD  ', num2str(Actual_GD), ENDL]);
fprintf(fid, ['// set the number of quad points', ENDL]);
fprintf(fid, ['#define NQ  ', num2str(obj.Domain.Num_Quad), ENDL]);
fprintf(fid, ['// set the number of basis functions', ENDL]);
fprintf(fid, ['#define NB  ', num2str(GeoElem.Num_Basis), ENDL]);
fprintf(fid, ['// set whether to access the local simplex (facet) orientation', ENDL]);
if Orientation_TF
    fprintf(fid, ['#define ORIENT  ', 'true', ENDL]);
else
    fprintf(fid, ['#define ORIENT  ', 'false', ENDL]);
end
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% CPP data type info for transformation code
CDMap = Codim_Map(obj);
Local_Transformation_CPP = CDMap.Get_Geometric_Map_Local_Transformation;

% write the class definition
status = obj.Gen_Mesh_Geometry_Class_Defn(fid,Geo_CODE,Local_Transformation_CPP);
% write the class constructor
status = obj.Gen_Mesh_Geometry_Class_Constructor(fid,Geo_CODE);

% append the B part
status = obj.Append_File(fid,'Mesh_Geometry_Class_B.cc');

status = obj.Gen_Local_Transformations_Code(fid,Geo_CODE,Local_Transformation_CPP);

% append the C part
status = obj.Append_File(fid,'Mesh_Geometry_Class_C.cc');

% DONE!
fclose(fid);

end