% FELICITY class for processing level 1 user code.
% This defines a Linear (form) object.  This is for defining a Finite Element
% (FE) "right-hand-side" column vector.
%
%   obj        = Linear(Test_Elem);
%
%   Test_Elem  = Level 1 Element object representing the FE space for the test
%                function.
classdef Linear < genericform
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    methods
        function obj = Linear(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 argument!');
                disp('First  is a Test  Finite Element Space.');
                error('Check the arguments!');
            end
            OUT_str = '|---> Define Linear Form...';
            disp(OUT_str);
            
            obj.Name     = [];
            obj.Integral = [];
            obj.Test_Space       = varargin{1};
            obj.Test_Space.Name  = inputname(1); % make sure it knows its name
            obj.Trial_Space      = [];
            if ~isa(obj.Test_Space,'Element')
                error('First argument must be a Level 1 Element!');
            end
        end
    end
end

% END %