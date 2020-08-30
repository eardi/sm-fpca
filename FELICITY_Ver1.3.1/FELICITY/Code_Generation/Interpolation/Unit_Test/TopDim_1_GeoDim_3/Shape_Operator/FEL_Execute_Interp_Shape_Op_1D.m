function status = FEL_Execute_Interp_Shape_Op_1D(mexName)
%FEL_Execute_Interp_Shape_Op_1D
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 08-17-2014,  Shawn W. Walker

% BEGIN: define simple 1-D mesh
Num_P1_Nodes = 101;
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1)]); % NOTE! unsigned integer
P1_Mesh_Nodes = linspace(0,1,Num_P1_Nodes)';
P1_Mesh_Nodes = [P1_Mesh_Nodes, 0*P1_Mesh_Nodes, 0*P1_Mesh_Nodes]; % set y and z components to zero for now
Num_Edges = size(P1_Mesh_DoFmap,1);
Num_Current_DoF = max(P1_Mesh_DoFmap(:));
Extra_P2_Nodes = Num_Current_DoF + uint32((1:1:Num_Edges)');
P2_DoFmap = [P1_Mesh_DoFmap, Extra_P2_Nodes];
Mesh = MeshInterval(P1_Mesh_DoFmap,P1_Mesh_Nodes,'Sigma');
% END: define simple 1-D mesh

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim1);
Space = FiniteElementSpace('Scalar_P2',Ref_P2_Elem,Mesh,'Sigma');
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% now define \Sigma to be a parabola
P2_Mesh_Nodes(:,2) = P2_Mesh_Nodes(:,1).^2;
P2_Mesh_Nodes(:,3) = P2_Mesh_Nodes(:,1).^2;
P1_Mesh_Nodes = P2_Mesh_Nodes(1:Num_P1_Nodes,:);
Mesh = Mesh.Set_Points(P1_Mesh_Nodes);

% define the interpolation points
Cell_Indices = (1:1:Mesh.Num_Cell)';
% interpolate at the barycenter of reference interval
Sigma_Interp_Data = {uint32(Cell_Indices), (1/2) * ones(Mesh.Num_Cell,1)};

% interpolate!
tic
INTERP = feval(str2func(mexName),P2_Mesh_Nodes,P2_Mesh_DoFmap,[],[],Sigma_Interp_Data);
toc

kappa = INTERP(1).DATA{1};
Num_Pts = length(Sigma_Interp_Data{1});
TV = zeros(Num_Pts,3);
TV(:) = cell2mat(INTERP(3).DATA);
Shape_Op = zeros(3,3,Num_Pts);
for ii = 1:3
    for jj = 1:3
        Shape_Op(ii,jj,:) = INTERP(2).DATA{ii,jj};
    end
end

% error check
CHK_SO = 0;
for pt = 1:Num_Pts
    % get interpolated value at each point
    kappa_pt = kappa(pt);
    TV_pt = TV(pt,:)';
    Shape_Op_pt = Shape_Op(:,:,pt);
    
    % check that the shape operator is equal to:  kappa * [tv x tv]
    SO = kappa_pt * (TV_pt * TV_pt');
    DIFF_SO = SO - Shape_Op_pt;
    ERR_SO = max(abs(DIFF_SO(:)));
    CHK_SO = max(ERR_SO, CHK_SO);
end

status = 0; % init
TOL = 1e-15;
if (CHK_SO > TOL)
    CHK_SO
    disp('Shape operator does not match kappa * [tangent_vector x tangent_vector].');
    status = 1;
end

end