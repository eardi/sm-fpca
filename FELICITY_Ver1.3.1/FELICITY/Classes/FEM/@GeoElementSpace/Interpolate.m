function Interp_Func = Interpolate(obj,Mesh,GeoFunc,Interp_Points)
%Interpolate
%
%   This interpolates a function in the geometric element space (with given
%   nodal values in "GeoFunc") at the points given in "Interp_Points".
%
%   Interp_Func = obj.Interpolate(Mesh,GeoFunc,Interp_Points);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   GeoFunc = MxD matrix of nodal values for the function; M is the number of
%             DoFs in the FE space, D is the geometric dimension of the mesh.
%   Interp_Points = {Cell_Indices (Qx1), Ref_Coord (QxT)}, where Q is the
%                   number of points, T is the topological dimension of the
%                   mesh.  Thus, the given interpolation points must be
%                   given in the format of what mesh cell each point
%                   belongs to, and what the reference domain coordinates
%                   are in that cell.
%
%   Interp_Func = QxD matrix of function values (at given interpolation
%                 points).
%
%   Note: M = the number of global DoF indices. If the space is tensor-valued, then M is
%         the number of global DoF indices for ONE component only; note that all
%         components of a tensor-valued space share the same DoF coordinates.

% Copyright (c) 04-09-2017,  Shawn W. Walker

obj.Verify_Mesh(Mesh);

if isempty(obj.mex_Dir)
    error('Use the method ''Set_mex_Dir'' to define the directory to contain interpolation mex files.');
end

% check if mex file exists
DD = dir(fullfile(obj.mex_Dir, [func2str(obj.mex_Interpolation), '.', mexext]));
File_Exists = ~isempty(DD);
if ~File_Exists
    % only compile if it doesn't exist!
    obj.Compile_MEX;
    
    % make sure it exists now
    DD = dir(fullfile(obj.mex_Dir, [func2str(obj.mex_Interpolation), '.', mexext]));
    pause(0.1);
    File_Does_Not_Exist = isempty(DD);
    if (File_Does_Not_Exist)
        error('The interpolation mex file does not exist after compiling it!');
    end
end

if ~iscell(Interp_Points)
    error('Interp_Points must be a cell array = {Cell_Indices (Qx1), Ref_Coord (QxT)}.');
end
if (length(Interp_Points)~=2)
    error('Interp_Points must be a cell array = {Cell_Indices (Qx1), Ref_Coord (QxT)}.');
end
if isempty(obj.DoFmap)
    error('DoFmap for GeoElementSpace object is not set!');
end

% now interpolate!
INTERP = obj.mex_Interpolation(Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Interp_Points,obj.DoFmap,GeoFunc);

% error check
if (length(INTERP.DATA)~=Mesh.Geo_Dim)
    error('Interpolated data must have same number of components as Mesh geometric dimension!');
end

% translate data structure
Interp_Func = zeros(length(Interp_Points{1}),Mesh.Geo_Dim); % init
for jj = 1:Mesh.Geo_Dim
    Interp_Func(:,jj) = INTERP.DATA{jj};
end

end