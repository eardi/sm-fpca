function status = test_L1_GeoElement()
%test_L1_GeoElement
%
%   Test code for FELICITY class.

% Copyright (c) 08-01-2011,  Shawn W. Walker

status = 0;

% define some domains
Box   = Domain('tetrahedron');
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;

% define some elements
G_Box   = GeoElement(Box);
G_Omega = GeoElement(Omega,lagrange_deg2_dim2);
G_Sigma = GeoElement(Sigma,lagrange_deg2_dim1);

if ~strcmp(G_Box.Domain.Name,'Box')
    status = 1;
end
if ~strcmp(G_Omega.Domain.Name,'Omega')
    status = 1;
end
if ~strcmp(G_Sigma.Domain.Name,'Sigma')
    status = 1;
end

% if the test makes it here, then everything passed
% most of the checks are done inside the constructor

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end