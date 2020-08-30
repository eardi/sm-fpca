function Sign_Change = Premap_Basis_in_2D(Mesh_Orient,All_Edge_DoFs,Num_Basis)
%Premap_Basis_in_2D
%
%   This is used by the H(curl) elements for pre-mapping basis functions to
%   adjust for different edge orientations.
%
%   Sign_Change = Premap_Basis_in_2D(Mesh_Orient,All_Facet_DoFs,Num_Basis);
%
%   Mesh_Orient: NxE vector indicating actual orientation of mesh elements
%               (N is the number of elements; E is the number of element
%                edges.)
%         Example:  [+1, -1, +1; ...] (E = 3)
%                  Elem #1:  edge 1 and edge 3 are positively oriented;
%                            edge 2 is negative, etc...
%   All_Edge_DoFs: cell array of sets of DoFs attached to all edges.
%   Num_Basis: number of basis functions in the element.
%
%   Sign_Change: NxB matrix, where B = number of basis functions:
%                +1 = no sign change.
%                -1 = flip sign of corresponding basis function.
%                Rows correspond to rows of "Mesh_Orient".

% Copyright (c) 10-18-2016,  Shawn W. Walker

Num_Elem  = size(Mesh_Orient,1);
Num_Edges = size(Mesh_Orient,2);

Sign_Change = ones(Num_Elem,Num_Basis); % init

% loop through the local edges of the mesh elements
for ei = 1:Num_Edges
    Edge_Sign = Mesh_Orient(:,ei);
    Neg_Mask = (Edge_Sign==-1);
    % gets DoF indices on the current edge
    DoFs_On_Edge = get_dofs_on_edge(All_Edge_DoFs,ei);
    % flip necessary signs
    Sign_Change(Neg_Mask,DoFs_On_Edge) = -1;
end

end

function DoFs = get_dofs_on_edge(All_Edge_DoFs,Edge_Index)

DoFs = []; % init
for ci = 1:length(All_Edge_DoFs)
    DoF_Set = All_Edge_DoFs{ci};
    DI = DoF_Set(Edge_Index,:);
    DoFs = [DoFs; DI(:)];
end

end