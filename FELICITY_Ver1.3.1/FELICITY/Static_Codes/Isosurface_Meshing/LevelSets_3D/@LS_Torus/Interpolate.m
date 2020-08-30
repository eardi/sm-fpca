function [Val, Grad, Hess] = Interpolate(obj,X,SN)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-03-2012,  Shawn W. Walker

if (nargin==2)
    SN = 1;
end

x0 = obj.Param.x0;
r1 = obj.Param.r1;
d1 = obj.Param.d1;

if (d1 <= r1)
    error('Not allowed!');
end

% shift the coordinates
SX = X;
SX(:,1) = SX(:,1) - x0(1);
SX(:,2) = SX(:,2) - x0(2);
SX(:,3) = SX(:,3) - x0(3);

% next rotate the coordinates
ROT     = obj.rotation_matrix;
ROT_inv = inv(ROT);
RotSX   = SX * ROT_inv;
% RotSX = X;

% compute planar coordinates (mapped)
new_x = sqrt( RotSX(:,1).^2 + RotSX(:,2).^2 );
new_z = RotSX(:,3);

% get distance function over 2-D x-z plane
c1x = d1;
c1z = 0;
NORM = sqrt((new_x - c1x).^2 + (new_z - c1z).^2);
Val = SN * (r1 - NORM);

Planar_Grad_x = - (new_x - c1x) ./ NORM;
Planar_Grad_z = - (new_z - c1z) ./ NORM;

% map back
%Grad = zeros(length(Val),3);
Grad = [0*Val, 0*Val, 0*Val];
THETA = atan2(RotSX(:,2), RotSX(:,1));
Grad(:,1) = cos(THETA) .* Planar_Grad_x;
Grad(:,2) = sin(THETA) .* Planar_Grad_x;
Grad(:,3) = Planar_Grad_z;

% rotate back!
Grad = SN * Grad * ROT;

% just set it to the identity
DIM = 3;
Hess = cell(DIM,DIM);

for kk=1:DIM
    for ll=1:DIM
        if kk==ll
            identity_kl = 1;
        else
            identity_kl = 0;
        end
        Hess{kk,ll} = SN*(zeros(size(X,1),1) + identity_kl);
    end
end

end