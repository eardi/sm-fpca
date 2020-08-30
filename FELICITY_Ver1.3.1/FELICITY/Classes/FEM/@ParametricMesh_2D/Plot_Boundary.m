function P1 = Plot_Boundary(obj,Num_Bdy_Pts)
%Plot_Boundary
%
%   This returns a figure handle to a plot of the piecewise boundary.
%
%   FH = obj.Plot_Boundary();
%
%   FH = obj.Plot_Boundary(Num_Bdy_Pts);
%
%   Num_Bdy_Pts = number of points to use (approximately) in plotting the
%                 boundary.

% Copyright (c) 08-08-2019,  Shawn W. Walker

if (nargin==1)
    Num_Bdy_Pts = 1e4; % default
end

% estimate a reasonable number of points per segment
PL = Create_Polygonal_Boundary(obj,Num_Bdy_Pts);

% add in final point for closed curve
PL = [PL; PL(1,:)];

title(['Domain: ', obj.Name]);
P1 = plot(PL(:,1),PL(:,2),'b-','LineWidth',1.2);
hold on;
plot(obj.Corners(:,1),obj.Corners(:,2),'k.','MarkerSize',20);
hold off;
grid on;
axis equal;

end