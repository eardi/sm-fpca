% FELICITY class for processing level 1 user code:  Geometric Functions.
%
%   obj      = GeoFunc(Domain);
%
%   Domain   = Level 1 Domain object, which represents the domain that we want
%              geometric data for (e.g. normal vectors on a surface, etc...).
classdef GeoFunc < abstractfunc
    properties %(SetAccess=private,GetAccess=private)
    end
    methods
        function obj = GeoFunc(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First   is a Domain to get geometric data for.');
                error('Check the arguments!');
            end
            % init
            Domain = varargin{1};
            obj=obj@abstractfunc('',Domain);
            
            if isempty(obj.Domain.Name)
                % then use the name from the workspace
                Domain_Name = inputname(1);
            else
                % else use the name it already has
                Domain_Name = obj.Domain.Name;
            end
            if or(isempty(Domain_Name),strcmp(Domain_Name,''))
                disp('The input Domain must have its own workspace variable,...');
                error('i.e. Domain must be separately defined.');
            else
                obj.Domain.Name = Domain_Name;
            end
            
            % the name is fixed for geometric quantity functions
            obj.Name = ['geom', obj.Domain.Name]; % 'geom' is standard prefix
        end
    end
end

% END %