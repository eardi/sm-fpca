function FH = Print_DoFs_triangle(obj)
%Print_DoFs_triangle
%
%   This creates a figure that describes the topological layout of the
%   Degrees-of-Freedom (DoFs) on the reference triangle.

% Copyright (c) 05-01-2012,  Shawn W. Walker

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
Vtx_DoFs = obj.Elem.Nodal_Top.V;
Edge_DoFs = obj.Elem.Nodal_Top.E;
Face_DoFs = obj.Elem.Nodal_Top.F;

obj.Print_DoF_Indices_Msg;

hold on;
% plot the vertex DoFs, and display them at the MATLAB window
for vd = 1:length(Vtx_DoFs)
    DoF_Set = Vtx_DoFs{vd};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=3)
            error('There should be 3 vertices for a triangle.');
        end
        plot(Vtx(:,1),Vtx(:,2),'k.','MarkerSize',myMarkerSize);
        disp(['Vertex DoF set #', num2str(vd), ':']);
        V1_str = ['V_1 = (0,0): ', num2str(DoF_Set(1,:))];
        V2_str = ['V_2 = (1,0): ', num2str(DoF_Set(2,:))];
        V3_str = ['V_3 = (0,1): ', num2str(DoF_Set(3,:))];
        disp(V1_str);
        disp(V2_str);
        disp(V3_str);
        disp(' ');
    end
end

% plot the edge DoFs
for ed = 1:length(Edge_DoFs)
    DoF_Set = Edge_DoFs{ed};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=3)
            error('There should be 3 edges for a triangle.');
        end
        t_pts = linspace(0, 1, length(DoF_Set(1,:))+2);
        t_pts = t_pts(2:end-1);
        E1_pts = (1 - t_pts)' * Vtx(2,:) + (t_pts)' * Vtx(3,:);
        E2_pts = (1 - t_pts)' * Vtx(3,:) + (t_pts)' * Vtx(1,:);
        E3_pts = (1 - t_pts)' * Vtx(1,:) + (t_pts)' * Vtx(2,:);
        plot(E1_pts(:,1),E1_pts(:,2),'k.','MarkerSize',myMarkerSize);
        plot(E2_pts(:,1),E2_pts(:,2),'k.','MarkerSize',myMarkerSize);
        plot(E3_pts(:,1),E3_pts(:,2),'k.','MarkerSize',myMarkerSize);
        disp(['Edge DoF set #', num2str(ed), ':']);
        disp(['E_1 = (V_2, V_3): ', num2str(DoF_Set(1,:))]);
        disp(['E_2 = (V_3, V_1): ', num2str(DoF_Set(2,:))]);
        disp(['E_3 = (V_1, V_2): ', num2str(DoF_Set(3,:))]);
        disp(' ');
    end
end

% plot the (internal) face DoFs
for fd = 1:length(Face_DoFs)
    DoF_Set = Face_DoFs{fd};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=1)
            error('There should be 1 face for a triangle.');
        end
        num_in_set = length(DoF_Set(1,:));
        num_in_set_div_3 = round(num_in_set/3);
        if (num_in_set_div_3==(num_in_set/3))
            t_pts = linspace(0, 1, num_in_set_div_3+2);
            t_pts = t_pts(2:end-1);
            Alt_Vtx = [0.1 0.1; 0.74 0.1; 0.1 0.74];
            E1_pts = (1 - t_pts)' * Alt_Vtx(2,:) + (t_pts)' * Alt_Vtx(3,:);
            E2_pts = (1 - t_pts)' * Alt_Vtx(3,:) + (t_pts)' * Alt_Vtx(1,:);
            E3_pts = (1 - t_pts)' * Alt_Vtx(1,:) + (t_pts)' * Alt_Vtx(2,:);
            plot(E1_pts(:,1),E1_pts(:,2),'k.','MarkerSize',myMarkerSize);
            plot(E2_pts(:,1),E2_pts(:,2),'k.','MarkerSize',myMarkerSize);
            plot(E3_pts(:,1),E3_pts(:,2),'k.','MarkerSize',myMarkerSize);
        else
            plot(1/3,1/3,'k.','MarkerSize',myMarkerSize);
        end
        disp(['Face DoF set #', num2str(fd), ':']);
        disp(['F_1 = (V_1, V_2, V_3): ', num2str(DoF_Set(1,:))]);
        disp(' ');
    end
end
hold off;

end