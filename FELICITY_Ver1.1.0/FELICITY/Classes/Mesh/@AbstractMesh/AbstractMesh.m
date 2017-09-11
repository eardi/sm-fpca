% Abstract Class for All Meshes
classdef AbstractMesh
    properties %(SetAccess = private)
        Name               % name for the mesh (i.e. name of the domain)
    end
    properties %(SetAccess = private)
        Subdomain          % struct to hold info about subdomains embedded in the mesh
    end
    methods
        function obj = AbstractMesh(varargin)
            
            if nargin ~= 1
                disp('Requires 1 arguments!');
                disp('First is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj.Name            = varargin{1};
            obj.Subdomain       = []; % init
            
            if ~ischar(obj.Name)
                error('Mesh name should be a string.');
            end
        end
    end
    methods (Access = protected)
        [Cell, Vtx] = Abstract_Reorder(obj);
    end
    methods (Abstract)
        obj         = Reorder(obj);   % reorder the vertex indices (numbering)
        obj         = Set_X(obj,Vtx); % set vertex coordinates
        obj         = Refine(obj);    % refine the mesh
    end
end

% END %