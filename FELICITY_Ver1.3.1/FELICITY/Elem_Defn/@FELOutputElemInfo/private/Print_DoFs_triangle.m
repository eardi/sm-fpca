function FH = Print_DoFs_triangle(obj)
%Print_DoFs_triangle
%
%   This creates a figure that describes the topological layout of the
%   Degrees-of-Freedom (DoFs) on the reference triangle.

% Copyright (c) 05-24-2018,  Shawn W. Walker

FH = figure;

scale = 0;
Color_RGB = [0 0 0];
myMarkerSize = 16;
myLineWidth = 1.3;
Vtx = [0 0; 1 0; 0 1];
Arrow = [0.5 0.0; -0.5 0.5; 0.0 -0.5];
hold on;
quiver(Vtx(:,1),Vtx(:,2),Arrow(:,1),Arrow(:,2),scale,'Color',Color_RGB,...
    'MarkerSize',myMarkerSize,'LineWidth',myLineWidth);
Vtx_2 = [Vtx; 0 0];
plot(Vtx_2(:,1),Vtx_2(:,2),'k-','LineWidth',myLineWidth);
text(0.02,0.04,'V_1');
text(0.99,0.04,'V_2');
text(0.02,1.0,'V_3');
text(0.52,0.52,'E_1');
text(-0.07,0.5,'E_2');
text(0.5,-0.05,'E_3');
text(0.25,0.25,'F_1');
hold off;
AX = [-0.1 1.1 -0.1 1.1];
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

obj.Print_DoF_Indices_Msg;

hold on;
for ind = 1:Num_DoF
    DoF_Set = obj.Elem.Nodal_Data.DoF_Set(ind);
    Type_str = obj.Elem.Nodal_Data.Type{ind};
    Entity_ind = obj.Elem.Nodal_Data.Entity_Index(ind);
    disp(['DoF set #', num2str(DoF_Set), ' | DoF #', num2str(ind), ' | Type: ', Type_str, ' | Entity #', num2str(Entity_ind)]);
    BC = obj.Elem.Nodal_Data.BC_Coord(ind,:);
    disp(['       Barycentric coordinates: [', num2str(BC(1),'%1.10G'), ', ', num2str(BC(2),'%1.10G'), ', ', num2str(BC(3),'%1.10G'), ']']);
    plot(BC(2),BC(3),'k.','MarkerSize',myMarkerSize);
end
hold off;

end