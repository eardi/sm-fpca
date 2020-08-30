function [Geo_Points, TV, NV, Curv_Vec] = Get_Curved_Element_Mapping(G_Space,Geo_Points_hat,...
                                              MM,Bdy_Tri_Ind,Local_Edge_Ind,Surf_Map)
%Get_Curved_Element_Mapping
%
%    MM is a struct of mesh info.  Geo_Points_hat is in the flat reference
%    domain.
%
%    [Geo_Points, TV, NV, Curv_Vec] = Get_Curved_Element_Mapping(G_Space,Geo_Points_hat,...
%                                     MM,Bdy_Tri_Ind,Local_Edge_Ind)
%
%    This routine takes an optional argument which is a surface map,
%    indicating that this 2-D (flat) domain gets mapped to a surface.  In
%    addition, the tangent, normal, and curvature vectors correspond to the
%    boundary of the surface.
%
%    [Geo_Points, TV, NV, Curv_Vec] = Get_Curved_Element_Mapping(G_Space,Geo_Points_hat,...
%                                     MM,Bdy_Tri_Ind,Local_Edge_Ind,Surf_Map)

% Copyright (c) 05-07-2020,  Shawn W. Walker

if (nargin <= 5)
    % there is no surface map
    Surf_Map = [];
elseif ~isa(Surf_Map,'function_handle')
    error('Surf_Map must be a function handle!');
end

% all the DoFs
All_DoFs = (1:1:G_Space.RefElem.Num_Basis)';
% get the vertex DoFs
Nodal_Top_V = G_Space.RefElem.Nodal_Top.V{1};
% remove the vertex DoFs; those don't need to map
Without_Vtx_DoFs = setdiff(All_DoFs,Nodal_Top_V);
%Other_DoFs = All_DoFs;

PD = ParametricMesh_2D('Curved_Bdy',MM.Chart_Intervals,MM.Chart_Funcs);
%PD

% get the Iter_Func once and for all
XC = {[MM.VTX(MM.BdyEDGE(1,1),:);
       MM.VTX(MM.BdyEDGE(1,2),:)]};
[~, Iter_Func] = PD.Get_Chart_Var_Ortho_Edge(MM.VTX(MM.BdyEDGE(1,1),:),MM.VTX(MM.BdyEDGE(1,2),:),...
                                      MM.BdyChart_Ind,MM.BdyChart_Var,XC,true);
%

% get the tangent and normal vector
[Tangent_Func, Normal_Func] = PD.Get_Tangent_Normal_Funcs(Surf_Map);
Curvature_Vec_Func = PD.Get_Curvature_Vector_Func(Surf_Map);

% init
if isempty(Surf_Map)
    Geo_Points = Geo_Points_hat;
else
    Geo_Points = Surf_Map(Geo_Points_hat(:,1),Geo_Points_hat(:,2));
end
TV = 0*Geo_Points;
NV = 0*Geo_Points;
Curv_Vec = 0*Geo_Points;

for bb = 1:size(Bdy_Tri_Ind,1)
%

TI = Bdy_Tri_Ind(bb,1);

% get the nodal coordinates (of the geo element) on the physical triangle
Geo_DoFs = double(G_Space.DoFmap(TI,:));
% here is F^1_T(\hat{\vx})
NP = Geo_Points_hat(Geo_DoFs,:);

% get points of the affine triangle
%Tri_DoF = Geo_DoFs(1,1:3);
Tri_Vtx = NP(1:3,:);

% which edge is on the boundary?
ei = Local_Edge_Ind(bb,1);

% determine which local edge
if (ei==1)
    Tail_Vtx = Tri_Vtx(2,:);
    Head_Vtx = Tri_Vtx(3,:);
    J_composed_l_hat = @(x,y) y;
    Ext_Factor = @(x,y) x ./ (1 - y);
elseif (ei==2)
    Tail_Vtx = Tri_Vtx(3,:);
    Head_Vtx = Tri_Vtx(1,:);
    J_composed_l_hat = @(x,y) 1 - y;
    Ext_Factor = @(x,y) (1 - x - y) ./ (1 - y);
elseif (ei==3)
    Tail_Vtx = Tri_Vtx(1,:);
    Head_Vtx = Tri_Vtx(2,:);
    J_composed_l_hat = @(x,y) x;
    Ext_Factor = @(x,y) (1 - x - y) ./ (1 - x);
else
    error('Invalid!');
end

% get all DoF coordinates in the reference element
DoF_Coord_hat = G_Space.RefElem.Get_DoF_Coords_On_Reference_Domain();

% % only need the other ones
% Other_DoF_Coord_hat = DoF_Coord_hat(Other_DoFs,:);

% map points to \hat{\chi}^1 = [0,1]
%t_hat = J_composed_l_hat(Other_DoF_Coord_hat(:,1),Other_DoF_Coord_hat(:,2));
t_hat = J_composed_l_hat(DoF_Coord_hat(:,1),DoF_Coord_hat(:,2));

% compute the extension factor now
%EF = Ext_Factor(Other_DoF_Coord_hat(:,1),Other_DoF_Coord_hat(:,2));
EF = 0*DoF_Coord_hat(:,1);
EF(Without_Vtx_DoFs,1) = Ext_Factor(DoF_Coord_hat(Without_Vtx_DoFs,1),DoF_Coord_hat(Without_Vtx_DoFs,2));
% Note: we set the extension factor to zero on all Vtx DoFs (because the
% vertices do not need to map; they are already where they are supposed to be)

% now apply the map G_{\chi}^1 to map to the flat edge on boundary
%X_pts = zeros(size(Other_DoF_Coord_hat,1),2); % init
X_pts = zeros(size(DoF_Coord_hat,1),2); % init
for ii = 1:2
    X_pts(:,ii) = (1 - t_hat) * Tail_Vtx(ii) + t_hat * Head_Vtx(ii);
end
% BTW: this is the identity map on the flat edge!

% now do the interpolation in two steps

% first, find the parametrization variables that map the points orthogonal to the
% edge

% put points in struct
XC = {X_pts};

% Tail_Vtx
% Head_Vtx
% X_pts
% MM.Chart_Funcs
% MM.Chart_Intervals
% MM.BdyChart_Var(bb,:)

Chart_Var_XC = PD.Get_Chart_Var_Ortho_Edge(Tail_Vtx,Head_Vtx,...
                                 MM.BdyChart_Ind(bb,1),MM.BdyChart_Var(bb,:),XC,true,Iter_Func);
% parse it
Chart_Var = Chart_Var_XC{1};

% second, evaluate the chart
Chart_Func = MM.Chart_Funcs{MM.BdyChart_Ind(bb,1)};
Lambda_Chart = Chart_Func(Chart_Var);

% finally, subtract off the identity map on the flat edge, ...
Theta_Chart = Lambda_Chart - X_pts;

% and compute the Lenoir formula
New_NP = NP; % init to F_T^1
%Other_NP = NP(Other_DoFs,:); % F_T^1
for ii = 1:2
    %New_NP(Other_DoFs,ii) = EF .* Theta_Chart(:,ii) + Other_NP(:,ii);
    New_NP(:,ii) = EF .* Theta_Chart(:,ii) + NP(:,ii);
end

if isempty(Surf_Map)
    Mapped_NP = New_NP;
else
    Mapped_NP = Surf_Map(New_NP(:,1),New_NP(:,2));
end

% update!
Geo_Points(Geo_DoFs,:) = Mapped_NP;

% get the correct tangent, normal, and curvature vector for the current chart
TV_func = Tangent_Func{MM.BdyChart_Ind(bb,1)};
NV_func = Normal_Func{MM.BdyChart_Ind(bb,1)};
Curv_Vec_func = Curvature_Vec_Func{MM.BdyChart_Ind(bb,1)};

% evaluate the tangent and normal vector (extend by a constant)
TV_loc = TV_func(Chart_Var);
NV_loc = NV_func(Chart_Var);
Curv_Vec_loc = Curv_Vec_func(Chart_Var);

% update
TV(Geo_DoFs,:) = TV_loc;
NV(Geo_DoFs,:) = NV_loc;
Curv_Vec(Geo_DoFs,:) = Curv_Vec_loc;

end

end