function Specific = Get_Specific_Matrix_Data(obj,FS,Matrix_Name)
%Get_Specific_Matrix_Data
%
%   This returns an array of structs that contain all the information you need
%   for generating the specific FE matrix class.

% Copyright (c) 06-14-2016,  Shawn W. Walker

Row_Space = obj.Matrix(Matrix_Name).Row_Space_Name;
Col_Space = obj.Matrix(Matrix_Name).Col_Space_Name;

Matrix_Integration_Indices = obj.Get_Integration_Indices_For_Matrix(Matrix_Name);
Num = length(Matrix_Integration_Indices);
Specific(Num).MAT     = [];
Specific(Num).RowFunc = [];
Specific(Num).ColFunc = [];
Specific(Num).GeoFunc = []; % for Domain of Integration
% Specific(Num).Coef    = [];

for ind = 1:Num
    Specific(ind).MAT = obj.Integration(Matrix_Integration_Indices(ind)).Matrix(Matrix_Name);
    DoI = obj.Integration(Matrix_Integration_Indices(ind)).Domain.Integration_Domain;
    Specific(ind).RowFunc = FS.Find_Basis_Function_On_Domain(Row_Space,DoI);
    Specific(ind).ColFunc = FS.Find_Basis_Function_On_Domain(Col_Space,DoI);
    % get the geom func that describes the domain of integration geometry
    Specific(ind).GeoFunc = FS.Find_Geometric_Function_On_Domain(DoI);
    
%     % get any coefficient functions that are needed
%     Specific(ind).Coef = [];
end

end