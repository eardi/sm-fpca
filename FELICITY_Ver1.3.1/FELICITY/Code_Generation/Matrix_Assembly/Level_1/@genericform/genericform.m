% FELICITY (base) class for processing level 1 user code:  generic forms.
%
%   obj = genericform();
classdef genericform
    properties %(SetAccess=private,GetAccess=private)
        Test_Space     % finite element space for the Test function
        Trial_Space    % finite element space for the Trial function
        Integral       % this stores (multiple) Integral objects
    end
    methods
        function obj = genericform(varargin)
            obj.Test_Space  = [];
            obj.Trial_Space = [];
            obj.Integral    = [];
        end
        
        function obj = plus(old_obj,INT)
            %plus
            %
            %   This adds an integral contribution to the form.
            %
            %   obj = obj + INT;
            %
            %   INT = a Level 1 Integral object.
            
            IS_BILINEAR = isa(old_obj,'Bilinear');
            IS_LINEAR   = isa(old_obj,'Linear');
            IS_REAL     = isa(old_obj,'Real');
            VALID       = or(IS_REAL,or(IS_BILINEAR,IS_LINEAR));
            
            if ~VALID
                error('''old_obj'' must be a Bilinear, Linear, or Real object!');
            end
            if ~isa(INT,'Integral')
                error('''INT'' must be a Integral object!');
            end
            
            obj = old_obj.Add_Integral(INT);
        end
    end
end

% END %