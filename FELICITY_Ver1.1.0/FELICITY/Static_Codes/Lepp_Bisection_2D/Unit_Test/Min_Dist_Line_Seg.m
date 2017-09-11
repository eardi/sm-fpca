function DIST = Min_Dist_Line_Seg(X,VA,VB)
%Min_Dist_Line_Seg
%
%   VA, VB are just two pairs of points (not vectorized).

% Copyright (c) 03-28-2011,  Shawn W. Walker

B_minus_A = VB - VA;

X_minus_A = [X(:,1) - VA(1,1), X(:,2) - VA(1,2)];

X_minus_A_dot_B_minus_A = X_minus_A(:,1)*B_minus_A(1,1) + X_minus_A(:,2)*B_minus_A(1,2);

t_vec = X_minus_A_dot_B_minus_A / dot(B_minus_A,B_minus_A,2);

mask_t_greater_1 = t_vec > 1;
mask_t_less_0    = t_vec < 0;
mask_t_middle    = ~(mask_t_greater_1 | mask_t_less_0);

DIST = 0*X(:,1);
DIST(mask_t_greater_1,1) = sqrt((X(mask_t_greater_1,1) - VB(1,1)).^2 + (X(mask_t_greater_1,2) - VB(1,2)).^2);
DIST(mask_t_less_0,1) = sqrt((X(mask_t_less_0,1) - VA(1,1)).^2 + (X(mask_t_less_0,2) - VA(1,2)).^2);

P = 0*X;
P(:,1) = (1 - t_vec)*VA(1,1) + t_vec*VB(1,1);
P(:,2) = (1 - t_vec)*VA(1,2) + t_vec*VB(1,2);

TEMP_D = sqrt(dot(P - X,P - X,2));

DIST(mask_t_middle,1) = TEMP_D(mask_t_middle,1);

end