function status = Generate_RaviartThomas_Element_File(Element_Domain,Degree_k,Output_Dir)
%Generate_RaviartThomas_Element_File
%
%   This generates a finite element reference m-file that defines a
%   particular Raviart-Thomas element of given fixed degree on a given
%   reference domain.
%
%   The inputs are:
%       Element_Domain  = 'interval', 'triangle', 'tetrahedron', etc.
%       Degree_k        = polynomial degree of finite element.
%       Output_Dir      = string specifying where to write the file.

% Copyright (c) 10-10-2016,  Shawn W. Walker

% get basic info text
[Element_Domain, Domain_STR, Domain_Fig_ASCII, Dim] = setup_generic_element_file_text(Element_Domain);

ENDL = '\n';
TAB = '    ';
%TAB2 = [TAB, TAB];
%TAB3 = [TAB2, TAB];
%TAB4 = [TAB3, TAB];

% get the (reference) finite element space
if strcmpi(Element_Domain,'interval')
    error('Invalid domain!');
elseif strcmpi(Element_Domain,'triangle')
    [Nodal_Basis, Nodal_Var] = Get_RaviartThomas_On_Simplex(Dim,Degree_k);
elseif strcmpi(Element_Domain,'tetrahedron')
    [Nodal_Basis, Nodal_Var] = Get_RaviartThomas_On_Simplex(Dim,Degree_k);
else
    error('Not implemented!');
end

% setup filename
Degree_str = num2str(Degree_k);
Dim_str = num2str(Dim);
FuncName = ['raviart_thomas_deg', Degree_str, '_dim', Dim_str];
Output_FileName = fullfile(Output_Dir, [FuncName, '.m']);

% open file for writing
fid = fopen(Output_FileName, 'w');

% define write line function
write_line = @(STR) fprintf(fid, [STR, ENDL]);
write_string = @(STR) fprintf(fid, STR);

% write header
write_line(['', 'function Elem = ', FuncName, '(Type_STR)']);
write_line(['%%', FuncName]);
write_line(['%%']);
write_line(['%%', TAB, 'This defines a reference finite element to be used by FELICITY.']);
write_line(['%%', TAB, 'INPUT: string = ''CG''/''DG'' (continuous/DIScontinuous galerkin).']);
write_line(['%%']);
write_line(['%%', TAB, 'Raviart-Thomas H(div) Finite Element of degree = ', Degree_str, ', in dimension = ', Dim_str, '.']);
write_line(['%%']);
write_line(['%%', TAB, 'Reference Domain: ', Domain_STR, '.']);
write_line(['%%']);
write_string([Domain_Fig_ASCII]);
write_line(['%%']);

write_line(['%%', TAB, 'The basis functions are vector-valued (number of components = topological dimension).']);
write_line(['%%']);
write_line(['%%', TAB, 'The basis functions associated with Degrees-of-Freedom (DoFs) on a facet']);
write_line(['%%', TAB, 'have an orientation dictated by the facet''s orientation.']);
write_line(['%%']);
write_line(['%%', TAB, 'For simplicity, the basis functions specified in this file assume a']);
write_line(['%%', TAB, 'fixed orientation on the reference element, which is that all facets']);
write_line(['%%', TAB, 'are oriented with the normal vector pointing *OUT* of the reference']);
write_line(['%%', TAB, 'element.']);
write_line(['%%']);
write_line(['%%', TAB, 'Thus, one needs to introduce appropriate +/- sign changes when mapping']);
write_line(['%%', TAB, 'these basis functions to the *actual* element in the mesh.  This is']);
write_line(['%%', TAB, 'handled by the "guts" of FELICITY to auto-generate code to take care of']);
write_line(['%%', TAB, 'these sign changes (e.g. when assembling matrices, interpolation, etc.).']);
write_line(['%%', TAB, 'Note: only sign changes are made; there is no permuting of DoFs.']);
%   This is **not** the case with H(curl) elements!
write_line(['']);

current_date = date;
write_line(['%%', ' Copyright (c) ', current_date, ',  Shawn W. Walker']);
write_line(['']);
write_line(['%% name it!']);
write_line(['Elem.Name = mfilename;']);
write_line(['']);
write_line(['%% determine continuous or discontinuous galerkin space']);
write_line(['if (nargin==0)']);
write_line([TAB, 'Type_STR = ''CG''; %% default']);
write_line(['end']);
write_line(['if strcmpi(Type_STR,''cg'')']);
write_line([TAB, 'Elem.Type = ''CG'';']);
write_line(['elseif strcmpi(Type_STR,''dg'')']);
write_line([TAB, 'Elem.Type = ''DG'';']);
write_line(['else']);
write_line([TAB, 'error(''Invalid input type!  Must be ''''CG'''' or ''''DG''''.'');']);
write_line(['end']);
write_line(['']);
write_line(['%% topological dimension and domain']);
write_line(['Elem.Dim = ', Dim_str, ';']);
write_line(['Elem.Domain = ''', Element_Domain, ''';']);
write_line(['']);

write_line(['%% nodal basis function definitions (in the order of their local Degree-of-Freedom index)']);
Num_Basis = length(Nodal_Basis);
write_line(['Elem.Basis(', num2str(Num_Basis), ').Func = []; %% init']);
% loop through nodal basis
for ii = 1:length(Nodal_Basis)
    BF = Nodal_Basis(ii).Func;
    Basis_Func_Str = write_element_file_basis_func_string(BF);
    write_line(['Elem.Basis(', num2str(ii), ').Func = {', Basis_Func_Str, '};']);
end
write_line(['%% local mapping transformation to use']);
Transformation_Type_str = 'Hdiv_Trans';
write_line(['Elem.Transformation = ''', Transformation_Type_str, ''';']);
write_line(['Elem.Degree = ', Degree_str, ';']);
write_line(['']);

write_line(['%% nodal variable data (in the order of their local Degree-of-Freedom index)']);
write_line(['%% (the nodal point is given in barycentric coordinates)']);
Num_Nodal_Var = length(Nodal_Var);
write_line(['Elem.Nodal_Var(', num2str(Num_Nodal_Var), ').Data = []; %% init']);
% loop through nodal variables
for ii = 1:length(Nodal_Var)
    NV = Nodal_Var(ii).Data;
    Nodal_BC_str = write_element_file_barycentric_string(NV{1});
    % write Raviart-Thomas element nodal variable data string
    if strcmpi(NV{3},'int_facet')
        Dual_Basis_str = ['[', char(NV{2}), ']'];
        Nodal_Var_Data_str = ['{', Nodal_BC_str, ', ''', Dual_Basis_str, ''', ''', NV{3}, ''', ', num2str(NV{4}), '}'];
    elseif strcmpi(NV{3},'int_cell')
        % generate string for dual basis function
        BF = NV{2};
        if (Dim==2)
            DB_1 = char(BF(1));
            DB_2 = char(BF(2));
            Dual_Basis_str = ['[', DB_1, '; ', DB_2, ']'];
        elseif (Dim==3)
            DB_1 = char(BF(1));
            DB_2 = char(BF(2));
            DB_3 = char(BF(3));
            Dual_Basis_str = ['[', DB_1, '; ', DB_2, '; ', DB_3, ']'];
        elseif (Dim==1)
            error('Invalid!');
        else
            error('Not implemented!');
        end
        Nodal_Var_Data_str = ['{', Nodal_BC_str, ', ''', Dual_Basis_str, ''', ''', NV{3}, ''', ',...
                                   num2str(NV{4}), ', ''', NV{5}, ''', ', num2str(NV{6}), '}'];
    else
        error('Invalid!');
    end
    write_line(['Elem.Nodal_Var(', num2str(ii), ').Data = ', Nodal_Var_Data_str, ';']);
end
write_line(['']);

write_line(['%%%%%%%%%% topological arrangement of nodal points %%%%%%%%%%']);
write_line(['%% note: multiple sets of nodal variables can be associated with each topological entity.']);
write_line(['%%       This is done by defining multiple matrix arrays within each matlab cell.']);
write_line(['%%       See the FELICITY manual for more info.']);
write_line(['']);

Nodal_Top = get_nodal_top_arrangement(Element_Domain,Nodal_Var);
DoF_TAB = '                   ';

write_line(['%% nodes attached to vertices']);
if ~isempty(Nodal_Top.V{1})
    write_line(['Elem.Nodal_Top.V = {...']);
    Nodal_Sets_str = write_element_file_nodal_top_string(Nodal_Top.V,DoF_TAB);
    write_line(Nodal_Sets_str);
    write_line([DoF_TAB, '};']);
    write_line(['%%']);
else
    write_line(['Elem.Nodal_Top.V = {[]};']);
end
write_line(['']);

write_line(['%% nodes attached to edges']);
if ~isempty(Nodal_Top.E{1})
    write_line(['Elem.Nodal_Top.E = {...']);
    Nodal_Sets_str = write_element_file_nodal_top_string(Nodal_Top.E,DoF_TAB);
    write_line(Nodal_Sets_str);
    write_line([DoF_TAB, '};']);
    write_line(['%%']);
else
    write_line(['Elem.Nodal_Top.E = {[]};']);
end
write_line(['']);

write_line(['%% nodes attached to triangles (faces)']);
if ~isempty(Nodal_Top.F{1})
    write_line(['Elem.Nodal_Top.F = {...']);
    Nodal_Sets_str = write_element_file_nodal_top_string(Nodal_Top.F,DoF_TAB);
    write_line(Nodal_Sets_str);
    write_line([DoF_TAB, '};']);
    write_line(['%%']);
else
    write_line(['Elem.Nodal_Top.F = {[]};']);
end
write_line(['']);

write_line(['%% nodes attached to tetrahedra (cells)']);
if ~isempty(Nodal_Top.T{1})
    write_line(['Elem.Nodal_Top.T = {...']);
    Nodal_Sets_str = write_element_file_nodal_top_string(Nodal_Top.T,DoF_TAB);
    write_line(Nodal_Sets_str);
    write_line([DoF_TAB, '};']);
    write_line(['%%']);
else
    write_line(['Elem.Nodal_Top.T = {[]};']);
end
write_line(['']);

write_string(['end']);

% DONE!
status = fclose(fid);

end

function Nodal_Top = get_nodal_top_arrangement(Element_Domain,Nodal_Var)
%
%   This arranges the nodal variables (i.e. the nodal points) on their
%   corresponding topological entities.

if strcmpi(Element_Domain,'interval')
    % this is invalid!
    Nodal_Top.V = {[]};
    Nodal_Top.E = {[]};
    Nodal_Top.F = {[]};
    Nodal_Top.T = {[]};
    
elseif strcmpi(Element_Domain,'triangle')
    % init
    Edge1 = [];
    Edge2 = [];
    Edge3 = [];
    Cell_1 = [];
    Cell_2 = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{3};
        Entity_Index = NV{4};
        if strcmpi(Type,'int_facet')
            if (Entity_Index==1)
                Edge1 = [Edge1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Edge2 = [Edge2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Edge3 = [Edge3; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'int_cell')
            dof_set = NV{6};
            if (dof_set==1)
                Cell_1 = [Cell_1; ind, BC_Pt];
            elseif (dof_set==2)
                Cell_2 = [Cell_2; ind, BC_Pt];
            else
                error('Invalid!');
            end
        else
            error('Invalid!');
        end
    end
    Num_E1 = size(Edge1,1);
    Num_E2 = size(Edge2,1);
    Num_E3 = size(Edge3,1);
    Num_C1 = size(Cell_1,1);
    Num_C2 = size(Cell_2,1);
    Num_DoF = Num_E1 + Num_E2 + Num_E3 + Num_C1 + Num_C2;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_EDGE_DOF = max(abs([Num_E1, Num_E2, Num_E3] - Num_E1));
    if (CHK_EDGE_DOF~=0)
        error('Number of Edge DoFs on each edge is not the same!');
    end
    if (Num_C1~=Num_C2)
        error('Number of Cell DoFs in each set is not the same!');
    end
    
    % there are no vertex DoFs
    Nodal_Top.V = {[]};
    
    % setup the facet (edge) DoFs
    Edge1 = sortrows(Edge1,1); % sort based on DoF index
    Edge2 = sortrows(Edge2,1);
    Edge3 = sortrows(Edge3,1);
    DoFs_on_Edge = [Edge1(:,1)'; Edge2(:,1)'; Edge3(:,1)'];
    Nodal_Top.E = {DoFs_on_Edge};
    
    % setup the cell (face) DoFs
    if ~isempty(Cell_1)
        Cell_1 = sortrows(Cell_1,1); % sort based on DoF index
        Cell_2 = sortrows(Cell_2,1);
        DoFs_on_Face_1 = [Cell_1(:,1)'];
        DoFs_on_Face_2 = [Cell_2(:,1)'];
        % there are 2 sets of DoFs (one for each vector component)
        Nodal_Top.F = {DoFs_on_Face_1, DoFs_on_Face_2};
    else
        Nodal_Top.F = {[]};
    end
    
    % there are no other DoFs
    Nodal_Top.T = {[]};
    
elseif strcmpi(Element_Domain,'tetrahedron')
    % init
    Face1 = [];
    Face2 = [];
    Face3 = [];
    Face4 = [];
    Cell_1 = [];
    Cell_2 = [];
    Cell_3 = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{3};
        Entity_Index = NV{4};
        if strcmpi(Type,'int_facet')
            if (Entity_Index==1)
                Face1 = [Face1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Face2 = [Face2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Face3 = [Face3; ind, BC_Pt];
            elseif (Entity_Index==4)
                Face4 = [Face4; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'int_cell')
            dof_set = NV{6};
            if (dof_set==1)
                Cell_1 = [Cell_1; ind, BC_Pt];
            elseif (dof_set==2)
                Cell_2 = [Cell_2; ind, BC_Pt];
            elseif (dof_set==3)
                Cell_3 = [Cell_3; ind, BC_Pt];
            else
                error('Invalid!');
            end
        else
            error('Invalid!');
        end
    end
    Num_F1 = size(Face1,1);
    Num_F2 = size(Face2,1);
    Num_F3 = size(Face3,1);
    Num_F4 = size(Face4,1);
    Num_C1 = size(Cell_1,1);
    Num_C2 = size(Cell_2,1);
    Num_C3 = size(Cell_3,1);
    Num_DoF = Num_F1 + Num_F2 + Num_F3 + Num_F4 + ...
              Num_C1 + Num_C2 + Num_C3;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_FACE_DOF = max(abs([Num_F1, Num_F2, Num_F3, Num_F4] - Num_F1));
    if (CHK_FACE_DOF~=0)
        error('Number of Face DoFs on each face is not the same!');
    end
    CHK_CELL_DOF = max(abs([Num_C1, Num_C2, Num_C3] - Num_C1));
    if (CHK_CELL_DOF~=0)
        error('Number of Cell DoFs in each set is not the same!');
    end
    
    % there are no vertex DoFs
    Nodal_Top.V = {[]};
    
    % there are no edge DoFs
    Nodal_Top.E = {[]};
    
    % setup the facet (face) DoFs
    Face1 = sortrows(Face1,1); % sort based on DoF index
    Face2 = sortrows(Face2,1);
    Face3 = sortrows(Face3,1);
    Face4 = sortrows(Face4,1);
    DoFs_on_Face = [Face1(:,1)'; Face2(:,1)'; Face3(:,1)'; Face4(:,1)'];
    Nodal_Top.F = {DoFs_on_Face};
    
    % setup the cell (tet) DoFs
    if ~isempty(Cell_1)
        Cell_1 = sortrows(Cell_1,1); % sort based on DoF index
        Cell_2 = sortrows(Cell_2,1);
        Cell_3 = sortrows(Cell_3,1);
        DoFs_on_Cell_1 = [Cell_1(:,1)'];
        DoFs_on_Cell_2 = [Cell_2(:,1)'];
        DoFs_on_Cell_3 = [Cell_3(:,1)'];
        % there are 3 sets of DoFs (one for each vector component)
        Nodal_Top.T = {DoFs_on_Cell_1, DoFs_on_Cell_2, DoFs_on_Cell_3};
    else
        Nodal_Top.T = {[]};
    end
else
    error('Not implemented!');
end

Vtx_DoFs = [];
for ii = 1:length(Nodal_Top.V)
    Vtx_DoFs = [Vtx_DoFs; Nodal_Top.V{ii}(:)];
end
Edge_DoFs = [];
for ii = 1:length(Nodal_Top.E)
    Edge_DoFs = [Edge_DoFs; Nodal_Top.E{ii}(:)];
end
Face_DoFs = [];
for ii = 1:length(Nodal_Top.F)
    Face_DoFs = [Face_DoFs; Nodal_Top.F{ii}(:)];
end
Tet_DoFs = [];
for ii = 1:length(Nodal_Top.T)
    Tet_DoFs = [Tet_DoFs; Nodal_Top.T{ii}(:)];
end

All_DoFs = [Vtx_DoFs; Edge_DoFs; Face_DoFs; Tet_DoFs];

% final check
Unique_DoFs = unique(All_DoFs);
if (length(All_DoFs)~=length(Unique_DoFs))
    error('Not all DoF indices are distinct!');
end

end