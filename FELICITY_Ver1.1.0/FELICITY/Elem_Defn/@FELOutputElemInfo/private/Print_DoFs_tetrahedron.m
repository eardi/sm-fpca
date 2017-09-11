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
Vtx_DoFs = obj.Elem.Nodal_Top.V;
Edge_DoFs = obj.Elem.Nodal_Top.E;
Face_DoFs = obj.Elem.Nodal_Top.F;
Tet_DoFs = obj.Elem.Nodal_Top.T;

obj.Print_DoF_Indices_Msg;

hold on;
% plot the vertex DoFs, and display them at the MATLAB window
for vd = 1:length(Vtx_DoFs)
    DoF_Set = Vtx_DoFs{vd};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=4)
            error('There should be 4 vertices for a tetrahedron.');
        end
        plot3(Vtx(:,1),Vtx(:,2),Vtx(:,3),'k.','MarkerSize',myMarkerSize);
        disp(['Vertex DoF set #', num2str(vd), ':']);
        V1_str = ['V_1 = (0,0,0): ', num2str(DoF_Set(1,:))];
        V2_str = ['V_2 = (1,0,0): ', num2str(DoF_Set(2,:))];
        V3_str = ['V_3 = (0,1,0): ', num2str(DoF_Set(3,:))];
        V4_str = ['V_4 = (0,0,1): ', num2str(DoF_Set(4,:))];
        disp(V1_str);
        disp(V2_str);
        disp(V3_str);
        disp(V4_str);
        disp(' ');
    end
end

% plot the edge DoFs
for ed = 1:length(Edge_DoFs)
    DoF_Set = Edge_DoFs{ed};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=6)
            error('There should be 6 edges for a tetrahedron.');
        end
        t_pts = linspace(0, 1, length(DoF_Set(1,:))+2);
        t_pts = t_pts(2:end-1);
        E1_pts = (1 - t_pts)' * Vtx(1,:) + (t_pts)' * Vtx(2,:);
        E2_pts = (1 - t_pts)' * Vtx(1,:) + (t_pts)' * Vtx(3,:);
        E3_pts = (1 - t_pts)' * Vtx(1,:) + (t_pts)' * Vtx(4,:);
        E4_pts = (1 - t_pts)' * Vtx(2,:) + (t_pts)' * Vtx(3,:);
        E5_pts = (1 - t_pts)' * Vtx(3,:) + (t_pts)' * Vtx(4,:);
        E6_pts = (1 - t_pts)' * Vtx(4,:) + (t_pts)' * Vtx(2,:);
        plot3(E1_pts(:,1),E1_pts(:,2),E1_pts(:,3),'k.','MarkerSize',myMarkerSize);
        plot3(E2_pts(:,1),E2_pts(:,2),E2_pts(:,3),'k.','MarkerSize',myMarkerSize);
        plot3(E3_pts(:,1),E3_pts(:,2),E3_pts(:,3),'k.','MarkerSize',myMarkerSize);
        plot3(E4_pts(:,1),E4_pts(:,2),E4_pts(:,3),'k.','MarkerSize',myMarkerSize);
        plot3(E5_pts(:,1),E5_pts(:,2),E5_pts(:,3),'k.','MarkerSize',myMarkerSize);
        plot3(E6_pts(:,1),E6_pts(:,2),E6_pts(:,3),'k.','MarkerSize',myMarkerSize);
        disp(['Edge DoF set #', num2str(ed), ':']);
        disp(['E_1 = (V_1, V_2): ', num2str(DoF_Set(1,:))]);
        disp(['E_2 = (V_1, V_3): ', num2str(DoF_Set(2,:))]);
        disp(['E_3 = (V_1, V_4): ', num2str(DoF_Set(3,:))]);
        disp(['E_4 = (V_2, V_3): ', num2str(DoF_Set(4,:))]);
        disp(['E_5 = (V_3, V_4): ', num2str(DoF_Set(5,:))]);
        disp(['E_6 = (V_4, V_2): ', num2str(DoF_Set(6,:))]);
        disp(' ');
    end
end

% plot the face DoFs
for fd = 1:length(Face_DoFs)
    DoF_Set = Face_DoFs{fd};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=4)
            error('There should be 4 faces for a tetrahedron.');
        end
        Alt_Vtx_F1 = [0.8*V2 + 0.1*V3 + 0.1*V4; 0.1*V2 + 0.8*V3 + 0.1*V4; 0.1*V2 + 0.1*V3 + 0.8*V4];
        Alt_Vtx_F2 = [0.76*V1 + 0.12*V4 + 0.12*V3; 0.12*V1 + 0.76*V4 + 0.12*V3; 0.12*V1 + 0.12*V4 + 0.76*V3];
        Alt_Vtx_F3 = [0.76*V1 + 0.12*V2 + 0.12*V4; 0.12*V1 + 0.76*V2 + 0.12*V4; 0.12*V1 + 0.12*V2 + 0.76*V4];
        Alt_Vtx_F4 = [0.76*V1 + 0.12*V3 + 0.12*V2; 0.12*V1 + 0.76*V3 + 0.12*V2; 0.12*V1 + 0.12*V3 + 0.76*V2];
        plot_face_DoFs(Alt_Vtx_F1,DoF_Set(1,:),myMarkerSize,[(1/3)*V2 + (1/3)*V3 + (1/3)*V4]);
        plot_face_DoFs(Alt_Vtx_F2,DoF_Set(2,:),myMarkerSize,[(1/3)*V1 + (1/3)*V4 + (1/3)*V3]);
        plot_face_DoFs(Alt_Vtx_F3,DoF_Set(3,:),myMarkerSize,[(1/3)*V1 + (1/3)*V2 + (1/3)*V4]);
        plot_face_DoFs(Alt_Vtx_F4,DoF_Set(4,:),myMarkerSize,[(1/3)*V1 + (1/3)*V3 + (1/3)*V2]);
        disp(['Face DoF set #', num2str(fd), ':']);
        disp(['F_1 = (V_2, V_3, V_4): ', num2str(DoF_Set(1,:))]);
        disp(['F_2 = (V_1, V_4, V_3): ', num2str(DoF_Set(2,:))]);
        disp(['F_3 = (V_1, V_2, V_4): ', num2str(DoF_Set(3,:))]);
        disp(['F_4 = (V_1, V_3, V_2): ', num2str(DoF_Set(4,:))]);
        disp(' ');
    end
end

% plot the (internal) tet DoFs
for td = 1:length(Tet_DoFs)
    DoF_Set = Tet_DoFs{td};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=1)
            error('There should be 1 tet for a tetrahedron.');
        end
        num_in_set = length(DoF_Set(1,:));
        num_in_set_div_4 = round(num_in_set/4);
        if (num_in_set_div_4==(num_in_set/4))
            Alt_Vtx_F1 = [0.1*V1 + 0.9*(0.8*V2 + 0.1*V3 + 0.1*V4);
                          0.1*V1 + 0.9*(0.1*V2 + 0.8*V3 + 0.1*V4);
                          0.1*V1 + 0.9*(0.1*V2 + 0.1*V3 + 0.8*V4)];
            Alt_Vtx_F2 = [0.05*V2 + 0.95*(0.8*V1 + 0.1*V4 + 0.1*V3);
                          0.05*V2 + 0.95*(0.1*V1 + 0.8*V4 + 0.1*V3);
                          0.05*V2 + 0.95*(0.1*V1 + 0.1*V4 + 0.8*V3)];
            Alt_Vtx_F3 = [0.05*V3 + 0.95*(0.8*V1 + 0.1*V2 + 0.1*V4);
                          0.05*V3 + 0.95*(0.1*V1 + 0.8*V2 + 0.1*V4);
                          0.05*V3 + 0.95*(0.1*V1 + 0.1*V2 + 0.8*V4)];
            Alt_Vtx_F4 = [0.05*V4 + 0.95*(0.8*V1 + 0.1*V3 + 0.1*V2);
                          0.05*V4 + 0.95*(0.1*V1 + 0.8*V3 + 0.1*V2);
                          0.05*V4 + 0.95*(0.1*V1 + 0.1*V3 + 0.8*V2)];
            DF_S1 = DoF_Set(1,1:end/4);
            DF_S2 = DoF_Set(1,1+end/4:end/2);
            DF_S3 = DoF_Set(1,1+end/2:(3/4)*end);
            DF_S4 = DoF_Set(1,1+(3/4)*end:end);
            plot_face_DoFs(Alt_Vtx_F1,DF_S1,myMarkerSize,[0.05*V1 + 0.95*((1/3)*V2 + (1/3)*V3 + (1/3)*V4)]);
            plot_face_DoFs(Alt_Vtx_F2,DF_S2,myMarkerSize,[0.05*V2 + 0.95*((1/3)*V1 + (1/3)*V4 + (1/3)*V3)]);
            plot_face_DoFs(Alt_Vtx_F3,DF_S3,myMarkerSize,[0.05*V3 + 0.95*((1/3)*V1 + (1/3)*V2 + (1/3)*V4)]);
            plot_face_DoFs(Alt_Vtx_F4,DF_S4,myMarkerSize,[0.05*V4 + 0.95*((1/3)*V1 + (1/3)*V3 + (1/3)*V2)]);
        else
            plot3(1/4,1/4,1/4,'k.','MarkerSize',myMarkerSize);
        end
        disp(['Tet DoF set #', num2str(td), ':']);
        disp(['T_1 = (V_1, V_2, V_3, V_4): ', num2str(DoF_Set(1,:))]);
        disp(' ');
    end
end
hold off;

end

function plot_face_DoFs(Alt_Vtx,DoF_Set,myMarkerSize,Center_Coord)

num_in_set = length(DoF_Set(:));
num_in_set_div_3 = round(num_in_set/3);
if (num_in_set_div_3==(num_in_set/3))
    t_pts = linspace(0, 1, num_in_set_div_3+2);
    t_pts = t_pts(2:end-1);
    E1_pts = (1 - t_pts)' * Alt_Vtx(2,:) + (t_pts)' * Alt_Vtx(3,:);
    E2_pts = (1 - t_pts)' * Alt_Vtx(3,:) + (t_pts)' * Alt_Vtx(1,:);
    E3_pts = (1 - t_pts)' * Alt_Vtx(1,:) + (t_pts)' * Alt_Vtx(2,:);
    plot3(E1_pts(:,1),E1_pts(:,2),E1_pts(:,3),'k.','MarkerSize',myMarkerSize);
    plot3(E2_pts(:,1),E2_pts(:,2),E2_pts(:,3),'k.','MarkerSize',myMarkerSize);
    plot3(E3_pts(:,1),E3_pts(:,2),E3_pts(:,3),'k.','MarkerSize',myMarkerSize);
else
    plot3(Center_Coord(1),Center_Coord(2),Center_Coord(3),'k.','MarkerSize',myMarkerSize);
end

end