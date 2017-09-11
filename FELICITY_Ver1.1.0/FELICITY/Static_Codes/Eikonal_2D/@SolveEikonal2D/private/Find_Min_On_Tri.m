function u_x = Find_Min_On_Tri(x,y,z,u_y,u_z)
%Find_Min_On_Tri
%
%   Simple routine to get min (Hopf-Lax update) on one of the triangles in the star.

% Copyright (c) 07-01-2009,  Shawn W. Walker

% get z-y length
z_y_vec    = z - y;
z_y_len    = sqrt(z_y_vec(1)^2 + z_y_vec(2)^2);

% compute delta
Delta = (u_z - u_y) / z_y_len;

% get x-y length
x_y_vec    = x - y;
x_y_len    = sqrt(x_y_vec(1)^2 + x_y_vec(2)^2);

if Delta >= 1
    % x-y length
    u_x = u_y + x_y_len;
    return;
end

% get z-x length
z_x_vec    = z - x;
z_x_len    = sqrt(z_x_vec(1)^2 + z_x_vec(2)^2);

if Delta <= -1
    % x-y length
    u_x = u_z + z_x_len;
    return;
end

% get cos(alpha)
cos_alpha = (x_y_vec(1)*z_y_vec(1) + x_y_vec(2)*z_y_vec(2)) / (x_y_len * z_y_len);

% get cos(beta)
cos_beta = (z_x_vec(1)*z_y_vec(1) + z_x_vec(2)*z_y_vec(2)) / (z_x_len * z_y_len);

if (Delta >= cos_alpha)
    u_x = u_y + x_y_len;
elseif (Delta <= -cos_beta)
    u_x = u_z + z_x_len;
else
    u_x = u_y + ( cos_alpha*Delta + sqrt((1 - cos_alpha^2)*(1 - Delta^2)) ) * x_y_len;
end

% END %