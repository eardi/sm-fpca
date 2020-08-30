function status = Generate_All_Nedelec_1stKind_Elements()
%Generate_All_Nedelec_1stKind_Elements
%
%   This generates several finite element reference m-files that define
%   particular Nedelec (1st-kind) elements of varying degree on varying
%   reference domains.

% Copyright (c) 11-11-2016,  Shawn W. Walker

% setup the output directory
PATH = fileparts(mfilename('fullpath'));
parts = strsplit(PATH, filesep);
DirPart = parts(1:end-1);
Output_Dir = strjoin(DirPart, filesep);
Output_Dir = [Output_Dir, filesep];

% output 2-D elements
Element_Domain = 'triangle';
for deg_k = 1:3
    status = Generate_Nedelec_1stKind_Element_File(Element_Domain,deg_k,Output_Dir,[]);
end

% output 3-D elements (std ordering)
Element_Domain = 'tetrahedron';
for deg_k = 1:3
    status = Generate_Nedelec_1stKind_Element_File(Element_Domain,deg_k,Output_Dir,true);
end
% output 3-D elements (swap V_2, V_3)
Element_Domain = 'tetrahedron';
for deg_k = 1:3
    status = Generate_Nedelec_1stKind_Element_File(Element_Domain,deg_k,Output_Dir,false);
end

end