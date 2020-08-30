function NV = Num_Vtx(obj)
%Num_Vtx
%
%   Returns the number of vertices in the mesh.
%
%   NV = obj.Num_Vtx;

% Copyright (c) 04-19-2011,  Shawn W. Walker

NV = size(obj.Points,1);

end