function [TT, VV] = extrude_2D_triangles_to_prism_3D_tetrahedra(Tri,Vtx,Nz)
%extrude_2D_triangles_to_prism_3D_tetrahedra
%
%   Generates a 3-D tetrahedral mesh by extruding a given 2-D triangulation
%   into 3-D prisms (with given number of layers) and subdividing each
%   prism into 3 tetrahedra each.  The extrusion is done in the "z"
%   direction.  Note: the height of the extrusion is 1.
%
%   [TT, VV] = extrude_2D_triangles_to_prism_3D_tetrahedra(Tri,Vtx,Nz);
%
%   Input:     
%       Tri = triangle connectivity list of indices into Vtx.
%       Vtx = list of vertex coordinates in 2-D.
%       Nz  = number of layer prisms (in z direction) to create (must be > 0).
%
%   Output:
%       TT = tetrahedral connectivity list of indices into VV.
%       VV = list of vertex coordinates in 3-D.
%
%   Example:
%     [Tri,Vtx] = bcc_triangle_mesh(3,3);
%     [TT,VV] = extrude_2D_triangles_to_prism_3D_tetrahedra(Tri,Vtx,2);
%     tetramesh(TT,VV);

% Copyright (c) 03-06-2018,  Shawn W. Walker

if ( Nz < 1 )
    error('Must be at least 1 prism layer in z direction!');
end
if (size(Tri,2)~=3)
    error('Triangle connectivity is not valid!  Must be 3 columns.');
end
if (size(Vtx,2)~=2)
    error('Triangle vertices are not in 2-D!  Only a (geometrically) 2-D mesh is allowed.');
end

% adjust triangulation so lowest vertex index is first
[YY, min_vtx_ind] = min(Tri,[],2);
VI_2_Mask = min_vtx_ind==2;
VI_3_Mask = min_vtx_ind==3;
Tri(VI_2_Mask,:) = Tri(VI_2_Mask,[2 3 1]);
Tri(VI_3_Mask,:) = Tri(VI_3_Mask,[3 1 2]);

% number of tri's and vtx's:
Num_Tri_in_Base = size(Tri,1);
Num_Vtx_in_Base = size(Vtx,1);

% make vertices 3-D
VV = repmat(Vtx,[Nz+1,1]);
Z_coord = linspace(0,1,Nz+1)';
VV_Z = kron(Z_coord,ones(Num_Vtx_in_Base,1));
VV = [VV, VV_Z];

% % do one layer of tetrahedra
% V_I  = (1:1:Num_Vtx_in_Base)';
% T1   = [Tri(:,1), Tri(:,2) + Num_Vtx_in_Base, Tri(:,3) + Num_Vtx_in_Base, Tri(:,1) + Num_Vtx_in_Base];
% T2_A = [Tri(:,1), Tri(:,2), Tri(:,3) + Num_Vtx_in_Base, Tri(:,2) + Num_Vtx_in_Base];
% T3_A = [Tri(:,1), Tri(:,2), Tri(:,3), Tri(:,3) + Num_Vtx_in_Base];
% T2_B = [Tri(:,1), Tri(:,2) + Num_Vtx_in_Base, Tri(:,3), Tri(:,3) + Num_Vtx_in_Base];
% T3_B = [Tri(:,1), Tri(:,2), Tri(:,3), Tri(:,2) + Num_Vtx_in_Base];
% 
% Prism_Mask_A = Tri(:,2) < Tri(:,3);
% Prism_Mask_B = ~Prism_Mask_A;
% 
% T2 = 0*T1;
% T2(Prism_Mask_A,:) = T2_A(Prism_Mask_A,:);
% T2(Prism_Mask_B,:) = T2_B(Prism_Mask_B,:);
% 
% T3 = 0*T1;
% T3(Prism_Mask_A,:) = T3_A(Prism_Mask_A,:);
% T3(Prism_Mask_B,:) = T3_B(Prism_Mask_B,:);

% vectorize T1
T1_Base = Tri(:,[1 2 3 1]);
T1_Base = repmat(T1_Base,[Nz,1]);
L_I = (1:1:Nz)';

NV_Vec = Num_Vtx_in_Base*ones(Num_Tri_in_Base,1);
T1_Offset = kron([L_I-1, L_I, L_I, L_I],NV_Vec);
T1 = T1_Base + T1_Offset;

% vectorize T2
T2_Base_A = Tri(:,[1 2 3 2]);
T2_Base_A = repmat(T2_Base_A,[Nz,1]);
T2_Base_B = Tri(:,[1 2 3 3]);
T2_Base_B = repmat(T2_Base_B,[Nz,1]);

T2_Offset_A = kron([L_I-1, L_I-1, L_I, L_I],NV_Vec);
T2_A = T2_Base_A + T2_Offset_A;
T2_Offset_B = kron([L_I-1, L_I, L_I-1, L_I],NV_Vec);
T2_B = T2_Base_B + T2_Offset_B;

% vectorize T3
T3_Base_A = Tri(:,[1 2 3 3]);
T3_Base_A = repmat(T3_Base_A,[Nz,1]);
T3_Base_B = Tri(:,[1 2 3 2]);
T3_Base_B = repmat(T3_Base_B,[Nz,1]);

T3_Offset = kron([L_I-1, L_I-1, L_I-1, L_I],NV_Vec);
T3_A = T3_Base_A + T3_Offset;
T3_B = T3_Base_B + T3_Offset;

% choice for T2 and T3
Prism_Mask_A = Tri(:,2) < Tri(:,3);
Prism_Mask_B = ~Prism_Mask_A;
Prism_Mask_A = repmat(Prism_Mask_A,[Nz,1]);
Prism_Mask_B = repmat(Prism_Mask_B,[Nz,1]);

T2 = 0*T1;
T2(Prism_Mask_A,:) = T2_A(Prism_Mask_A,:);
T2(Prism_Mask_B,:) = T2_B(Prism_Mask_B,:);

T3 = 0*T1;
T3(Prism_Mask_A,:) = T3_A(Prism_Mask_A,:);
T3(Prism_Mask_B,:) = T3_B(Prism_Mask_B,:);

% collect all tetrahedra together
TT = [T1; T2; T3];

end