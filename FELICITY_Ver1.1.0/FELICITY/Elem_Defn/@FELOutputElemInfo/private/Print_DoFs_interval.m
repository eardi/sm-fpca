function FH = Print_DoFs_interval(obj)
%Print_DoFs_interval
%
%   This creates a figure that describes the topological layout of the
%   Degrees-of-Freedom (DoFs) on the reference interval.

% Copyright (c) 05-01-2012,  Shawn W. Walker

FH = figure;

scale = 0;
Color_RGB = [0 0 0];
myMarkerSize = 16;
myLineWidth = 1.3;
Pts = [0 0];
Arrow = [0.5 0];
hold on;
quiver(Pts(:,1),Pts(:,2),Arrow(:,1),Arrow(:,2),scale,'Color',Color_RGB,...
    'MarkerSize',myMarkerSize,'LineWidth',myLineWidth);
plot([0 1],[0 0],'k-','LineWidth',myLineWidth);
text(0.5,-0.04,'E_1');
text(0.02,0.04,'V_1');
text(0.95,0.04,'V_2');
hold off;
AX = [-0.001 1.001 -0.901 0.101];
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

obj.Print_DoF_Indices_Msg;

hold on;
% plot the vertex DoFs, and display them at the MATLAB window
for vd = 1:length(Vtx_DoFs)
    DoF_Set = Vtx_DoFs{vd};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=2)
            error('There should be 2 vertices for an interval.');
        end
        plot([0 1],[0 0],'k.','MarkerSize',myMarkerSize);
        disp(['Vertex DoF set #', num2str(vd), ':']);
        V1_str = ['V_1 = (0): ', num2str(DoF_Set(1,:))];
        V2_str = ['V_2 = (1): ', num2str(DoF_Set(2,:))];
        disp(V1_str);
        disp(V2_str);
        disp(' ');
    end
end

% plot the (interior) edge DoFs
for ed = 1:length(Edge_DoFs)
    DoF_Set = Edge_DoFs{ed};
    if ~isempty(DoF_Set)
        if (size(DoF_Set,1)~=1)
            error('There should be 1 edge for an interval.');
        end
        X_pts = linspace(0, 1, length(DoF_Set(1,:))+2);
        X_pts = X_pts(2:end-1);
        Y_pts = 0*X_pts;
        plot(X_pts,Y_pts,'k.','MarkerSize',myMarkerSize);
        disp(['Edge DoF set #', num2str(ed), ':']);
        E1_str = ['E_1 = (V_1, V_2): ', num2str(DoF_Set(1,:))];
        disp(E1_str);
        disp(' ');
    end
end
hold off;

end