function FH = Print_DoFs_tetrahedron(obj)
%Print_DoFs_tetrahedron
%
%   This creates a figure that describes the topological layout of the
%   Degrees-of-Freedom (DoFs) on the reference tetrahedron.

% Copyright (c) 05-01-2012,  Shawn W. Walker

FH = figure;

scale = 0;
Color_RGB = [0 0 0];
myMarkerSize = 18;
myLineWidth = 1.3;
V1 = [0 0 0];
V2 = [1 0 0];
V3 = [0 1 0];
V4 = [0 0 1];
Vtx = [V1; V2; V3; V4];
VtxB = [V1; V1; V1; V2; V3; V4];
Arrow = 0.5*[(V2 - V1); (V3 - V1); (V4 - V1); (V3 - V2); (V4 - V3); (V2 - V4)];
Edge1 = [V1; V2];
Edge2 = [V1; V3];
Edge3 = [V1; V4];
Edge4 = [V2; V3];
Edge5 = [V3; V4];
Edge6 = [V4; V2];
hold on;
quiver3(VtxB(:,1),VtxB(:,2),VtxB(:,3),...
    Arrow(:,1),Arrow(:,2),Arrow(:,3),scale,'Color',Color_RGB,...
    'MarkerSize',myMarkerSize,'LineWidth',myLineWidth);
plot3(Edge1(:,1),Edge1(:,2),Edge1(:,3),'k-','LineWidth',myLineWidth);
plot3(Edge2(:,1),Edge2(:,2),Edge2(:,3),'k-','LineWidth',myLineWidth);
plot3(Edge3(:,1),Edge3(:,2),Edge3(:,3),'k-','LineWidth',myLineWidth);
plot3(Edge4(:,1),Edge4(:,2),Edge4(:,3),'k-','LineWidth',myLineWidth);
plot3(Edge5(:,1),Edge5(:,2),Edge5(:,3),'k-','LineWidth',myLineWidth);
plot3(Edge6(:,1),Edge6(:,2),Edge6(:,3),'k-','LineWidth',myLineWidth);
text(0.0,0.0,-0.05,'V_1');
text(1.09,0.0,0.0,'V_2');
text(0.0,1.04,0.0,'V_3');
text(0.0,0.0,1.04,'V_4');
text(0.52,0.0,0.08,'E_1');
text(0.0,0.52,0.04,'E_2');
text(-0.03,0.0,0.52,'E_3');
text(0.55,0.55,-0.05,'E_4');
text(-0.0,0.52,0.52,'E_5');
text(0.53,-0.09,0.53,'E_6');

text(0.35,0.35,0.35,'F_1');
text(-0.03,0.26,0.26,'F_2');
text(0.26,-0.07,0.26,'F_3');
text(0.26,0.26,-0.05,'F_4');

text(0.18,0.18,0.18,'T_1');
AZ = 130;
EL = 20;
view(AZ,EL);
hold off;
AX = [-0.1 1.1 -0.1 1.1 -0.1 1.1];
%axis(AX);
axis equal
axis(AX);
grid off;
default_text = get(0,'defaulttextinterpreter');
set(0,'defaulttextinterpreter','none');
title(['DoF Arrangement For  ', obj.Elem.Element_Name]);
set(0,'defaulttextinterpreter',default_text);

% these are cell arrays
Num_DoF = length(obj.Elem.Basis);
% Vtx_DoFs = obj.Elem.Nodal_Top.V;
% Edge_DoFs = obj.Elem.Nodal_Top.E;
% Face_DoFs = obj.Elem.Nodal_Top.F;
% Tet_DoFs = obj.Elem.Nodal_Top.T;

obj.Print_DoF_Indices_Msg;

hold on;
for ind = 1:Num_DoF
    DoF_Set = obj.Elem.Nodal_Data.DoF_Set(ind);
    Type_str = obj.Elem.Nodal_Data.Type{ind};
    Entity_ind = obj.Elem.Nodal_Data.Entity_Index(ind);
    disp(['DoF set #', num2str(DoF_Set), ' | DoF #', num2str(ind), ' | Type: ', Type_str, ' | Entity #', num2str(Entity_ind)]);
    BC = obj.Elem.Nodal_Data.BC_Coord(ind,:);
    disp(['       Barycentric coordinates: [', num2str(BC(1),'%1.10G'), ', ', num2str(BC(2),'%1.10G'), ', ',...
                                               num2str(BC(3),'%1.10G'), ', ', num2str(BC(4),'%1.10G'), ']']);
    plot3(BC(2),BC(3),BC(4),'k.','MarkerSize',myMarkerSize);
end
hold off;

end