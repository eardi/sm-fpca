% Abstract Class for All Meshes
classdef AbstractMesh
    properties (Hidden = true)
        TR                 % hold triangulation object
    end
    properties (Dependent)
        Points
        ConnectivityList
    end
    properties %(SetAccess = private)
        Name               % name for the mesh (i.e. name of the domain)
        Subdomain          % struct to hold info about subdomains embedded in the mesh
    end
    methods
        function obj = AbstractMesh(varargin)
            if nargin ~= 1
                disp('Requires 1 arguments!');
                disp('First is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj.TR              = [];
            obj.Name            = varargin{1};
            obj.Subdomain       = []; % init
            
            if ~ischar(obj.Name)
                error('Mesh name should be a string.');
            end
        end
        function p = get.Points(obj)
            % Property getter method, so that AbstractMesh.Points behaves like triangulation.Points
            p = obj.TR.Points;
        end
        function c = get.ConnectivityList(obj)
            % Another property getter
            c = obj.TR.ConnectivityList;
        end
    end
    methods (Access = protected)
        [Cell, Vtx] = Abstract_Reorder(obj);
    end
    methods (Abstract)
        obj         = Reorder(obj);   % reorder the vertex indices (numbering)
        obj         = Set_Points(obj,Vtx); % set vertex coordinates
        obj         = Refine(obj);    % refine the mesh
    end
end

% END %