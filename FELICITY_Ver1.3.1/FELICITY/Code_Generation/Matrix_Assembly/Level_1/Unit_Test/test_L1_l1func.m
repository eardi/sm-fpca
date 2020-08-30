function status = test_L1_l1func()
%test_L1_l1func
%
%   Test code for FELICITY class.

% Copyright (c) 08-15-2014,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define FEM spaces
V1 = Element(Omega,lagrange_deg1_dim2,1);
H1 = Element(Sigma,lagrange_deg1_dim1,2);

% only need to test Coef, because everything is inherited from l1func
f = Coef(V1);
g = Coef(H1);
w = Coef(V1,Sigma);

if ~strcmp(f.Element.Name,'V1')
    status = 1;
end
if ~strcmp(g.Element.Name,'H1')
    status = 1;
end
if ~strcmp(w.Domain.Name,'Sigma')
    status = 1;
end

if ~(f.val==sym('f_v1_t1'))
    status = 1;
end
if ~(f.grad(2)==sym('f_v1_t1_grad2'))
    status = 1;
end
if ~(f.hess(2,1)==sym('f_v1_t1_hess21'))
    status = 1;
end
if ~(g.val(1)==sym('g_v1_t1'))
    status = 1;
end
if ~(g.grad(1,2)==sym('g_v1_t1_grad2'))
    status = 1;
end
if ~(g.ds(2)==sym('g_v1_t2_ds'))
    status = 1;
end
if ~(g.dsds(1)==sym('g_v1_t1_dsds'))
    status = 1;
end
if ~(g.hess(1,1,2)==sym('g_v1_t2_hess11'))
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end