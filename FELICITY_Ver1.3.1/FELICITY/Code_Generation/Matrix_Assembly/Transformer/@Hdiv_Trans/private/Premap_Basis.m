function Sign_Change = Premap_Basis(Mesh_Orient,All_Facet_DoFs,Num_Basis)
%Premap_Basis
%
%   This is used by the H(div) elements for pre-mapping basis functions to
%   adjust for different facet orientations.
%
%   Sign_Change = Premap_Basis_Hdiv(Mesh_Orient,All_Facet_DoFs,Num_Basis);
%
%   Mesh_Orient: NxF vector indicating actual orientation of mesh elements
%               (N is the number of elements; F is the number of element
%                facets.)
%         Ex:  [+1, -1, +1; ...] (F = 3 here)
%         Elem #1:  facet 1 and facet 3 are positively oriented;
%                   facet 2 is negative, etc...
%   All_Facet_DoFs: cell array of sets of DoFs attached to all facets.
%   Num_Basis: number of basis functions in the element.
%
%   Sign_Change: NxB matrix, where B = number of basis functions:
%                +1 = no sign change.
%                -1 = flip sign of corresponding basis function.
%                Rows correspond to rows of "Mesh_Orient".

% Copyright (c) 09-12-2016,  Shawn W. Walker

Num_Elem   = size(Mesh_Orient,1);
Num_Facets = size(Mesh_Orient,2);

Sign_Change = ones(Num_Elem,Num_Basis); % init

% loop through the local facets (edges) of the mesh elements
for fi = 1:Num_Facets
    Facet_Sign = Mesh_Orient(:,fi);
    Neg_Mask = (Facet_Sign==-1);
    % gets DoF indices on the current facet
    DoFs_On_Facet = get_dofs_on_facet(All_Facet_DoFs,fi);
    % flip necessary signs
    Sign_Change(Neg_Mask,DoFs_On_Facet) = -1;
end

end

function DoFs = get_dofs_on_facet(All_Facet_DoFs,Facet_Index)

DoFs = []; % init
for ci = 1:length(All_Facet_DoFs)
    DoF_Set = All_Facet_DoFs{ci};
    DI = DoF_Set(Facet_Index,:);
    DoFs = [DoFs; DI(:)];
end

end