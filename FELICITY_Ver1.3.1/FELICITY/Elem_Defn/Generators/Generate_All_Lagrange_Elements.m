function status = Generate_All_Lagrange_Elements()
%Generate_All_Lagrange_Elements
%
%   This generates several finite element reference m-files that define
%   particular Lagrange elements of varying degree on varying reference
%   domains.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% setup the output directory
PATH = fileparts(mfilename('fullpath'));
parts = strsplit(PATH, filesep);
DirPart = parts(1:end-1);
Output_Dir = strjoin(DirPart, filesep);
Output_Dir = [Output_Dir, filesep];

% output 1-D elements
Element_Domain = 'interval';
for deg_k = 0:6
    status = Generate_Lagrange_Element_File(Element_Domain,deg_k,Output_Dir);
end

% output 2-D elements
Element_Domain = 'triangle';
for deg_k = 0:6
    status = Generate_Lagrange_Element_File(Element_Domain,deg_k,Output_Dir);
end

% output 3-D elements
Element_Domain = 'tetrahedron';
for deg_k = 0:5
    status = Generate_Lagrange_Element_File(Element_Domain,deg_k,Output_Dir);
end

end