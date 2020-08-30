function New_X = FEL_Mesh_Smooth(Old_X,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps)
%FEL_Mesh_Smooth
%
%   This runs a Gauss-Seidel iterative ODT smoother (multiple times) on mesh
%   vertex positions.  It works on 1-D, 2-D, and 3-D simplicial meshes.
%
%   New_X = FEL_Mesh_Smooth(Old_X,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);
%
%   Old_X = array of vertex coordinates (before smoothing).
%   Elem  = mesh (triangulation) connectivity data.
%   Vtx_Attach = output of calling TR.vertexAttachments, where TR is a TriRep
%                object created from Elem and Old_X.
%   Vtx_Indices_To_Update = column vector of vertex indices indicating which
%                           vertices to actually update.
%   Num_Sweeps = number of times to iterate through the list:
%                Vtx_Indices_To_Update.
%
%   New_X = array of vertex coordinates (after smoothing).

% Copyright (c) 04-16-2013,  Shawn W. Walker

New_X = mexFELICITY_Mesh_Smooth({Old_X, uint32(Elem)},Vtx_Attach,uint32(Vtx_Indices_To_Update),Num_Sweeps);

end