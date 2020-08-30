% FELICITY Class for automating point searching on meshes.
%
%   obj     = PointSearchMesh(Search_Handle,Search_Args,MEX_Dir,Mesh,MEX_FileName);
%
%   Search_Handle = function handle of m-file that defines point searching.
%                 Note: this is *not* an anonymous function.
%   Search_Args = cell array of input arguments to supply to 'Search_Handle'.
%                 Note: if there are no arguments, then this should be
%                 set equal to an empty cell array.
%   MEX_Dir = string containing directory to store point search mex file.
%             If set to "[]", then MEX_Dir := directory containing Defn_Handle.
%   Mesh    = FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).
%   MEX_FileName = string containing alternate filename to use for the
%                  point search mex file. (if omitted, then a default name is used).
classdef PointSearchMesh
    properties (SetAccess='private')
        Search_Handle     % function handle of m-file that defines point searching
        Search_Args       % cell array of input arguments
        Pt_Search_Struct  % output from running "Defn_Handle"
        Mesh_Info         % struct containing information about the mesh on which the finite element space is defined
        Trees             % map container containing various search trees
        mex_Dir           % directory to store mex file
        mex_Search_Func   % function handle to mex file (that is generated from "Defn")
    end
    methods
        function obj = PointSearchMesh(varargin)
            
            if or(nargin < 4, nargin > 5)
                disp('Requires 4 (or 5) arguments!');
                disp('First  is a function handle to the point search definition m-file.');
                disp('Second is a cell array of input arguments to supply to the function handle.');
                disp('Third  is a string containing directory to store point search mex file.');
                disp('Fourth is a FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).');
                disp('Fifth (optional) is a string containing an alternate file name for the point search mex file.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init PointSearchMesh Object...';
            disp(OUT_str);
            
            obj.Search_Handle = varargin{1};
            FH_Info = functions(obj.Search_Handle);
            if or(strcmpi(FH_Info.type,'anonymous'),isempty(FH_Info.file))
                % then the search directory MUST be specified
                Search_Dir = [];
                %error('Function handle must *not* be anonymous!');
            else
                % get path in case we need...
                Search_Dir = fileparts(FH_Info.file);
            end
            
            obj.Search_Args = varargin{2};
            if ~iscell(obj.Search_Args)
                error('Search arguments must be in a cell array!');
            end
            
            % run the function!
            obj.Pt_Search_Struct = obj.Search_Handle(obj.Search_Args{:});
            if ~isa(obj.Pt_Search_Struct,'PointSearches')
                error('Pt_Search_Struct is not a "PointSearches" object!');
            end
            
            % store dir
            obj.mex_Dir = varargin{3};
            if isempty(obj.mex_Dir)
                obj.mex_Dir = Search_Dir;
            end
            if ~exist(obj.mex_Dir,'dir')
                error('mex_Dir does not exist!');
            end
            
            if (nargin==5)
                mexFileName = varargin{5};
                if ~ischar(mexFileName)
                    error('Filename must be a string!');
                end
            else
                mexFileName = [];
            end
            if isempty(mexFileName)
                % set mex filename
                PtSearch_Defn_str    = func2str(obj.Search_Handle);
                mexFileName          = ['mex_', PtSearch_Defn_str];
            end
            obj.mex_Search_Func  = str2func(mexFileName);
            
            % init
            obj.Trees            = containers.Map();
            
            % get info about mesh
            obj.Mesh_Info = Mesh_Info_Struct;
            obj = Get_Mesh_Info(obj,varargin{4});
        end
    end
    methods (Access = public)
%         function MAX = max_dof(obj)
%             %max_dof
%             %
%             %   This returns the largest Degree-of-Freedom (DoF) index in
%             %   obj.DoFmap.  Note: this is only for the 1st component of the
%             %   space; this is important when the FE space is a tensor product
%             %   of other FE spaces.
%             %
%             %   MAX = obj.max_dof;
%             MAX = max(obj.DoFmap(:));
%         end
    end
end

% END %