% Abstract FELICITY Class for running finite element simulations.
%
% You must create a concrete sub-class of this class and fill in the various methods
% (internal functions).  See the abstract methods below.
classdef FEL_AbstractSim
    properties %(SetAccess='private',GetAccess='private')
        % these should all be publically accessible
        Mesh      % global mesh (one of the FELICITY mesh classes)
        Space     % struct containing finite element spaces as sub-fields
        Solution  % struct containing solution variable data as sub-fields
    end
    methods
        function obj = FEL_AbstractSim(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments to initialize!');
                error('Check the arguments.');
            end
            
            % init
            obj.Mesh      = [];
            obj.Space     = [];
            obj.Solution  = [];
        end
    end
    methods (Abstract)
        % define the global mesh for the simulation
        % SWW: this needs to be removed!
        obj         = Define_Mesh(obj);
        % define the finite element spaces for the simulation
        obj         = Define_Finite_Element_Space(obj);
        % initialize solution variable (finite element coef. arrays) for the simulation
        obj         = Initialize_Solution(obj);
    end
end

% END %