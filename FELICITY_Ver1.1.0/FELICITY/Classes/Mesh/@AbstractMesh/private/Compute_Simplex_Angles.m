function A = Compute_Simplex_Angles(p,t)
%Compute_Simplex_Angles
%
%   This computes the internal element angles.
%
%   A = Compute_Simplex_Angles(p,t);
%
%   p = vertices of triangulation.
%   t = triangulation connectivity.
%
%   1-D Mesh: A = [] (case not valid).
%   2-D Mesh: A = Tx3 matrix, where each row contains the 3 interior angles of
%                 a single triangle in the mesh.  The angles are ordered with
%                 respect to the (local) opposite edge index.
%   3-D Mesh: A = Tx6 matrix, where each row contains the 6 interior dihedral
%                 angles of a single tetrahedron in the mesh.  The angles are
%                 ordered with respect to the (local) edge index.
%   Angles are given in radians!

% Copyright (c) 10-13-2011,  Shawn W. Walker

Top_Dim = size(t,2)-1;
%Geo_Dim = size(p,2);

switch Top_Dim
    case 1
        disp('A 1-D mesh has no interior angles!');
        A = [];
    case 2
        X2_X1 = p(t(:,2),:) - p(t(:,1),:);
        X3_X1 = p(t(:,3),:) - p(t(:,1),:);
        X3_X2 = p(t(:,3),:) - p(t(:,2),:);
        norm_X2_X1 = sqrt(sum(X2_X1.^2,2));
        norm_X3_X1 = sqrt(sum(X3_X1.^2,2));
        norm_X3_X2 = sqrt(sum(X3_X2.^2,2));
        theta_1 = acos(dot(X2_X1,X3_X1,2)   ./ (norm_X2_X1.*norm_X3_X1));
        theta_2 = acos(dot(X3_X2,-X2_X1,2)  ./ (norm_X3_X2.*norm_X2_X1));
        theta_3 = acos(dot(-X3_X1,-X3_X2,2) ./ (norm_X3_X1.*norm_X3_X2));
        A = [theta_1, theta_2, theta_3];
    case 3
        % compute normal vector of each face
        e_1 = p(t(:,2),:) - p(t(:,1),:);
        e_2 = p(t(:,3),:) - p(t(:,1),:);
        e_3 = p(t(:,4),:) - p(t(:,1),:);
        e_4 = p(t(:,3),:) - p(t(:,2),:);
        e_6 = p(t(:,2),:) - p(t(:,4),:);
        N_1 = cross(e_4,e_6); % e_4 X e_6
        N_1 = normalize(N_1);
        N_2 = cross(e_2,e_3); % e_2 X e_3
        N_2 = normalize(N_2);
        N_3 = cross(e_3,e_1); % e_3 X e_1
        N_3 = normalize(N_3);
        N_4 = cross(e_1,e_2); % e_1 X e_2
        N_4 = normalize(N_4);
        theta_1 = acos(-dot(N_3,N_4,2));
        theta_2 = acos(-dot(N_2,N_4,2));
        theta_3 = acos(-dot(N_2,N_3,2));
        theta_4 = acos(-dot(N_1,N_4,2));
        theta_5 = acos(-dot(N_1,N_2,2));
        theta_6 = acos(-dot(N_1,N_3,2));
        A = [theta_1, theta_2, theta_3, theta_4, theta_5, theta_6];
    otherwise
        error('Dimension not implemented.');
end

end

function V = normalize(V)

V_norm = sqrt(sum(V.^2,2));

for ind=1:size(V,2)
    V(:,ind) = V(:,ind) ./ V_norm;
end

end