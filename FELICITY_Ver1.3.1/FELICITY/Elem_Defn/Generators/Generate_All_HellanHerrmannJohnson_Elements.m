function status = Generate_All_HellanHerrmannJohnson_Elements()
%Generate_All_HellanHerrmannJohnson_Elements
%
%   This generates several finite element reference m-files that define
%   particular Hellan-Herrmann-Johnson elements of varying degree on
%   varying reference domains.

% Copyright (c) 03-28-2018,  Shawn W. Walker

% setup the output directory
PATH = fileparts(mfilename('fullpath'));
parts = strsplit(PATH, filesep);
DirPart = parts(1:end-1);
Output_Dir = strjoin(DirPart, filesep);
Output_Dir = [Output_Dir, filesep];

% output 2-D elements
Element_Domain = 'triangle';
for deg_k = 0:4
    status = Generate_HellanHerrmannJohnson_Element_File(Element_Domain,deg_k,Output_Dir);
end

% output 3-D elements
Element_Domain = 'tetrahedron';
for deg_k = 0:-1
    error('Not implemented!');
    status = Generate_HellanHerrmannJohnson_Element_File(Element_Domain,deg_k,Output_Dir);
end

end