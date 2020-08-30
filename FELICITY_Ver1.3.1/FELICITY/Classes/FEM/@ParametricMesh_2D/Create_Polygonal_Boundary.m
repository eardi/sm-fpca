function [PL, Chart_Marker, Chart_Var] = Create_Polygonal_Boundary(obj,Num_Poly_Pts)
%Create_Polygonal_Boundary
%
%   This returns an array of vertices that defines a fine sampling of the
%   domain's boundary.
%
%   [PL, Chart_Marker, Chart_Var] = obj.Create_Polygonal_Boundary(Num_Poly_Pts);
%
%   Num_Poly_Pts = Number of points to use in the polygonal boundary (will
%                  actually be slightly more than this).
%
%   PL = Mx2 matrix of point coordinates, where M > Num_Poly_Pts.
%   Chart_Marker = Mx1 matrix of positive integer values; the value
%                  indicates which chart the point comes from.
%   Chart_Var    = Mx1 matrix of real numbers which represent the local
%                  chart domain variable value for that point.

% Copyright (c) 08-08-2019,  Shawn W. Walker

Num_Charts = length(obj.Chart_Funcs);

% estimate a reasonable number of points per segment
Num_Pts = round(Num_Poly_Pts/Num_Charts) + 1;

% init
X_Pts = zeros(Num_Pts-1,Num_Charts);
Y_Pts = zeros(Num_Pts-1,Num_Charts);
Chart_Marker = 0*X_Pts;
Chart_Var = 0*X_Pts;
for ii = 1:Num_Charts
    ai = obj.Chart_Domains(ii,1);
    bi = obj.Chart_Domains(ii,2);
    tv = linspace(ai,bi,Num_Pts)';
    tv(end) = []; % avoid overlap
    Pts_ch = obj.Chart_Funcs{ii}(tv);
    X_Pts(:,ii) = Pts_ch(:,1);
    Y_Pts(:,ii) = Pts_ch(:,2);
    Chart_Marker(:,ii) = ii;
    Chart_Var(:,ii) = tv;
end

% concatenate them together
PL = [X_Pts(:), Y_Pts(:)];
Chart_Marker = Chart_Marker(:);
Chart_Var = Chart_Var(:);

end