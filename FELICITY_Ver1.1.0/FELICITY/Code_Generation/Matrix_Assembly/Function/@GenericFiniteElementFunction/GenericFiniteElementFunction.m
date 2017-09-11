% Abstract Base Class for Finite Element Functions (FELICITY Matrix Language)
classdef GenericFiniteElementFunction
    properties %(SetAccess='private',GetAccess='private')
        Elem              % a copy of the reference finite element
        Func_Name         % user given name of the function
        Opt               % struct contains info on what evaluations are needed
        INTERPOLATION     % boolean indicating if this is for interpolating FEM functions
                          % false = (default) assume normal FEM matrix assembly
                          % true  = assume this is for generating code for interpolation
        DEBUG             % indicates whether to put debugging code in
        BEGIN_Auto_Gen    % string
        END_Auto_Gen      % string
    end
    methods
        function obj = GenericFiniteElementFunction(varargin)
            
            if and(nargin ~= 2,nargin ~= 1)
                disp('Requires 2 arguments!');
                disp('First  is a copy of the reference finite element.');
                disp('Second is a name for the function.');
                
                disp(' OR ');
                disp('Requires 1 argument!');
                disp('First  is a copy of the reference finite element.');
                error('Check the arguments!');
            end
            
            if (nargin==2)
                obj.Elem                 = varargin{1};
                obj.Func_Name            = varargin{2};
                obj.DEBUG                = true;
            else
                obj.Elem = varargin{1};
                obj.Func_Name = '';
                obj.DEBUG                = true;
            end
            if isempty(obj.Func_Name)
                obj.Func_Name = '';
            end
            if ~ischar(obj.Func_Name)
                error('Func_Name must be a string.');
            end
            if ~isa(obj.Elem,'ReferenceFiniteElement')
                error('Elem must be a ReferenceFiniteElement!');
            end
            obj.Opt = []; % init
            obj.INTERPOLATION = false; % assume no interpolation is being done
            
            obj.BEGIN_Auto_Gen = '/*------------ BEGIN: Auto Generate ------------*/';
            obj.END_Auto_Gen   = '/*------------   END: Auto Generate ------------*/';
        end
    end
end

% END %