function [TRI, VTX] = run_mex(obj,Interp_Func,Include_Ambiguous_Tri)
%run_mex
%
%    Generate conforming triangle mesh of the interior of a given isocontour.
%    Note: this runs the C++ part of the code (for speed!).
%
%    [TRI, VTX] = obj.run_mex(Interp_Func,Include_Ambiguous_Tri);
%
%    Interp_Func = function handle to interpolation routine.
%           The format of "Interp_Func" should be:
%                  [phi, grad_phi] = Interp_Func(point);
%                  where
%                  phi      = the level set function value
%                  grad_phi = the gradient of the level set function
%                  point    = array of point coordinate to evaluate at
%    Include_Ambiguous_Tri = true/false: decide whether to include ambiguous elements into
%                            the interior mesh.  An element is ambiguous if all its
%                            vertices lie on the isocontour.
%
%    TRI, VTX = triangle connectivity and vertex coordinates (i.e. the conforming mesh).

% Copyright (c) 04-04-2012,  Shawn W. Walker

if (nargin < 3)
    Include_Ambiguous_Tri = false;
end
if ~islogical(Include_Ambiguous_Tri)
    error('Input must be true or false!');
end

[TRI, VTX, In_MSK, AMB_indices] = mexMeshGen_2D(obj.bcc_mesh,obj.cut_info,obj.LS.value);
% this assumes (so far) that any ambiguous tri's are outside!

% T0 = clock;
% if there are ambiguous triangles and we *maybe* want to include them, then
if and(~isempty(AMB_indices),Include_Ambiguous_Tri)
    MIN_ANGLE_CUTOFF = 12.0 * (pi/180);
    MAX_ANGLE_CUTOFF = 150.0 * (pi/180);
    % compute worst case angles for ambiguous triangles!
    A = Compute_Angles(VTX,TRI(AMB_indices,:));
    Min_Angle = min(A,[],2);
    Max_Angle = max(A,[],2);
    Amb_To_Exclude = (Min_Angle < MIN_ANGLE_CUTOFF) | (Max_Angle > MAX_ANGLE_CUTOFF);
    %Amb_Indices_to_Exclude = AMB_indices(Amb_To_Exclude); % any ambiguous triangles
    % are assumed to be outside already!
    
    Amb_Indices_to_Possibly_Include = AMB_indices(~Amb_To_Exclude);
    if ~isempty(Amb_Indices_to_Possibly_Include)
        % then do heuristic check!
        % compute centroid of these candidate triangles
        Centers = Compute_Centroid(VTX,TRI(Amb_Indices_to_Possibly_Include,:));
        % interpolate level set at centroid
        LS_Value = Interp_Func(Centers);
        Amb_Indices_to_Include = Amb_Indices_to_Possibly_Include(LS_Value >= 0);
        if ~isempty(Amb_Indices_to_Include)
            disp('Some ambiguous triangles are included in the interior mesh.');
            In_MSK(Amb_Indices_to_Include,1) = true;
        end
    end
end
% T1 = clock;
% disp(['Step (8+) Timing: ', num2str(etime(T1,T0),'%2.5G'), ' sec']);

TRI = TRI(In_MSK,:);

end