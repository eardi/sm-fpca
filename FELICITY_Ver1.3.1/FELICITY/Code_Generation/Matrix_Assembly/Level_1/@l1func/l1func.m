% FELICITY (abstract) class for processing level 1 user code.
%
%   obj  = l1func(Elem);
%
%   Elem = Level 1 Element object.
%
%   obj  = l1func(Elem,Domain);
%
%   Domain = Level 1 Domain object, which represents the domain that we are
%            restricting the function to.
classdef l1func < abstractfunc
    properties %(SetAccess=private,GetAccess=private)
        Element              % Level 1 Element
    end
    methods
        function obj = l1func(varargin)
            
            if or(nargin < 1,nargin > 3)
                disp('Requires 1, 2, or 3 arguments!');
                disp('First  is an Element.');
                disp('Second is a Level 1 Domain (optional).');
                error('Check the arguments!');
            end
            if (nargin >= 2)
                Domain = varargin{2};
            else
                Domain = [];
            end
            obj=obj@abstractfunc('',Domain);
            obj.Element = varargin{1};
            
            if ~isa(obj.Element,'Element')
                error('''Element'' must be an Element object!');
            end
        end
    end
%     methods (Abstract)
%         obj         = BLANK(obj)
%     end
end

% END %