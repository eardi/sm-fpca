function status = Generate_Lagrange_Element_File(Element_Domain,Degree_k,Output_Dir)
%Generate_Lagrange_Element_File
%
%   This generates a finite element reference m-file that defines a
%   particular Lagrange element of given fixed degree on a given reference
%   domain.
%
%   The inputs are:
%       Element_Domain  = 'interval', 'triangle', 'tetrahedron', etc.
%       Degree_k        = polynomial degree of finite element.
%       Output_FileName = string specifying where to write the file.

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
    [Nodal_Basis, Nodal_Var] = Get_Lagrange_On_Simplex(Dim,Degree_k);
elseif strcmpi(Element_Domain,'triangle')
    [Nodal_Basis, Nodal_Var] = Get_Lagrange_On_Simplex(Dim,Degree_k);
elseif strcmpi(Element_Domain,'tetrahedron')
    [Nodal_Basis, Nodal_Var] = Get_Lagrange_On_Simplex(Dim,Degree_k);
else
    error('Not implemented!');
end

% setup filename
Degree_str = num2str(Degree_k);
Dim_str = num2str(Dim);
FuncName = ['lagrange_deg', Degree_str, '_dim', Dim_str];
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
write_line(['%%', TAB, 'Lagrange H^1 Finite Element of degree = ', Degree_str, ', in dimension = ', Dim_str, '.']);
write_line(['%%']);
write_line(['%%', TAB, 'Reference Domain: ', Domain_STR, '.']);
write_line(['%%']);
write_line([Domain_Fig_ASCII]);
current_date = date;
write_line(['%%', ' Copyright (c) ', current_date, ',  Shawn W. Walker']);
write_line(['']);
write_line(['%% name it!']);
write_line(['Elem.Name = mfilename;']);
write_line(['']);
if (Degree_k==0)
    write_line(['%% space must be discontinuous galerkin for piecewise constant']);
    write_line(['Elem.Type = ''DG'';']);
else
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
end
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
Transformation_Type_str = 'H1_Trans';
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
    % write Lagrange element nodal variable data string
    Nodal_Var_Data_str = ['{', Nodal_BC_str, ', ''', NV{2}, ''', ', num2str(NV{3}), '}'];
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
    % init
    Vtx1  = [];
    Vtx2  = [];
    Edge1 = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{2};
        Entity_Index = NV{3};
        if strcmpi(Type,'eval_vertex')
            if (Entity_Index==1)
                Vtx1 = [Vtx1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Vtx2 = [Vtx2; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'eval_cell')
            Edge1 = [Edge1; ind, BC_Pt];
        else
            error('Invalid!');
        end
    end
    Num_V1 = size(Vtx1,1);
    Num_V2 = size(Vtx2,1);
    Num_E1 = size(Edge1,1);
    Num_DoF = Num_V1 + Num_V2 + Num_E1;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    if (Num_V1~=Num_V2)
        error('Number of Vtx DoFs at each vertex is not the same!');
    end
    
    % setup the vertex DoFs
    if ~isempty(Vtx1)
        Vtx1 = sortrows(Vtx1,1); % sort based on DoF index
        Vtx2 = sortrows(Vtx2,1);
        DoFs_on_Vtx = [Vtx1(:,1)'; Vtx2(:,1)'];
        Nodal_Top.V = {DoFs_on_Vtx};
    else
        DoFs_on_Vtx = [];
    end
    Nodal_Top.V = {DoFs_on_Vtx};
    
    % setup the cell (edge) DoFs
    if ~isempty(Edge1)
        Edge1 = sortrows(Edge1,1); % sort based on DoF index
        DoFs_on_Edge = [Edge1(:,1)'];
    else
        DoFs_on_Edge = [];
    end
    Nodal_Top.E = {DoFs_on_Edge};
    
    % there are no other DoFs
    Nodal_Top.F = {[]};
    Nodal_Top.T = {[]};
    
elseif strcmpi(Element_Domain,'triangle')
    % init
    Vtx1  = [];
    Vtx2  = [];
    Vtx3  = [];
    Edge1 = [];
    Edge2 = [];
    Edge3 = [];
    Face1 = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{2};
        Entity_Index = NV{3};
        if strcmpi(Type,'eval_vertex')
            if (Entity_Index==1)
                Vtx1 = [Vtx1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Vtx2 = [Vtx2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Vtx3 = [Vtx3; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'eval_facet')
            if (Entity_Index==1)
                Edge1 = [Edge1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Edge2 = [Edge2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Edge3 = [Edge3; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'eval_cell')
            Face1 = [Face1; ind, BC_Pt];
        else
            error('Invalid!');
        end
    end
    Num_V1 = size(Vtx1,1);
    Num_V2 = size(Vtx2,1);
    Num_V3 = size(Vtx3,1);
    Num_E1 = size(Edge1,1);
    Num_E2 = size(Edge2,1);
    Num_E3 = size(Edge3,1);
    Num_F1 = size(Face1,1);
    Num_DoF = Num_V1 + Num_V2 + Num_V3 + Num_E1 + Num_E2 + Num_E3 + Num_F1;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_VTX_DOF = max(abs([Num_V1, Num_V2, Num_V3] - Num_V1));
    if (CHK_VTX_DOF~=0)
        error('Number of Vtx DoFs at each vertex is not the same!');
    end
    CHK_EDGE_DOF = max(abs([Num_E1, Num_E2, Num_E3] - Num_E1));
    if (CHK_EDGE_DOF~=0)
        error('Number of Edge DoFs on each edge is not the same!');
    end
    
    % setup the vertex DoFs
    if ~isempty(Vtx1)
        Vtx1 = sortrows(Vtx1,1); % sort based on DoF index
        Vtx2 = sortrows(Vtx2,1);
        Vtx3 = sortrows(Vtx3,1);
        DoFs_on_Vtx = [Vtx1(:,1)'; Vtx2(:,1)'; Vtx3(:,1)'];
    else
        DoFs_on_Vtx = [];
    end
    Nodal_Top.V = {DoFs_on_Vtx};
    
    % setup the facet (edge) DoFs
    if ~isempty(Edge1)
        Edge1 = sortrows(Edge1,1); % sort based on DoF index
        Edge2 = sortrows(Edge2,1);
        Edge3 = sortrows(Edge3,1);
        DoFs_on_Edge = [Edge1(:,1)'; Edge2(:,1)'; Edge3(:,1)'];
    else
        DoFs_on_Edge = [];
    end
    Nodal_Top.E = {DoFs_on_Edge};
    
    % setup the cell (face) DoFs
    if ~isempty(Face1)
        Face1 = sortrows(Face1,1); % sort based on DoF index
        DoFs_on_Face = [Face1(:,1)'];
    else
        DoFs_on_Face = [];
    end
    Nodal_Top.F = {DoFs_on_Face};
    
    % there are no other DoFs
    Nodal_Top.T = {[]};
    
elseif strcmpi(Element_Domain,'tetrahedron')
    % init
    Vtx1  = [];
    Vtx2  = [];
    Vtx3  = [];
    Vtx4  = [];
    Edge1 = [];
    Edge2 = [];
    Edge3 = [];
    Edge4 = [];
    Edge5 = [];
    Edge6 = [];
    Face1 = [];
    Face2 = [];
    Face3 = [];
    Face4 = [];
    Tet1  = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{2};
        Entity_Index = NV{3};
        if strcmpi(Type,'eval_vertex')
            if (Entity_Index==1)
                Vtx1 = [Vtx1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Vtx2 = [Vtx2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Vtx3 = [Vtx3; ind, BC_Pt];
            elseif (Entity_Index==4)
                Vtx4 = [Vtx4; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'eval_edge')
            if (Entity_Index==1)
                Edge1 = [Edge1; ind, BC_Pt];
            elseif (Entity_Index==2)
                Edge2 = [Edge2; ind, BC_Pt];
            elseif (Entity_Index==3)
                Edge3 = [Edge3; ind, BC_Pt];
            elseif (Entity_Index==4)
                Edge4 = [Edge4; ind, BC_Pt];
            elseif (Entity_Index==5)
                Edge5 = [Edge5; ind, BC_Pt];
            elseif (Entity_Index==6)
                Edge6 = [Edge6; ind, BC_Pt];
            else
                error('Invalid!');
            end
        elseif strcmpi(Type,'eval_facet')
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
        elseif strcmpi(Type,'eval_cell')
            Tet1 = [Tet1; ind, BC_Pt];
        else
            error('Invalid!');
        end
    end
    Num_V1 = size(Vtx1,1);
    Num_V2 = size(Vtx2,1);
    Num_V3 = size(Vtx3,1);
    Num_V4 = size(Vtx4,1);
    Num_E1 = size(Edge1,1);
    Num_E2 = size(Edge2,1);
    Num_E3 = size(Edge3,1);
    Num_E4 = size(Edge4,1);
    Num_E5 = size(Edge5,1);
    Num_E6 = size(Edge6,1);
    Num_F1 = size(Face1,1);
    Num_F2 = size(Face2,1);
    Num_F3 = size(Face3,1);
    Num_F4 = size(Face4,1);
    Num_T1 = size(Tet1,1);
    Num_DoF = Num_V1 + Num_V2 + Num_V3 + Num_V4 + ...
              Num_E1 + Num_E2 + Num_E3 + Num_E4 + Num_E5 + Num_E6 + ...
              Num_F1 + Num_F2 + Num_F3 + Num_F4 + ...
              Num_T1;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_VTX_DOF = max(abs([Num_V1, Num_V2, Num_V3, Num_V4] - Num_V1));
    if (CHK_VTX_DOF~=0)
        error('Number of Vtx DoFs at each vertex is not the same!');
    end
    CHK_EDGE_DOF = max(abs([Num_E1, Num_E2, Num_E3, Num_E4, Num_E5, Num_E6] - Num_E1));
    if (CHK_EDGE_DOF~=0)
        error('Number of Edge DoFs on each edge is not the same!');
    end
    CHK_FACE_DOF = max(abs([Num_F1, Num_F2, Num_F3, Num_F4] - Num_F1));
    if (CHK_FACE_DOF~=0)
        error('Number of Face DoFs on each face is not the same!');
    end
    
    % setup the vertex DoFs
    if ~isempty(Vtx1)
        Vtx1 = sortrows(Vtx1,1); % sort based on DoF index
        Vtx2 = sortrows(Vtx2,1);
        Vtx3 = sortrows(Vtx3,1);
        Vtx4 = sortrows(Vtx4,1);
        DoFs_on_Vtx = [Vtx1(:,1)'; Vtx2(:,1)'; Vtx3(:,1)'; Vtx4(:,1)'];
    else
        DoFs_on_Vtx = [];
    end
    Nodal_Top.V = {DoFs_on_Vtx};
    
    % setup the edge DoFs
    if ~isempty(Edge1)
        Edge1 = sortrows(Edge1,1); % sort based on DoF index
        Edge2 = sortrows(Edge2,1);
        Edge3 = sortrows(Edge3,1);
        Edge4 = sortrows(Edge4,1);
        Edge5 = sortrows(Edge5,1);
        Edge6 = sortrows(Edge6,1);
        DoFs_on_Edge = [Edge1(:,1)'; Edge2(:,1)'; Edge3(:,1)';
                        Edge4(:,1)'; Edge5(:,1)'; Edge6(:,1)'];
    else
        DoFs_on_Edge = [];
    end
    Nodal_Top.E = {DoFs_on_Edge};
    
    % setup the facet (face) DoFs
    if ~isempty(Face1)
        Face1 = sortrows(Face1,1); % sort based on DoF index
        Face2 = sortrows(Face2,1);
        Face3 = sortrows(Face3,1);
        Face4 = sortrows(Face4,1);
        DoFs_on_Face = [Face1(:,1)'; Face2(:,1)'; Face3(:,1)'; Face4(:,1)'];
    else
        DoFs_on_Face = [];
    end
    Nodal_Top.F = {DoFs_on_Face};
    
    % setup the cell (tet) DoFs
    if ~isempty(Tet1)
        Tet1 = sortrows(Tet1,1); % sort based on DoF index
        DoFs_on_Tet = [Tet1(:,1)'];
    else
        DoFs_on_Tet = [];
    end
    Nodal_Top.T = {DoFs_on_Tet};
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