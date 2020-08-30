function status = Generate_All_RaviartThomas_Elements()
%Generate_All_RaviartThomas_Elements
%
%   This generates several finite element reference m-files that define
%   particular Raviart-Thomas elements of varying degree on varying
%   reference domains.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% setup the output directory
PATH = fileparts(mfilename('fullpath'));
parts = strsplit(PATH, filesep);
DirPart = parts(1:end-1);
Output_Dir = strjoin(DirPart, filesep);
Output_Dir = [Output_Dir, filesep];

% output 2-D elements
Element_Domain = 'triangle';
for deg_k = 0:3
    status = Generate_RaviartThomas_Element_File(Element_Domain,deg_k,Output_Dir);
end

% output 3-D elements
Element_Domain = 'tetrahedron';
for deg_k = 0:3
    status = Generate_RaviartThomas_Element_File(Element_Domain,deg_k,Output_Dir);
end

end