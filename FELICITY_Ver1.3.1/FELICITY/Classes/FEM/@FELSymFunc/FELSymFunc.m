% FELICITY class for manipulating symbolic functions.  The number of independent
% variables can be anything.
%
%   obj     = FELSymFunc(Func);
%
%   Func    = (sym) symbolic function.  Assumes the independent variables are
%              'x', 'y', 'z' (1st var, 2nd var, 3rd var).
%
%   obj     = FELSymFunc(Func,Vars);
%
%   Vars    = 1xN cell array of strings that give the names of the independent
%             variables in the function's expression.
classdef FELSymFunc
    properties %(SetAccess='private',GetAccess='private')
        Func          % symbolic function (expression)
        Vars          % cell array containing the names of the independent variables
    end
    properties (SetAccess = protected, Hidden = true)
        subs_H        % function handle to the correct version of "subs".
    end
    methods
        function obj = FELSymFunc(varargin)
            
            if or(nargin < 1,nargin > 2)
                disp('Requires 1 or 2 arguments!');
                disp('First  is the symbolic function (expression).');
                disp('Second (optional) is a 1xN cell array (of strings or syms) specifying the independent variables.');
                error('Check the arguments!');
            end
            
            obj.Func = varargin{1};
            if ~isa(obj.Func,'sym')
                error('Must be a symbolic expression!');
            end
            %assume(obj.Func,'real'); % make function real valued!
            
            % init
            VARS = {'x', 'y', 'z'};
            
            % if user specifies other variable names
            if (nargin==2)
                VARS = varargin{2};
                if ~iscell(VARS)
                    error('Must be a cell array!');
                end
                if size(VARS,1)~=1
                    error('Number of rows must be 1.');
                end
%                 if size(VARS,2) < 1
%                     error('Must be at least 1 independent variable.');
%                 end
                for ii = 1:length(VARS)
                    if isa(VARS{ii},'sym')
                        VARS{ii} = char(VARS{ii}); % make it a string
                        % SWW: this could be better!
                    end
                    if ~ischar(VARS{ii})
                        error('Variable names must be strings!');
                    end
                end
                
                % make sure strings are different
                TEST = unique(VARS);
                if length(TEST)~=length(VARS)
                    error('Variable names are not unique!');
                end
            end
            
            obj.Vars = cell(1,length(VARS));
            for kk = 1:length(VARS)
                obj.Vars{kk} = sym(VARS{kk},'real');
            end
            
            % set the subs command
            obj.subs_H = FEL_subs_handle();
        end
        function D = input_dim(obj)
            %input_dim
            %
            %   Number of independent variables the symbolic function has.
            D = length(obj.Vars);
        end
        function varargout = output_size(obj)
            %output_size
            %
            %   Matrix size of the function, i.e. the function is matrix valued, with
            %   dimensions returned by this routine.
            if nargout~=1
                [R, C] = size(obj.Func);
                varargout{1} = R;
                varargout{2} = C;
            else
                varargout = size(obj.Func);
            end
        end
    end
end

% END %