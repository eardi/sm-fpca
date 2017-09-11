function uu_VEC = Get_RT0_Interpolant_of_Function(Vtx,Tri,RT0_DoFmap,Orient,FUNC)

Num_Tri = size(Tri,1);
Num_RT0_DoFs = max(RT0_DoFmap(:));

if (Num_Tri~=size(RT0_DoFmap,1))
    error('Number of Tri''s must equal number of rows of RT0_DoFmap!');
end
if (Num_Tri~=size(Orient,1))
    error('Number of Tri''s must equal number of rows of Orient!');
end

% init
uu_VEC = zeros(Num_RT0_DoFs,1);
TAN = zeros(3,2);
NOR = zeros(3,2);

Orient_Dir = zeros(size(Orient,1),3);
Orient_Dir(Orient)  =  1;
Orient_Dir(~Orient) = -1;

% loop through triangles
for index=1:Num_Tri
    RT0_i = RT0_DoFmap(index,:);
    % get x1,x2,x3 vertices
    X1 = Vtx(Tri(index,1),:);
    X2 = Vtx(Tri(index,2),:);
    X3 = Vtx(Tri(index,3),:);
    X_Mid_1 = 0.5 * (X2 + X3);
    X_Mid_2 = 0.5 * (X3 + X1);
    X_Mid_3 = 0.5 * (X1 + X2);
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
    % this is actually an integral!!! Not ``point-wise'' evaluation
    uu_VEC(RT0_i(1),1) = Orient_Dir(index,1) * dot(NOR(1,:), FUNC(X_Mid_1)); % phi_1
    uu_VEC(RT0_i(2),1) = Orient_Dir(index,2) * dot(NOR(2,:), FUNC(X_Mid_2)); % phi_2
    uu_VEC(RT0_i(3),1) = Orient_Dir(index,3) * dot(NOR(3,:), FUNC(X_Mid_3)); % phi_3
end

end