function status = Generate_Nedelec_1stKind_Element_File(Element_Domain,Degree_k,Output_Dir,Use_Std)
%Generate_Nedelec_1stKind_Element_File
%
%   This generates a finite element reference m-file that defines a
%   particular Nedelec (1st-kind) element of given fixed degree on a given
%   reference domain.
%
%   The inputs are:
%       Element_Domain  = 'interval', 'triangle', 'tetrahedron', etc.
%       Degree_k        = polynomial degree of finite element.
%       Output_FileName = string specifying where to write the file.
%       Use_Std         = bool only used in 3-D.  Indicates the ordering of
%                         the global vertices of the tetrahedral element,
%                         which is defined by [V1, V2, V3, V4]
%                   true:  V1 < V2 < V3 < V4 (ascending order)
%                  false:  V1 < V3 < V2 < V4 (reflect mirror element).

% Copyright (c) 11-07-2016,  Shawn W. Walker

% set default
if (nargin==3)
    Use_Std = true;
end
if isempty(Use_Std)
    Use_Std = true;
end

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
    [Nodal_Basis, Nodal_Var] = Get_Nedelec_1stKind_On_Simplex(Dim,Degree_k,Use_Std);
elseif strcmpi(Element_Domain,'tetrahedron')
    [Nodal_Basis, Nodal_Var] = Get_Nedelec_1stKind_On_Simplex(Dim,Degree_k,Use_Std);
else
    error('Not implemented!');
end

% setup filename
Degree_str = num2str(Degree_k);
Dim_str = num2str(Dim);
FuncName = ['nedelec_1stkind_deg', Degree_str, '_dim', Dim_str];
if (~Use_Std)
    % save mirror image element
    FuncName = [FuncName, '_mirror_image'];
end
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
write_line(['%%', TAB, 'Nedelec (1st-kind) H(curl) Finite Element of degree = ', Degree_str, ', in dimension = ', Dim_str, '.']);
write_line(['%%']);
if strcmpi(Element_Domain,'tetrahedron')
    % only applicable in 3-D
    write_line(['%%', TAB, 'This assumes the tetrahedral element [V_1, V_2, V_3, V_4] satisfies:']);
    if Use_Std
        write_line(['%%', TAB, 'V_1 < V_2 < V_3 < V_4  (ascending order)']);
    else
        write_line(['%%', TAB, 'V_1 < V_3 < V_2 < V_4  (mirror image the ascending order case)']);
    end
    write_line(['%%', TAB, '(see below for more information.)']);
end
write_line(['%%']);
write_line(['%%', TAB, 'Reference Domain: ', Domain_STR, '.']);
write_line(['%%']);
write_string([Domain_Fig_ASCII]);
write_line(['%%']);

write_line(['%%', TAB, 'The basis functions are vector-valued (number of components = topological dimension).']);
write_line(['%%']);
write_line(['%%', TAB, 'The basis functions associated with Degrees-of-Freedom (DoFs) on an edge']);
write_line(['%%', TAB, 'have an orientation dictated by the edge''s orientation.']);
write_line(['%%', TAB, 'The orientation of an edge is defined to point from the vertex of']);
write_line(['%%', TAB, 'lower index toward the vertex of higher index.  In other words, given an']);
write_line(['%%', TAB, 'edge [V_i, V_j], where i < j, the tangent vector points from V_i toward V_j.']);
write_line(['%%']);
write_line(['%%', TAB, 'The basis functions associated with Degrees-of-Freedom (DoFs) on a facet (in 3-D)']);
write_line(['%%', TAB, 'have an orientation dictated by the tangent vectors of the facet.']);
write_line(['%%', TAB, 'In this case, we use the Paul Wesson trick.  Given a facet, we order its']);
write_line(['%%', TAB, 'vertices [V_i, V_j, V_k] so that i < j < k.  Then the tangent vectors are:']);
write_line(['%%', TAB, 'tangent_1 = V_j - V_i,  tangent_2 = V_k - V_i.']);
write_line(['%%']);
write_line(['%%', TAB, 'For simplicity, the basis functions specified in this file assume the']);
if strcmpi(Element_Domain,'triangle')
    write_line(['%%', TAB, 'global vertices of the 2-D element [V_1, V_2, V_3] are ordered as:']);
    write_line(['%%', TAB, 'V1 < V2 < V3  (ascending order)']);
    write_line(['%%']);
    write_line(['%%', TAB, 'Thus, one needs to introduce sign changes of the basis functions when mapping to']);
    write_line(['%%', TAB, 'the *actual* element in the mesh.  This is because the actual element will']);
    write_line(['%%', TAB, 'not (in general) have its vertices ordered in ascending index order.']);
    write_line(['%%', TAB, 'Note: a different ordering induces a sign change of the edge tangent vectors,']);
    write_line(['%%', TAB, 'so you only need to flip signs of associated basis functions.']);
    write_line(['%%']);
    write_line(['%%', TAB, 'FELICITY handles these sign changes automatically when assembling matrices,']);
    write_line(['%%', TAB, 'evaluating interpolations, etc.  So you do not have to "worry" about it,']);
    write_line(['%%', TAB, 'but you should *know* about it.']);
elseif strcmpi(Element_Domain,'tetrahedron')
    write_line(['%%', TAB, 'global vertices of the 3-D element [V_1, V_2, V_3, V_4] are ordered as:']);
    if Use_Std
        write_line(['%%', TAB, 'V1 < V2 < V3 < V4  (ascending order)']);
    else
        write_line(['%%', TAB, 'V1 < V3 < V2 < V4  (mirror image the ascending order case)']);
    end
    write_line(['%%']);
    write_line(['%%', TAB, 'Thus, one needs to ensure that the *actual* element vertices are ordered this']);
    write_line(['%%', TAB, 'way when mapping the basis functions.  If the actual element does not have this']);
    write_line(['%%', TAB, 'ordering, then you need to use a different set of basis functions!  For example,']);
    write_line(['%%', TAB, 'if the actual element vertices are defined as [a_i, a_j, a_k, a_l], but the']);
    write_line(['%%', TAB, 'ordering is i < k < l < j, then you must use the correct set of basis functions']);
    write_line(['%%', TAB, 'for that ordering (*not* this file!).']);
    write_line(['%%']);
    write_line(['%%', TAB, 'FELICITY stores two sets of basis functions: one for each of these orderings:']);
    write_line(['%%', TAB, 'V1 < V2 < V3 < V4  (ascending order)']);
    write_line(['%%', TAB, 'V1 < V3 < V2 < V4  (mirror image the ascending order case)']);
    write_line(['%%', TAB, 'Therefore, make sure that your 3-D triangulations contain only these orderings;']);
    write_line(['%%', TAB, 'otherwise, you get an **error** message.']);
    write_line(['%%', TAB, 'Note: there is a MeshTetrahedron method to set this ordering, with all mesh']);
    write_line(['%%', TAB, '      elements having positive volume.']);
    write_line(['%%']);
    write_line(['%%', TAB, 'FELICITY''s code generation automatically handles this, so you do not need to']);
    write_line(['%%', TAB, '"worry" about it, but you should *know* about it.']);
    write_line(['%%', TAB, 'Note: if a mesh element does not satisfy either ordering, then you will get']);
    write_line(['%%', TAB, '      an error message when you assemble matrices or evaluate interpolations.']);
else
    error('Not implemented!');
end
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
Transformation_Type_str = 'Hcurl_Trans';
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
    % generate string for (vector-valued) dual basis function
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
    
    % write Nedelec element nodal variable data string
    if strcmpi(NV{3},'int_edge')
        Nodal_Var_Data_str = ['{', Nodal_BC_str, ', ''', Dual_Basis_str, ''', ''', NV{3}, ''', ', num2str(NV{4}), '}'];
    elseif or(strcmpi(NV{3},'int_facet'),strcmpi(NV{3},'int_cell'))
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

if or(strcmpi(Element_Domain,'interval'),isempty(Nodal_Var))
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
        if strcmpi(Type,'int_edge')
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
    Num_C_1 = size(Cell_1,1);
    Num_C_2 = size(Cell_2,1);
    Num_DoF = Num_E1 + Num_E2 + Num_E3 + Num_C_1 + Num_C_2;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_EDGE_DOF = max(abs([Num_E1, Num_E2, Num_E3] - Num_E1));
    if (CHK_EDGE_DOF~=0)
        error('Number of Edge DoFs on each edge is not the same!');
    end
    if (Num_C_1~=Num_C_2)
        error('Number of Cell DoFs in each set is not the same!');
    end
    
    % there are no vertex DoFs
    Nodal_Top.V = {[]};
    
    % setup the edge DoFs
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
    Edge1 = [];
    Edge2 = [];
    Edge3 = [];
    Edge4 = [];
    Edge5 = [];
    Edge6 = [];
    Face1_1 = []; % dof_set #1
    Face2_1 = [];
    Face3_1 = [];
    Face4_1 = [];
    Face1_2 = []; % dof_set #2
    Face2_2 = [];
    Face3_2 = [];
    Face4_2 = [];
    Cell_1 = [];
    Cell_2 = [];
    Cell_3 = [];
    for ind = 1:length(Nodal_Var)
        NV = Nodal_Var(ind).Data;
        Pt = NV{1};
        BC_Pt = double(convert_to_barycentric(Pt))';
        Type = NV{3};
        Entity_Index = NV{4};
        if strcmpi(Type,'int_edge')
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
        elseif strcmpi(Type,'int_facet')
            dof_set = NV{6};
            if (dof_set==1)
                if (Entity_Index==1)
                    Face1_1 = [Face1_1; ind, BC_Pt];
                elseif (Entity_Index==2)
                    Face2_1 = [Face2_1; ind, BC_Pt];
                elseif (Entity_Index==3)
                    Face3_1 = [Face3_1; ind, BC_Pt];
                elseif (Entity_Index==4)
                    Face4_1 = [Face4_1; ind, BC_Pt];
                else
                    error('Invalid!');
                end
            elseif (dof_set==2)
                if (Entity_Index==1)
                    Face1_2 = [Face1_2; ind, BC_Pt];
                elseif (Entity_Index==2)
                    Face2_2 = [Face2_2; ind, BC_Pt];
                elseif (Entity_Index==3)
                    Face3_2 = [Face3_2; ind, BC_Pt];
                elseif (Entity_Index==4)
                    Face4_2 = [Face4_2; ind, BC_Pt];
                else
                    error('Invalid!');
                end
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
    Num_E1 = size(Edge1,1);
    Num_E2 = size(Edge2,1);
    Num_E3 = size(Edge3,1);
    Num_E4 = size(Edge4,1);
    Num_E5 = size(Edge5,1);
    Num_E6 = size(Edge6,1);
    Num_F1_1 = size(Face1_1,1);
    Num_F2_1 = size(Face2_1,1);
    Num_F3_1 = size(Face3_1,1);
    Num_F4_1 = size(Face4_1,1);
    Num_F1_2 = size(Face1_2,1);
    Num_F2_2 = size(Face2_2,1);
    Num_F3_2 = size(Face3_2,1);
    Num_F4_2 = size(Face4_2,1);
    Num_C_1 = size(Cell_1,1);
    Num_C_2 = size(Cell_2,1);
    Num_C_3 = size(Cell_3,1);
    Num_DoF = Num_E1 + Num_E2 + Num_E3 + Num_E4 + Num_E5 + Num_E6 +...
              Num_F1_1 + Num_F2_1 + Num_F3_1 + Num_F4_1 + ...
              Num_F1_2 + Num_F2_2 + Num_F3_2 + Num_F4_2 + ...
              Num_C_1 + Num_C_2 + Num_C_3;
    if (Num_DoF~=length(Nodal_Var))
        error('Number of DoFs is incorrect!');
    end
    CHK_EDGE_DOF = max(abs([Num_E1, Num_E2, Num_E3, Num_E4, Num_E5, Num_E6] - Num_E1));
    if (CHK_EDGE_DOF~=0)
        error('Number of Edge DoFs on each edge is not the same!');
    end
    CHK_FACE_DOF_1 = max(abs([Num_F1_1, Num_F2_1, Num_F3_1, Num_F4_1] - Num_F1_1));
    CHK_FACE_DOF_2 = max(abs([Num_F1_2, Num_F2_2, Num_F3_2, Num_F4_2] - Num_F1_2));
    if or(CHK_FACE_DOF_1~=0,CHK_FACE_DOF_2~=0)
        error('Number of Face DoFs on each face is not the same!');
    end
    CHK_CELL_DOF = max(abs([Num_C_1, Num_C_2, Num_C_3] - Num_C_1));
    if (CHK_CELL_DOF~=0)
        error('Number of Cell DoFs in each set is not the same!');
    end
    
    % there are no vertex DoFs
    Nodal_Top.V = {[]};
    
    % setup the edge DoFs
    Edge1 = sortrows(Edge1,1); % sort based on DoF index
    Edge2 = sortrows(Edge2,1);
    Edge3 = sortrows(Edge3,1);
    Edge4 = sortrows(Edge4,1);
    Edge5 = sortrows(Edge5,1);
    Edge6 = sortrows(Edge6,1);
    DoFs_on_Edge = [Edge1(:,1)'; Edge2(:,1)'; Edge3(:,1)';
                    Edge4(:,1)'; Edge5(:,1)'; Edge6(:,1)'];
    Nodal_Top.E = {DoFs_on_Edge};
    
    % setup the facet (face) DoFs
    if ~isempty(Face1_1)
        Face1_1 = sortrows(Face1_1,1); % sort based on DoF index
        Face2_1 = sortrows(Face2_1,1);
        Face3_1 = sortrows(Face3_1,1);
        Face4_1 = sortrows(Face4_1,1);
        DoFs_on_Face_1 = [Face1_1(:,1)'; Face2_1(:,1)'; Face3_1(:,1)'; Face4_1(:,1)'];
        Face1_2 = sortrows(Face1_2,1); % sort based on DoF index
        Face2_2 = sortrows(Face2_2,1);
        Face3_2 = sortrows(Face3_2,1);
        Face4_2 = sortrows(Face4_2,1);
        DoFs_on_Face_2 = [Face1_2(:,1)'; Face2_2(:,1)'; Face3_2(:,1)'; Face4_2(:,1)'];
        % there are 2 sets of DoFs
        % (one for each tangent vector in tangent space of facet)
        Nodal_Top.F = {DoFs_on_Face_1, DoFs_on_Face_2};
    else
        Nodal_Top.F = {[]};
    end
    
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