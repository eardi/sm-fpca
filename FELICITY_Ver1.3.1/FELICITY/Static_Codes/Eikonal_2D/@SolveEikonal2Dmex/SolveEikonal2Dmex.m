% Class for solving the Eikonal equation on a 2-D triangulation
classdef SolveEikonal2Dmex
    properties %(SetAccess='private',GetAccess='private')
        TM        % triangle mesh object
        Bdy       % data struct containing boundary vertices and dirichlet solution data
        Param     % optional parameters
        Metric    % represents a spatially varying metric matrix
    end
    methods
        function obj = SolveEikonal2Dmex(varargin)
            
            if nargin ~= 4
                disp('Requires 4 arguments!');
                disp('First is a struct containing a triangulation.');
                disp('Second is a struct containing the boundary data.');
                disp('Third contains some parameters for controlling the algorithm.');
                disp('Fourth contains metric matrix data.');
                error('Check the input data!');
            end
            
            LINE_str = '----------------------------------';
            OUT_str  = '|---> Init SolveEikonalmex Object...';
            %disp(LINE_str);
            disp(OUT_str);
            %disp(LINE_str);
            
            obj.TM        = varargin{1};
            obj.Bdy       = varargin{2};
            obj.Param     = varargin{3};
            obj.Metric    = varargin{4};
            
            % check input
            fields_TF = isfield(obj.TM,{'Vtx','DoFmap','NegMask'});
            if (min(fields_TF)~=1)
                error('Invalid mesh struct...');
            end
            if ~isempty(obj.TM.NegMask)
                if (length(obj.TM.NegMask)~=size(obj.TM.Vtx,1))
                    error('Length of negative mask must be the same as the number of mesh vertices.');
                end
            end
            
            %%%%%
            
            fields_TF = isfield(obj.Bdy,{'Nodes','Data'});
            if (min(fields_TF)~=1)
                error('Invalid boundary data struct...');
            end
            if (length(obj.Bdy.Nodes)~=length(obj.Bdy.Data))
                error('Given Dirichlet data is not consistent: lengths are different.');
            end
            if (max(obj.Bdy.Nodes)>size(obj.TM.Vtx,1))
                error('Given Dirichlet data is not consistent: more Dirichlet nodes than mesh vertices.');
            end
            
            %%%%%
            
            fields_TF = isfield(obj.Param,{'Max_Tri_per_Star','NumGaussSeidel','INF_VAL','TOL'});
            if (min(fields_TF)~=1)
                error('Invalid parameter list...');
            end
            if (obj.Param.Max_Tri_per_Star < 10)
                disp('You may want to increase the max triangles in a star:  20 >= Param.Max_Tri_per_Star >= 10.');
                disp('    It will not reduce performance!');
            end
            
            %%%%%
            
            if ~isempty(obj.Metric)
                fields_TF = isfield(obj.Metric,{'I','DET'});
                if (min(fields_TF)~=1)
                    error('Invalid metric matrix...');
                end
            end
            
            %%%%%
            
            % init neighboring vertex/triangle data
            obj.TM.TriStarData = Get_Triangle_Neighbors(size(obj.TM.Vtx,1),obj.TM.DoFmap);
        end
    end
end

% END %