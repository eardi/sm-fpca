function status = Check_Element_Definition(Elem)
%Check_Element_Definition
%
%   This checks that the element struct is fully (and correctly) defined.
%
%   status = Check_Element_Definition(Elem);
%
%   Elem   = element definition struct obtained by calling one of the files
%            in the ./FELICITY/Elem_Defn directory.
%
%   status = 0, if routine completes successfully.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if (length(Elem)~=1)
    disp('Elem must be a SINGLE element!');
    status = -1;
    return;
end

if ~ischar(Elem.Name)
    error('Elem.Name must be a string.');
end
if ~or(or(strcmp(Elem.Type,'CG'),strcmp(Elem.Type,'DG')),strcmp(Elem.Type,'constant_one'))
    error('Only Continuous-Galerkin and Discontinuous-Galerkin is implemented!');
end

if strcmp(Elem.Type,'constant_one')
    % nothing needs to be checked!
    status = 0; % all good
    return;
end

Dim = Elem.Dim;
if Dim==1
    %Vtx_Pos = [0;1];
    if ~strcmp(Elem.Domain,'interval')
        error('A 1-D domain must be an interval.');
    end
elseif Dim==2
    %Vtx_Pos = [0,0;1,0;0,1];
    if ~strcmp(Elem.Domain,'triangle')
        error('A 2-D domain must be a triangle.');
    end
elseif Dim==3
    %Vtx_Pos = [0,0,0;1,0,0;0,1,0;0,0,1];
    if ~strcmp(Elem.Domain,'tetrahedron')
        error('A 3-D domain must be a tetrahedron.');
    end
else
    error('Only dimensions 1, 2, and 3 are implemented.');
end

Num_Basis         = length(Elem.Basis);
Dim_of_Basis_Func = size(Elem.Basis(1).Func);
% if (Dim_of_Basis_Func(2)~=1)
%     error('Basis functions can only be column vectors (will improve later).');
% end
Num_Rows = Dim_of_Basis_Func(1);
Num_Cols = Dim_of_Basis_Func(2);
Num_Nodal_Basis = length(Elem.Nodal_Var);
if (Num_Basis~=Num_Nodal_Basis)
    error('Number of the basis functions and nodal variables must be the same!');
end

NODES = [];
nnt = length(Elem.Nodal_Top);
for i1 = 1:nnt
    for i2 = 1:length(Elem.Nodal_Top(i1).V)
        NODES = [NODES; Elem.Nodal_Top(i1).V{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).E)
        NODES = [NODES; Elem.Nodal_Top(i1).E{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).F)
        NODES = [NODES; Elem.Nodal_Top(i1).F{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).T)
        NODES = [NODES; Elem.Nodal_Top(i1).T{i2}(:)];
    end
end

num_nodes = length(NODES);
UN = unique(NODES);
num_unique_nodes = length(UN);

if (num_nodes~=num_unique_nodes)
    error('Nodal Topology arrangment contains duplicated nodes.');
end

status = 0;

end