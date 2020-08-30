% FELICITY class for processing level 1 user code.
% This defines an interpolate object to be used for interpolating FE Coef
% functions as well as domain geometry.  This object can only represent a
% single expression to interpolate.  But you can have multiple interpolate
% objects.
%
%   obj      = Interpolate(Domain,Sym_Expr);
%
%   Domain   = Level 1 Domain object (i.e. the domain of interpolation).
%   Sym_Expr = sym object (symbolic) that involves Coef functions and/or
%              GeoFunc functions.
classdef Interpolate < abstractexpr
    properties %(SetAccess=private,GetAccess=private)
        Name                % name of the interpolation expression
        Expression          % this stores expression (symbolically)
    end
    methods
        function obj = Interpolate(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is a Domain.');
                disp('Second is a symbolic expression involving Coef functions and/or GeoFuncs.');
                error('Check the arguments!');
            end
            
            obj = obj@abstractexpr(varargin{1});
            % make sure the domain KNOWS its name!
            if or(isempty(obj.Domain.Name),strcmp(obj.Domain.Name,''))
                obj.Domain.Name = inputname(1);
            end
            obj.Name   = []; % will be set later.
            obj.TestF  = []; % NOT used
            obj.TrialF = []; % NOT used
            
            obj.Expression = varargin{2};
            
            % Note: this code is similar to what is in @Integral/Integral.m
            % (we cannot abstract this because we need to access the 'caller'.)
            Func_Names = obj.Get_Workspace_Functions(obj.Expression);
            % read in level 1 functions from workspace
            Num_Func = length(Func_Names);
            FUNC = cell(Num_Func,1);
            for ind = 1:Num_Func
                TEMP = evalin('caller', [Func_Names{ind}, ';']);
                TEMP.Name = Func_Names{ind}; % make sure it knows its name!
                FUNC{ind} = TEMP;
            end
            FUNC = obj.Set_Evaluation_Domain_Of_Functions(FUNC);
            obj = obj.Read_Incoming_Functions(FUNC);
            
            GeoFUNC_Domains = obj.Get_Geometric_Function_Domain_Names(obj.Expression);
            % read in Level 1 domains from workspace
            Num_Dom = length(GeoFUNC_Domains);
            DOM = cell(Num_Dom,1);
            for ind = 1:Num_Dom
                TEMP = evalin('caller', [GeoFUNC_Domains{ind}, ';']);
                TEMP.Name = GeoFUNC_Domains{ind}; % make sure it knows its name!
                DOM{ind} = TEMP;
            end
            obj = obj.Set_Geometric_Functions(DOM);
            
            % make consistency checks on the data.....
            obj.Verify_Consistent_Function_Domains;
            obj.Verify_Sym_Arguments(obj.Expression);
            obj.Verify_Distinct_Function_Names;
        end
    end
end

% END %