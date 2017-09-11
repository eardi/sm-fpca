% (Abstract) FELICITY class for processing level 1 user code.
% This defines a superclass to be used with the Integral and Interpolate (sub)classes.
classdef abstractexpr
    properties (SetAccess=protected)%(SetAccess=private,GetAccess=private)
        Domain              % Level 1 Domain (of evaluation or expression)
        TestF               % Level 1 Test
        TrialF              % Level 1 Trial
        CoefF               % Level 1 Coef(s)
        GeoF                % Level 1 GeoFunc(s)
    end
    methods
        function obj = abstractexpr(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 argument!');
                disp('First  is a Domain.');
                error('Check the arguments!');
            end
            
            obj.Domain = varargin{1};
            if ~isa(obj.Domain,'Domain')
                error('Must be a Domain object!');
            end
        end
    end
end

% END %