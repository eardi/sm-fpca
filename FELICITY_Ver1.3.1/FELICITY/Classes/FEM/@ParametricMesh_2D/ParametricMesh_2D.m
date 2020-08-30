% FELICITY Class for generating a (piecewise linear) mesh of a domain
% defined by a piecewise parametric curve, with M pieces.
%
%   obj = ParametricMesh_2D(Name,Chart_Domains,Chart_Funcs);
%
%   Name          = (string) name for the domain.
%   Chart_Domains = Mx2 matrix, where ith row is [a_i, b_i].
%   Chart_Funcs   = Mx1 cell array of function handles, where the ith entry
%                   gives  alpha_i : [a_i, b_i] \to \R^2,
%
%   In other words, alpha_i defines a parametric curve over the interval
%   [a_i, b_i], where the collection of alpha_i's must be compatible in the
%   following sense:
%
%   alpha_{i+1}(a_{i+1}) = alpha_{i} (b_i), and  alpha_{1}(a_i) = alpha_{M} (b_i)
%
%   Each function handle should have the form:
%         alpha = @(t) [f_1(t), f_2(t)],
%   i.e.  alpha(tv) = Mx2 matrix, if tv is a Mx1 column vector of numbers.
%
%   Note: it is up to you to provide a set of curves that do not
%   self-intersect!
classdef ParametricMesh_2D
    properties (SetAccess='private')
        Name              % name of the domain
        Chart_Domains     %
        Chart_Funcs       %
        Corners           % Kx2 matrix representing coordinates of corners
    end
    methods
        function obj = ParametricMesh_2D(varargin)
            
            if nargin ~= 3
                disp('Requires 3 arguments!');
                disp('First  is an appropriate name for the Parametric Domain.');
                disp('Second is an Mx2 matrix of interval domains.');
                disp('Third  is an Mx1 cell array of function handles to parametric function.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init ParametricMesh_2D Object...';
            disp(OUT_str);
            
            obj.Name = varargin{1};
            if ~ischar(obj.Name)
                error('Must be a string!');
            end
            
            obj.Chart_Domains = varargin{2};
            if ~isnumeric(obj.Chart_Domains)
                error('Must be a numerical array!');
            end
            M1 = size(obj.Chart_Domains,1);
            CHK_COL_1 = size(obj.Chart_Domains,2);
            if CHK_COL_1~=2
                error('Must be a 2 column matrix!');
            end
            if max(obj.Chart_Domains(:,2) <= obj.Chart_Domains(:,1))
                error('Chart domains [a_i, b_i] must satisfy b_i > a_i.');
            end
            obj.Chart_Funcs = varargin{3};
            if ~iscell(obj.Chart_Funcs)
                error('Must be a cell array!');
            end
            M2 = size(obj.Chart_Funcs,1);
            CHK_COL_2 = size(obj.Chart_Funcs,2);
            if CHK_COL_2~=1
                error('Must be a 1 column cell array!');
            end
            if M1~=M2
                error('Number of rows in chart data must match!');
            end
            % make sure they are function handles
            for ii = 1:M1
                if ~isa(obj.Chart_Funcs{ii},'function_handle')
                    error('This is not a function handle!');
                end
            end
            
            obj.Corners = zeros(M1,2); % init
            
            % now check the compatibility
            for ii = 1:M1
                if (ii==M1)
                    ai_plus_1 = obj.Chart_Domains(1,1);
                    alpha_i_plus_1 = obj.Chart_Funcs{1};
                else
                    ai_plus_1 = obj.Chart_Domains(ii+1,1);
                    alpha_i_plus_1 = obj.Chart_Funcs{ii+1};
                end
                X_i_plus_1 = alpha_i_plus_1(ai_plus_1);
                if size(X_i_plus_1,1) > 1
                    error('Chart function must be a row vector!');
                end
                
                bi      = obj.Chart_Domains(ii,2);
                alpha_i = obj.Chart_Funcs{ii};
                X_i     = alpha_i(bi);
                if size(X_i,1) > 1
                    error('Chart function must be a row vector!');
                end
                
                ERR = abs(X_i_plus_1 - X_i);
                if (max(ERR) > 1e-14)
                    max(ERR)
                    error('The charts are not compatible, i.e. they do not define a continuous closed curve.');
                end
                % store the corner
                obj.Corners(ii,:) = X_i;
            end
        end
    end
end

% END %