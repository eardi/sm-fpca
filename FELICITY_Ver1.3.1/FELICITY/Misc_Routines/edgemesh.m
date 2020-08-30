function FH = edgemesh(varargin)
%edgemesh
%
%   This plots data over a 1-D ``edge'' mesh.  This routine is the 1-D version
%   of the MATLAB routine ``trimesh''.
%
%   Usage:
%
%   edgemesh(EDGE,X)
%   edgemesh(EDGE,X,V)
%   edgemesh(EdgeRep_Object)
%
%   displays the edges defined in the M-by-2 edge matrix EDGE as a mesh.  A row
%   of EDGE contains indexes into the rows of the X vertex matrix to define a
%   single line segment (edge).  The size of X is N-by-G, where G = 1, 2, or 3
%   (geometric dimension).  The vertex values are defined by the N-by-1 column
%   vector V.
%
%   Note: for a 3-D edge mesh, the vertex values are plotted in color.
%
%   Example:
%       EDGE = [(1:1:9)', (2:1:10)'];
%       X = linspace(0,1,10)';
%       V = sin(2*pi*X);
%       edgemesh(EDGE,X,V);
%
%   Example:
%       EDGE = [(1:1:9)', (2:1:10)'];
%       t = linspace(0,1,10)';
%       X = [cos(2*pi*t), sin(2*pi*t)];
%       V = t.*exp(0.2*t);
%       edgemesh(EDGE,X,V);
%
%   Example:
%       EDGE = [(1:1:99)', (2:1:100)'];
%       t = linspace(0,1,100)';
%       X = [cos(2*pi*t), sin(2*pi*t), t];
%       V = sin(2*pi*t);
%       edgemesh(EDGE,X,V);

% Copyright (c) 07-16-2012,  Shawn W. Walker

Num_Input = nargin;
if (Num_Input==1)
    ER = varargin{1};
    if isa(ER,'EdgeRep')
        EDGE = ER.Triangulation;
        X_in = ER.X;
        Num_Input = 2;
    else
        error('Single input must be of class EdgeRep!');
    end
elseif (Num_Input > 1)
    EDGE = varargin{1};
    X_in = varargin{2};
end

GD = size(X_in,2);
if (GD==1)
    X = X_in;
    Y = 0*X_in;
    Z = 0*X_in;
elseif (GD==2)
    X = X_in(:,1);
    Y = X_in(:,2);
    Z = 0*X;
elseif (GD==3)
    X = X_in(:,1);
    Y = X_in(:,2);
    Z = X_in(:,3);
else
    error('Geometric dimension must be <= 3!');
end

Xs = [X(EDGE(:,1),1), X(EDGE(:,2),1)]';
Ys = [Y(EDGE(:,1),1), Y(EDGE(:,2),1)]';
Zs = [Z(EDGE(:,1),1), Z(EDGE(:,2),1)]';

if (Num_Input==2)
    if (GD < 3)
        FH = plot(Xs,Ys);
        set(FH,'Color','k');
    elseif (GD==3)
        FH = plot3(Xs,Ys,Zs);
        set(FH,'Color','k');
    end
elseif (Num_Input==3)
    C = varargin{3};
    if (GD==1)
        Cs = [C(EDGE(:,1),1), C(EDGE(:,2),1)]';
        FH = plot(Xs,Cs);
        set(FH,'Color','k');
    elseif (GD==2)
        Cs = [C(EDGE(:,1),1), C(EDGE(:,2),1)]';
        FH = plot3(Xs,Ys,Cs);
        set(FH,'Color','k');
    elseif (GD==3)
        FH = trimesh([EDGE, EDGE(:,2)],X_in(:,1),X_in(:,2),X_in(:,3),C);
    end
else
    error('Invalid number of arguments!');
end

end