function status = test_L1_Element()
%test_L1_Element
%
%   Test code for FELICITY class.

% Copyright (c) 08-01-2011,  Shawn W. Walker

status = 0;

% define some domains
Box   = Domain('tetrahedron');
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;

% define some elements
CONST = Element(Sigma);
M = Element(Box,lagrange_deg1_dim3,3);
U = Element(Omega,lagrange_deg2_dim2,1);
V = Element(Sigma,lagrange_deg1_dim1,2);

% if the test makes it here, then everything passed
% most of the checks are done inside the constructor

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end