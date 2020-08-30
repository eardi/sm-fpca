function [TET, VTX] = run_mex(obj,Interp_Func,Include_Ambiguous_Tet)
%run_mex
%
%    Generate conforming tetrahedral mesh of the interior of a given isosurface.
%    Note: this runs the C++ part of the code (for speed!).
%
%    [TET, VTX] = obj.run_mex(LS,Include_Ambiguous_Tet);
%
%    Interp_Func = function handle to interpolation routine.
%           The format of "Interp_Func" should be:
%                  [phi, grad_phi] = Interp_Func(point);
%                  where
%                  phi      = the level set function value
%                  grad_phi = the gradient of the level set function
%                  point    = array of point coordinate to evaluate at
%    Include_Ambiguous_Tet = true/false: decide whether to include ambiguous elements into
%                            the interior mesh.  An element is ambiguous if all its
%                            vertices lie on the isosurface.
%
%    TET, VTX = tetrahedron connectivity and vertex coordinates (i.e. the conforming mesh).

% Copyright (c) 12-20-2011,  Shawn W. Walker

if (nargin < 3)
    Include_Ambiguous_Tet = false;
end
if ~islogical(Include_Ambiguous_Tet)
    error('Input must be true or false!');
end

[TET, VTX, In_MSK, AMB_indices] = mexMeshGen_3D(obj.bcc_mesh,obj.cut_info,obj.LS.value);
% this assumes (so far) that any ambiguous tets are outside!

% T0 = clock;
% if there are ambiguous tets and we *maybe* want to include them, then
if and(~isempty(AMB_indices),Include_Ambiguous_Tet)
    MIN_ANGLE_CUTOFF = 11.4 * (pi/180);
    MAX_ANGLE_CUTOFF = 157.6 * (pi/180);
    % compute worst case angles for ambiguous tets!
    A = Compute_Dihedral_Angles(VTX,TET(AMB_indices,:));
    Min_Angle = min(A,[],2);
    Max_Angle = max(A,[],2);
    Amb_To_Exclude = (Min_Angle < MIN_ANGLE_CUTOFF) | (Max_Angle > MAX_ANGLE_CUTOFF);
    %Amb_Indices_to_Exclude = AMB_indices(Amb_To_Exclude); % any ambiguous tets
    % are assumed to be outside already!
    
    Amb_Indices_to_Possibly_Include = AMB_indices(~Amb_To_Exclude);
    if ~isempty(Amb_Indices_to_Possibly_Include)
        % then do heuristic check!
        % compute centroid of these candidate tets
        Centers = Compute_Centroid(VTX,TET(Amb_Indices_to_Possibly_Include,:));
        % interpolate level set at centroid
        LS_Value = Interp_Func(Centers);
        Amb_Indices_to_Include = Amb_Indices_to_Possibly_Include(LS_Value >= 0);
        if ~isempty(Amb_Indices_to_Include)
            disp('Some ambiguous tetrahedra are included in the interior mesh.');
            In_MSK(Amb_Indices_to_Include,1) = true;
        end
    end
end
% T1 = clock;
% disp(['Step (8+) Timing: ', num2str(etime(T1,T0),'%2.5G'), ' sec']);

TET = TET(In_MSK,:);

end