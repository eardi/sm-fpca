function status = test_L1_GeoFunc()
%test_L1_GeoFunc
%
%   Test code for FELICITY class.

% Copyright (c) 08-17-2014,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define a geometric function
f = GeoFunc(Omega);
g = GeoFunc(Sigma);

% check domains
if ~strcmp(f.Name,['geom', 'Omega'])
    status = 1;
end
if ~strcmp(f.Domain.Name,'Omega')
    status = 1;
end
if ~strcmp(g.Name,['geom', 'Sigma'])
    status = 1;
end
if ~strcmp(g.Domain.Name,'Sigma')
    status = 1;
end

% check function operators
if ~(f.X(2)==sym('geomOmega_X2'))
    status = 1;
end
if ~(f.deriv_X(1,2)==sym('geomOmega_X1_deriv2'))
    status = 1;
end
if ~(g.Tangent_Space_Proj(1,2)==sym('geomSigma_TSP_12'))
    status = 1;
end
if ~(g.T(2)==sym('geomSigma_T2'))
    status = 1;
end
if ~(g.N(1)==sym('geomSigma_N1'))
    status = 1;
end
if ~(g.VecKappa(1)==sym('geomSigma_VecKappa1'))
    status = 1;
end
if ~(g.Kappa==sym('geomSigma_Total_Kappa'))
    status = 1;
end
if ~(g.Kappa_Gauss==sym('geomSigma_Gauss_Kappa'))
    status = 1;
end
if (length(g.N)~=2)
    status = 1;
end
if (length(g.VecKappa)~=2)
    status = 1;
end
if ~(g.Shape_Op(2,1)==sym('geomSigma_Shape_Op_21'))
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end