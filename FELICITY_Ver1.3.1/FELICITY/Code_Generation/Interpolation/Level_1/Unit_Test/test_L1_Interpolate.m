function status = test_L1_Interpolate()
%test_L1_Interpolate
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2016,  Shawn W. Walker

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

if ~strcmp(I_f.CoefF.Name,'f')
    status = 1;
end
if ~strcmp(I_h.CoefF.Name,'h')
    status = 1;
end

f1 = sym('f_v1_t1');
f2 = sym('f_v1_t2');
I_f_test = [f1;f2];
if ~isequal(I_f.Expression,I_f_test)
    status = 1;
end

g1 = sym('geomSigma_T1');
g2 = sym('geomSigma_T2');
h1 = sym('h_v1_t1');
h2 = sym('h_v1_t2');
I_h_test = g1*h1 + g2*h2;
if ~isequal(I_h.Expression,I_h_test)
    status = 1;
end

if ~strcmp(I_f.Domain.Name,'Omega')
    status = 1;
end
if ~isempty(I_f.Domain.Subset_Of)
    status = 1;
end

if ~strcmp(I_h.Domain.Name,'Sigma')
    status = 1;
end
if ~strcmp(I_h.Domain.Subset_Of,'Omega')
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end