% FELICITY class for processing level 1 user code.
% This defines a Bilinear (form) object.  This is for defining a Finite Element
% (FE) matrix.
%
%   obj        = Bilinear(Test_Elem,Trial_Elem);
%
%   Test_Elem  = Level 1 Element object representing the FE space for the test
%                function.
%   Trial_Elem = Level 1 Element object representing the FE space for the trial
%                function.
classdef Bilinear < genericform
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    methods
        function obj = Bilinear(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is a Test  Finite Element Space.');
                disp('Second is a Trial Finite Element Space.');
                error('Check the arguments!');
            end
            OUT_str = '|---> Define Bilinear Form...';
            disp(OUT_str);
            
            obj.Name     = [];
            obj.Integral = [];
            obj.Test_Space       = varargin{1};
            obj.Test_Space.Name  = inputname(1); % make sure it knows its name
            obj.Trial_Space      = varargin{2};
            obj.Trial_Space.Name = inputname(2); % make sure it knows its name
            if ~isa(obj.Test_Space,'Element')
                error('First argument must be a Level 1 Element!');
            end
            if ~isa(obj.Trial_Space,'Element')
                error('Second argument must be a Level 1 Element!');
            end
        end
    end
end

% END %