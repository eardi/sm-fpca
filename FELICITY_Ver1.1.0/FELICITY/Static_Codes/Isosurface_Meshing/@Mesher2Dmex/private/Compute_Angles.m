function A = Compute_Angles(p,t)
%Compute_Angles
%
%   2-D Mesh: A = Tx3 matrix, where each row contains the 3 interior
%                 angles of a single triangle in the mesh.  The angles are
%                 ordered with respect to the (local) vertex index.
%   Angles are given in radians!

% Copyright (c) 10-13-2011,  Shawn W. Walker

X2_X1 = p(t(:,2),:) - p(t(:,1),:);
X3_X1 = p(t(:,3),:) - p(t(:,1),:);
X3_X2 = p(t(:,3),:) - p(t(:,2),:);
X2_X1 = normalize(X2_X1);
X3_X1 = normalize(X3_X1);
X3_X2 = normalize(X3_X2);
theta_1 = acos( dot(X2_X1,X3_X1,2)   );
theta_2 = acos( dot(X3_X2,-X2_X1,2)  );
theta_3 = acos( dot(-X3_X1,-X3_X2,2) );
A = [theta_1, theta_2, theta_3];

end

function V = normalize(V)

V_norm = sqrt(sum(V.^2,2));

for ind=1:size(V,2)
    V(:,ind) = V(:,ind) ./ V_norm;
end

end