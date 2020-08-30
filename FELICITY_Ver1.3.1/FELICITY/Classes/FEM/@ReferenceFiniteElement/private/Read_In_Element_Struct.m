function obj = Read_In_Element_Struct(obj,Elem)
%Read_In_Element_Struct
%
%   This converts the Elem struct to something that the class/object can
%   use.

% Copyright (c) 07-01-2019,  Shawn W. Walker

% this is a simple element!
if strcmp(Elem.Type,'constant_one')
    obj.Top_Dim      = 0;
    obj.Simplex_Type = [];
    obj.Simplex_Vtx  = [];
    obj.Element_Type = Elem.Type;
    obj.Element_Name = Elem.Name;
    obj.Element_Degree = 0;
    obj.Basis_Size = [1, 1];
    obj.Num_Basis = 1;
    if obj.USE_SYM
        obj.Basis(1).phi = sym('1'); % need symbolic computing toolbox
    else
        obj.Basis(1).phi = '1'; % don't try to do any symbolic computing!
    end
    obj.Transformation = 'Constant_Trans';
    obj.Nodal_Data.BC_Coord     = [];
    obj.Nodal_Data.Dual_Func    = [];
    obj.Nodal_Data.Type         = [];
    obj.Nodal_Data.Entity_Index = [];
    obj.Nodal_Data.DoF_Set      = [];
    obj.Nodal_Top.V = {[]};
    obj.Nodal_Top.E = {[]};
    obj.Nodal_Top.F = {[]};
    obj.Nodal_Top.T = {[]};
    return;
end

obj.Top_Dim = Elem.Dim;
obj.Simplex_Type = Elem.Domain;
if strcmp(obj.Simplex_Type,'interval')
    obj.Simplex_Vtx = [0; 1];
elseif strcmp(obj.Simplex_Type,'triangle')
    obj.Simplex_Vtx = [0, 0; 1, 0; 0, 1];
elseif strcmp(obj.Simplex_Type,'tetrahedron')
    obj.Simplex_Vtx = [0, 0, 0; 1, 0, 0; 0, 1, 0; 0, 0, 1];
else
    error(['ERROR: The domain type ''', obj.Simplex_Type, ''' is invalid!']);
end

obj.Element_Type   = Elem.Type;
obj.Element_Name   = Elem.Name;
obj.Element_Degree = Elem.Degree;

obj.Num_Basis      = length(Elem.Basis);

% init nodal data
obj.Nodal_Data.BC_Coord     = zeros(obj.Num_Basis,obj.Top_Dim+1);
obj.Nodal_Data.Dual(obj.Num_Basis).Func = [];
obj.Nodal_Data.Type         = cell(obj.Num_Basis,1);
obj.Nodal_Data.Entity_Index = zeros(obj.Num_Basis,1);
obj.Nodal_Data.DoF_Set      = zeros(obj.Num_Basis,1);

% get argument string
if (obj.Top_Dim==1)
    arg_str = '@(x) ';
elseif (obj.Top_Dim==2)
    arg_str = '@(x,y) ';
elseif (obj.Top_Dim==3)
    arg_str = '@(x,y,z) ';
else
    error('Invalid!');
end

% convert basis info
[~, obj.Basis_Size] = create_func_handle(arg_str,Elem.Basis(1).Func);
for ind = 1:obj.Num_Basis
    % basis function
    [func_handle, basis_size] = create_func_handle(arg_str,Elem.Basis(ind).Func);
    if obj.USE_SYM
        obj.Basis(ind).phi = sym(func_handle); % need symbolic computing toolbox
    else
        obj.Basis(ind).phi = func_handle; % don't try to do any symbolic computing!
    end
    
    DIM_CHK = max( abs(basis_size - obj.Basis_Size) );
    if DIM_CHK > 0
        error('All basis functions (in a set) must have the same component dimensions!');
    end
    % barycentric coordinates
    obj.Nodal_Data.BC_Coord(ind,:) = Elem.Nodal_Var(ind).Data{1};
end

% convert nodal variable data
Len_NV = length(Elem.Nodal_Var(1).Data);
if (Len_NV==3)
    % must be Lagrange element
    for ind = 1:obj.Num_Basis
        obj.Nodal_Data.Dual(ind).Func    = []; % NULL
        obj.Nodal_Data.Type{ind}         = Elem.Nodal_Var(ind).Data{2};
        obj.Nodal_Data.Entity_Index(ind) = Elem.Nodal_Var(ind).Data{3};
    end
    obj.Nodal_Data.DoF_Set(:) = 1; % default (not used here)
else
    % H(div) or H(curl)
    for ind = 1:obj.Num_Basis
        dual_func_handle_str = [arg_str, Elem.Nodal_Var(ind).Data{2}];
        dual_func_handle     = str2func(dual_func_handle_str);
        obj.Nodal_Data.Dual(ind).Func    = sym(dual_func_handle); % NULL
        obj.Nodal_Data.Type{ind}         = Elem.Nodal_Var(ind).Data{3};
        obj.Nodal_Data.Entity_Index(ind) = Elem.Nodal_Var(ind).Data{4};
    end
    if (Len_NV==6)
        for ind = 1:obj.Num_Basis
            obj.Nodal_Data.DoF_Set(ind) = Elem.Nodal_Var(ind).Data{6};
        end
    else
        obj.Nodal_Data.DoF_Set(:) = 1; % default (not used here)
    end
end

% final stuff
obj.Transformation = Elem.Transformation;

% topological arrangment
obj.Nodal_Top = Elem.Nodal_Top;

end

function [fh, mat_size] = create_func_handle(arg_str,func_cell_str)

% get the dimensions of the function
[nr, nc] = size(func_cell_str);
mat_size = [nr, nc];

% create valid function string
fs = '[';
for rr = 1:nr
for cc = 1:nc-1
    fs = [fs, func_cell_str{rr,cc}, ','];
end
if (rr < nr)
    fs = [fs, func_cell_str{rr,nc}, '; '];
else
    fs = [fs, func_cell_str{rr,nc}, ']'];
end
end

% convert to a function handle
func_str = [arg_str, fs];
fh       = str2func(func_str);

end