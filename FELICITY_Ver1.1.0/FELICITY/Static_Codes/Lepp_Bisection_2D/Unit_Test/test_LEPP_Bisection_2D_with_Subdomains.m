function status = test_LEPP_Bisection_2D_with_Subdomains()
%test_LEPP_Bisection_2D_with_Subdomains
%
%   Test code for FELICITY class.

% Copyright (c) 09-12-2011,  Shawn W. Walker

% define single triangle mesh
Vtx = [0 0; 1 0; 0 1];
Tri = uint32([1 2 3]);
Neighbor = uint32([0 0 0]);

% init
New_Vtx = Vtx;
New_Tri = Tri;
New_Neighbor = Neighbor;

% define two simple sub-domains
SUB.Name = 'corners';
SUB.Dim  = 0;
SUB.Data = int32([1, 2; 1, 3]);
%%%%
SUB(2).Name = 'edge';
SUB(2).Dim  = 1;
SUB(2).Data = int32([1, -1]);

Marked = uint32([1]);
NEW_MESH = {New_Vtx, New_Tri};
New_SUB = SUB;
%tic
[NEW_MESH, New_Neighbor, New_SUB] = mexLEPP_Bisection_2D(NEW_MESH, New_Neighbor, Marked, New_SUB);
%toc

%%% add a 2-D subdomain...
New_SUB(3).Name = 'bottom';
New_SUB(3).Dim  = 2;
New_SUB(3).Data = int32([2]);

Marked = uint32([1; 2]);
tic
[NEW_MESH, New_Neighbor, New_SUB] = mexLEPP_Bisection_2D(NEW_MESH, New_Neighbor, Marked, New_SUB);
toc
New_Vtx = NEW_MESH{1};
New_Tri = NEW_MESH{2};

% BEGIN: regression testing
status = 0; % init

% reference data
REF_Vtx = [              0                         0;
    1.000000000000000e+000                         0;
                         0    1.000000000000000e+000;
    5.000000000000000e-001    5.000000000000000e-001;
    5.000000000000000e-001                         0;
                         0    5.000000000000000e-001];
REF_Tri = uint32([6           1           4;
                  5           2           4;
                  5           4           1;
                  6           4           3]);
REF_Neighbor = uint32([3           4           0;
                       0           3           0;
                       1           0           2;
                       0           0           1]);
REF_SUB.Name = 'corners';
REF_SUB.Dim  = 0;
REF_SUB.Data = int32([2           2;
                      4           3]);
REF_SUB(2).Name = 'edge';
REF_SUB(2).Dim  = 1;
REF_SUB(2).Data = int32([2        -1;
                         4        -1]);
REF_SUB(3).Name = 'bottom';
REF_SUB(3).Dim  = 2;
REF_SUB(3).Data = int32([2;3]);

% run regression test
Vtx_ERR = abs(REF_Vtx - New_Vtx);
Vtx_ERR = max(Vtx_ERR(:));
if Vtx_ERR > 1e-15
    disp('Vertices do not match!  See ''test_LEPP_Bisection_2D_with_Subdomains''.');
    status = 1;
end
Tri_ERR = (REF_Tri == New_Tri);
if (min(Tri_ERR(:))==0)
    disp('Triangle data does not match!  See ''test_LEPP_Bisection_2D_with_Subdomains''.');
    status = 1;
end
Nb_ERR = (REF_Neighbor == New_Neighbor);
if (min(Nb_ERR(:))==0)
    disp('Neighbor data does not match!  See ''test_LEPP_Bisection_2D_with_Subdomains''.');
    status = 1;
end
BAD_SUB = ~and(isequal(REF_SUB(1),New_SUB(1)),and(isequal(REF_SUB(2),New_SUB(2)),isequal(REF_SUB(3),New_SUB(3))));
if BAD_SUB
    disp('Subdomain data does not match!  See ''test_LEPP_Bisection_2D_with_Subdomains''.');
    status = 1;
end
% END: regression testing

end