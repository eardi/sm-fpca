function Gen_Domain_Class_cc(obj,Output_Dir)
%Gen_Domain_Class_cc
%
%   This generates the file: "Domain_Class.cc".

% Copyright (c) 06-06-2012,  Shawn W. Walker

% Notes about the Domain class and how embedded domains are captured.
% Remark: Suppose the Domain of Integation (DoI) consists of one element.
% Multiple elements are handled by a for loop (i.e. assembly loop).
%
% Global Cell Index: refers to a particular ``cell'' in the Global mesh.  From
% this cell, we can reconstruct the local geometry of the Subdomain from the
% information described below.
%
% Subdomain Cell Index: refers to the ``local'' cell index of the Subdomain.
% For example, a subdomain always consists of a collection of cells, though
% these cells may be of lower topological dimension than the Global cells.
% Anyway, we always need to know what the local cell index is of the Subdomain.
% This is useful when a function is defined on the Subdomain, but we want to
% evaluate it on the Domain of Integration (DoI; see below).
%
% Subdomain Entity Index: refers to the local topological entity (with respect
% to the Global Cell) that the Subdomain is represented by.  For example, if the
% Global mesh consists of tetrahedra, and the Subdomain is a surface embedded in
% a set of faces in the tetrahedra, then
%
%          Subdomain Entity Index = +/- 1,2,3,4,
%
% where the index is the local face number of the tetrahedron referenced by
% Global Cell Index.  The sign gives the orientation.
%
% DoI Entity Index: refers to the local topological entity (with respect
% to the *Subdomain Cell*) that the *DoI is represented by*. Otherwise, similar
% to Subdomain Entity Index.
%
% Remarks: All of the above data structures are column vectors of the same
% length, where each row corresponds to one element of the DoI.
%
% Remarks: The Global and Subdomain Cell Indices are always needed.  You only
% need the Subdomain Entity Index if the topological dimensions of the Global
% mesh and the Subdomain are different.  Likewise, you only need the DoI Entity
% Index when the topological dimensions of the Subdomain and the DoI differ.
%
% note: this implies that the only time when you need all indices, is when the
% Global mesh is 3-D, the Subdomain is 2-D, and the DoI is 1-D.

CPP_Subdomain = obj.Determine_CPP_Info;
WRITE_File = fullfile(Output_Dir, CPP_Subdomain.Data_Type_Name_cc);

% start with A part
obj.Copy_File('Domain_Class_A.cc',WRITE_File);
% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // set subdomain data type name
% #define MDC        CLASS_Domain_XXXXXXX
% // set the name of the Global mesh
% #define GLOBAL_MESH_Name  "Global"
% // set the name of the subdomain
% #define SUBDOMAIN_Name  "Gamma"
% // set the name of the domain of integration
% #define DOMAIN_INTEGRATION_Name  "Boundary"
% 
% // set the number of local entities in subdomain
% #define SUB_NE  1
% // set the number of local entities in domain of integration
% #define DOI_NE  3
% /*------------   END: Auto Generate ------------*/

% get number of local mesh entities
[Num_Sub, Num_DoI] = obj.Get_Local_Entity_Numbers;

ENDL = '\n';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// set subdomain data type name', ENDL]);
fprintf(fid, ['#define MDC        ', CPP_Subdomain.Data_Type_Name, ENDL]);
fprintf(fid, ['// set the name of the Global mesh (TopDim = ', num2str(obj.Global.Top_Dim), ')', ENDL]);
fprintf(fid, ['#define GLOBAL_MESH_Name  "', obj.Global.Name, '"', ENDL]);
fprintf(fid, ['// set the name of the subdomain (TopDim = ', num2str(obj.Subdomain.Top_Dim), ')', ENDL]);
fprintf(fid, ['#define SUBDOMAIN_Name  "', obj.Subdomain.Name, '"', ENDL]);
fprintf(fid, ['// set the name of the domain of integration (TopDim = ', num2str(obj.Integration_Domain.Top_Dim), ')', ENDL]);
fprintf(fid, ['#define DOMAIN_INTEGRATION_Name  "', obj.Integration_Domain.Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of local entities in subdomain', ENDL]);
fprintf(fid, ['#define SUB_NE  ', num2str(Num_Sub), ENDL]);
fprintf(fid, ['// set the number of local entities in domain of integration', ENDL]);
fprintf(fid, ['#define DOI_NE  ', num2str(Num_DoI), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
status = Append_File(fid,'Domain_Class_B.cc');

% write the setup function
Embed = obj.Gen_Domain_Class_Setup_Data(fid);
fprintf(fid, ['', ENDL]);

% write the embedding data read function
status = obj.Gen_Domain_Class_Read_Embed_Data(fid,Embed);

% append the C part
status = Append_File(fid,'Domain_Class_C.cc');

% DONE!
fclose(fid);

end