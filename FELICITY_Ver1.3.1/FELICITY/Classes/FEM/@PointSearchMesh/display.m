function display(obj)

% get number of finite element spaces
Num_Point_Search = length(obj);

for oi=1:Num_Point_Search

disp('------------------------------------------');
disp(['PointSearchMesh(',num2str(oi),')']);
disp(' ');

disp(['   Search_Handle: function handle to point search definition file      =  ''', func2str(obj(oi).Search_Handle), '''']);
disp(['     Search_Args: cell array of input arguments to ''Search_Handle''']);
disp(['Pt_Search_Struct: output from running "Defn":                   ','']);
obj(oi).Pt_Search_Struct;
disp(['       Mesh_Info: Struct With Mesh Info For Point Searching:    ','']);
disp(obj(oi).Mesh_Info);
disp(['           Trees: container map of search trees for point searching:    ','']);
disp(obj(oi).Trees);
disp(['         mex_Dir: directory containing mex file (and generated code):    ','']);
disp(obj(oi).mex_Dir);
disp([' mex_Search_Func: function handle to mex file for point searching the mesh:    ','']);
disp(obj(oi).mex_Search_Func);

disp('------------------------------------------');
disp(' ');

end

end