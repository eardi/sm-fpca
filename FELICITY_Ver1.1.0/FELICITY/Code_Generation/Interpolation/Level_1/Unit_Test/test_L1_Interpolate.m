function status = test_L1_Interpolate()
%test_L1_Interpolate
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

if ~strcmp(I_f.CoefF.Name,'f')
    status = 1;
end
if ~strcmp(I_h.CoefF.Name,'h')
    status = 1;
end

if ~(I_f.Expression==sym('[f_v1_t1; f_v1_t2]'))
    status = 1;
end
if ~(I_h.Expression==sym('[geomSigma_T1*h_v1_t1 + geomSigma_T2*h_v1_t2]'))
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