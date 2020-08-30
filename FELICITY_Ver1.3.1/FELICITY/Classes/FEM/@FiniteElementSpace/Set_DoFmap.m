function obj = Set_DoFmap(obj,Mesh,DoFmap)
%Set_DoFmap
%
%   This sets the obj.DoFmap field for the finite element (FE) space.  It also does some
%   error checking.
%
%   Note: if the FE space is tuple-valued, the given DoFmap only specifies the DoF layout
%   for the 1st component only!  You do *not* need to specify how DoFs are allocated for
%   the 2nd, 3rd, etc... components; specifying the 1st component is enough.  The DoF
%   layout for the 2nd, 3rd, etc... components can be obtained by simply adding an
%   appropriate constant to the matrix obj.DoFmap.
%
%   obj = obj.Set_DoFmap(Mesh,DoFmap);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   DoFmap = MxC matrix of DoF indices.  Each row of DoFmap corresponds to a
%            mesh element of the subdomain that the FE space is defined on;
%            thus, M = number of mesh elements in the subdomain.  C = number of
%            basis functions on the local reference element for the FE space.

% Copyright (c) 08-04-2014,  Shawn W. Walker

% basic error check on DoFmap consistency
DoFs = unique(DoFmap(:));
Num_Distinct_DoFs = max(DoFs) - (min(DoFs) - 1);
if (length(DoFs)~=Num_Distinct_DoFs)
    err = FELerror;
    err = err.Add_Comment(['The DoFmap must contain *all* indices from 1 to N (inclusive), where']);
    err = err.Add_Comment(['    N = maximum index value in the DoFmap.']);
    err = err.Add_Comment(' ');
    err = err.Add_Comment(['The DoFmap you gave *skips over* some DoF indices.  This is not allowed!']);
    err = err.Add_Comment(' ');
    err = err.Add_Comment(['Here are two common reasons for this problem:']);
    err = err.Add_Comment(['  (1) you used the Mesh.Triangulation connectivity as the DoFmap,']);
    err = err.Add_Comment(['      for a piecewise linear FE space, but the mesh contains vertices']);
    err = err.Add_Comment(['      that are not referenced by the triangulation.']);
    err = err.Add_Comment(['      First, use the method Mesh.Remove_Unused_Vertices to delete any']);
    err = err.Add_Comment(['      vertices that are not referenced by the triangulation.']);
    err = err.Add_Comment(['']);
    err = err.Add_Comment(['  (2) you have a FE space that is defined over a sub-domain that is']);
    err = err.Add_Comment(['      embedded in the global mesh, and (similar to (1)) the DoFmap was']);
    err = err.Add_Comment(['      given by the triangulation connectivity data for the sub-domain.']);
    err = err.Add_Comment(['      In *general*, the Degrees-of-Freedom (DoFs) of a FE space have']);
    err = err.Add_Comment(['      *no relation* to the mesh DoFs.  It just so happens that']);
    err = err.Add_Comment(['      piecewise linear FE space DoFmaps can be defined using the mesh']);
    err = err.Add_Comment(['      connectivity data, but ONLY if the FE space is defined on the']);
    err = err.Add_Comment(['      *global mesh*.']);
    err = err.Add_Comment(['      The best way to fix this is to have FELICITY generate a DoF']);
    err = err.Add_Comment(['      allocation MEX file for your FE space; see the manual or the']);
    err = err.Add_Comment(['      Google-Code page for how to do this.  However, if you are hell-bent']);
    err = err.Add_Comment(['      on simply using the mesh connectivity data, you must use the method:']);
    err = err.Add_Comment(['      Mesh.Output_Subdomain_Mesh to create a stand-alone mesh object (SubMesh),']);
    err = err.Add_Comment(['      then you can use the triangulation connectivity data of SubMesh.']);
    err = err.Add_Comment(['      Of course, this is only possible for piecewise linear FE spaces!']);
    err.Error;
    error('stop!');
end

obj.DoFmap = DoFmap;

obj.Verify_Mesh(Mesh);

end