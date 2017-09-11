% Concrete FELICITY Class (TEMPLATE) for running finite element simulations.
%
% The user must fill in the various methods (internal functions).  The user should also
% copy this class over to a new directory and rename it to something appropriate.
classdef FEL_Sim_Template < FEL_AbstractSim
    properties %(SetAccess='private',GetAccess='private')
        % the user can change, delete, or add "properties" here
        % Note: keep all of these publically accessible
        Param                      % some parameters
        % ...
    end
    methods
        function obj = FEL_Sim_Template(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments to initialize!');
                error('Check the arguments.');
            end
            
            obj = obj@FEL_AbstractSim();
            % init
            obj.Param                      = [];
            % ...
        end
    end
end

% END %