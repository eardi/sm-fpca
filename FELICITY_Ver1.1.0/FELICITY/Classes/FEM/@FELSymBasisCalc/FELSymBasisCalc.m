% FELICITY class for holding sym expressions of basis functions (and their
% derivatives).  This also holds point evaluations.
%
%   obj        = FELSymBasisCalc(Base_Func,Max_Deriv);
%
%   Base_Func  = FELSymFunc object (before taking derivatives).
%   Max_Deriv  = maximum order of derivative to compute (including mixed
%                derivatives).
classdef FELSymBasisCalc
    properties %(SetAccess='private',GetAccess='private')
        Base_Func      % FELSymFunc object for initial un-diff'ed function.
        Deriv_Func     % Map container of FELSymFunc objects (diff'ed function).
        Max_Deriv      % max order of derivative to compute.
    end
    properties (SetAccess='private')
        Pt          % array of point coordinates to evaluate all functions at.
        Base_Value  % values of the un-diff'ed function at the point coordinates.
        Deriv_Value % (Map container) values of the diff'ed function at the point coordinates.
        Orig_Vars   % names of the original indep. variables;
                    % useful when composing with a function after taking
                    % derivatives
    end
    methods
        function obj = FELSymBasisCalc(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a FELSymFunc object (before taking derivatives).');
                disp('Second is the maximum order of derivatives to compute.');
                error('Check the arguments!');
            end
            
            obj.Base_Func = varargin{1};
            if ~isa(obj.Base_Func,'FELSymFunc')
                error('Must be a FELSymFunc object!');
            end
            obj.Max_Deriv = varargin{2};
            if obj.Max_Deriv < 0
                error('Invalid derivative order!');
            end
            
            % fill the container
            obj.Deriv_Func = fill_map_container(obj.Base_Func,obj.Max_Deriv);
            
            % init
            obj.Pt          = [];
            obj.Base_Value  = [];
            obj.Deriv_Value = [];
            obj.Orig_Vars   = [];
        end
    end
end

% END %