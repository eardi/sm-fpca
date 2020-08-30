function status = test_L1_FEL_Interpolations()
%test_L1_FEL_Interpolations
%
%   Test code for FELICITY class.

% Copyright (c) 01-25-2013,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define FEM spaces
W1 = Element(Omega,lagrange_deg1_dim2,2);
V1 = Element(Sigma,lagrange_deg1_dim1,2);

f = Coef(W1);
h = Coef(V1);

gf = GeoFunc(Sigma);

% just test interpolate
I_f = Interpolate(Omega,f.val);
I_h = Interpolate(Sigma,h.val' * gf.T);

% define a set of interpolations to perform
G1 = GeoElement(Omega);
INTERP = Interpolations(G1);
% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_f);
INTERP = INTERP.Append_Interpolation(I_h);

if ~strcmp(INTERP.GeoElem.Name,'G1')
    status = 1;
end
I_f.Name = 'I_f';
if ~isequal(INTERP.Interp_Expr{1},I_f)
    status = 1;
end
I_h.Name = 'I_h';
if ~isequal(INTERP.Interp_Expr{2},I_h)
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end