function uu_VEC = Get_BDM1_Interpolant_of_Function(Vtx,Tri,BDM1_DoFmap,Orient,FUNC)

Num_Tri = size(Tri,1);
Num_BDM1_DoFs = max(BDM1_DoFmap(:));

if (Num_Tri~=size(BDM1_DoFmap,1))
    error('Number of Tri''s must equal number of rows of BDM1_DoFmap!');
end
if (Num_Tri~=size(Orient,1))
    error('Number of Tri''s must equal number of rows of Orient!');
end

% init
uu_VEC = zeros(Num_BDM1_DoFs,1);
TAN = zeros(3,2);
NOR = zeros(3,2);

Orient_Dir = zeros(size(Orient,1),3);
Orient_Dir(Orient)  =  1;
Orient_Dir(~Orient) = -1;

% get quad rule on the unit interval
[Quad.Pt, Quad.Wt] = GaussQuad(3, 0, 1);
% Quad.Pt = [0; 1];
% Quad.Wt = [0.5; 0.5];

% loop through triangles
for index=1:Num_Tri
    BDM1_i = BDM1_DoFmap(index,:);
    % get x1,x2,x3 vertices
    X1 = Vtx(Tri(index,1),:);
    X2 = Vtx(Tri(index,2),:);
    X3 = Vtx(Tri(index,3),:);
%     Node1 = X2;
%     Node2 = X3;
%     Node3 = X3;
%     Node4 = X1;
%     Node5 = X1;
%     Node6 = X2;
%     X_Mid_1 = 0.5 * (X2 + X3);
%     X_Mid_2 = 0.5 * (X3 + X1);
%     X_Mid_3 = 0.5 * (X1 + X2);
    % compute t's and n's
    TAN(1,:) = X3 - X2;
    TAN(2,:) = X1 - X3;
    TAN(3,:) = X2 - X1;
    NOR(1,:) = [TAN(1,2), -TAN(1,1)];
    NOR(2,:) = [TAN(2,2), -TAN(2,1)];
    NOR(3,:) = [TAN(3,2), -TAN(3,1)];
    % do not normalize!  that way the normal already has the edge length factor
    % included.
    
    % set DoFs
    phi_tail = (1-Quad.Pt); % in local coordinates
    phi_head = Quad.Pt; % in local coordinates
    uu_VEC(BDM1_i(1),1) = Orient_Dir(index,1) * eval_edge_integral(FUNC,phi_tail,X2,X3,NOR(1,:),Quad); % phi_1
    uu_VEC(BDM1_i(2),1) = Orient_Dir(index,1) * eval_edge_integral(FUNC,phi_head,X2,X3,NOR(1,:),Quad); % phi_2
    
    uu_VEC(BDM1_i(3),1) = Orient_Dir(index,2) * eval_edge_integral(FUNC,phi_tail,X3,X1,NOR(2,:),Quad); % phi_3
    uu_VEC(BDM1_i(4),1) = Orient_Dir(index,2) * eval_edge_integral(FUNC,phi_head,X3,X1,NOR(2,:),Quad); % phi_4
    
    uu_VEC(BDM1_i(5),1) = Orient_Dir(index,3) * eval_edge_integral(FUNC,phi_tail,X1,X2,NOR(3,:),Quad); % phi_5
    uu_VEC(BDM1_i(6),1) = Orient_Dir(index,3) * eval_edge_integral(FUNC,phi_head,X1,X2,NOR(3,:),Quad); % phi_6

%     % this is actually an integral!!! Not ``point-wise'' evaluation
%     % the half factor is due to integrating linear polys (dual basis) on each
%     % edge.
%     uu_VEC(BDM1_i(1),1) = Orient_Dir(index,1) * 0.5 * dot(NOR(1,:), FUNC(X2)); % phi_1
%     uu_VEC(BDM1_i(2),1) = Orient_Dir(index,1) * 0.5 * dot(NOR(1,:), FUNC(X3)); % phi_2
%     
%     uu_VEC(BDM1_i(3),1) = Orient_Dir(index,2) * 0.5 * dot(NOR(2,:), FUNC(X3)); % phi_3
%     uu_VEC(BDM1_i(4),1) = Orient_Dir(index,2) * 0.5 * dot(NOR(2,:), FUNC(X1)); % phi_4
%     
%     uu_VEC(BDM1_i(5),1) = Orient_Dir(index,3) * 0.5 * dot(NOR(3,:), FUNC(X1)); % phi_5
%     uu_VEC(BDM1_i(6),1) = Orient_Dir(index,3) * 0.5 * dot(NOR(3,:), FUNC(X2)); % phi_6

end

end

function Int_Val = eval_edge_integral(FUNC,phi,Tail,Head,N,Quad)

% note: N already has the edge length factor (Jacobian) included!

Nodes = (1-Quad.Pt) * Tail + Quad.Pt * Head;
Func_Val = FUNC(Nodes);
dot1  = N(1) * Func_Val(:,1) + N(2) * Func_Val(:,2);

integrand1 = dot1 .* phi;

Int_Val = integrand1' * Quad.Wt;

end