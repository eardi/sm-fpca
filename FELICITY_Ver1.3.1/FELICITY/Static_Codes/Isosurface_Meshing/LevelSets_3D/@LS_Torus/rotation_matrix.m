function ROT = rotation_matrix(obj)
%rotation_matrix
%
%    This is the rotation matrix.

% Copyright (c) 01-03-2012,  Shawn W. Walker

phi   = obj.Param.phi;
theta = obj.Param.theta;
psi   = obj.Param.psi;

% evaluate rotation matrix
ROT = [cos(theta)*cos(psi), (-cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi)), (sin(phi)*sin(psi) + cos(phi)*sin(theta)*cos(psi));
       cos(theta)*sin(psi), ( cos(phi)*cos(psi) + sin(phi)*sin(theta)*sin(psi)), (-sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi));
       -sin(theta),         sin(phi)*cos(theta),                                   cos(phi)*cos(theta)  ];
%

end