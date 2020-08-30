% FELICITY class for processing level 1 user code.
% This defines an integral object to be used with a genericform (Bilinear,
% Linear, or Real).  This object can only represent a single integral (not
% multiple integrals).  But the genericforms can contain multiple integral
% objects.
%
%   obj      = Integral(Domain,Sym_Expr);
%
%   Domain   = Level 1 Domain object (i.e. the domain of integration).
%   Sym_Expr = sym object (symbolic) that involves (possibly) Test and
%              Trial basis function evaluations, and/or Coef function
%              and/or GeoFunc function evaluations.
classdef Integral < abstractexpr
    properties %(SetAccess=private,GetAccess=private)
        Integrand           % this stores the integral's integrand (symbolically)
    end
    methods
        function obj = Integral(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is a Domain.');
                disp('Second is a symbolic expression involving (possibly) Test, Trial, Coef functions and/or GeoFuncs.');
                error('Check the arguments!');
            end
            
            obj = obj@abstractexpr(varargin{1});
            % make sure the domain KNOWS its name!
            if or(isempty(obj.Domain.Name),strcmp(obj.Domain.Name,''))
                obj.Domain.Name = inputname(1);
            end
            
            obj.Integrand = varargin{2};
            % need to make sure the integrand is a scalar
            if length(obj.Integrand) > 1
                disp('Error with this integrand:');
                disp(obj.Integrand);
                error('Integrand must be a scalar valued expression!');
            end
            
            % Note: this code is similar to what is in @Interpolate/Interpolate.m
            % (we cannot abstract this because we need to access the 'caller'.)
            Func_Names = obj.Get_Workspace_Functions(obj.Integrand);
            % read in Level 1 functions from workspace
            Num_Func = length(Func_Names);
            FUNC = cell(Num_Func,1);
            for ind = 1:Num_Func
                TEMP = evalin('caller', [Func_Names{ind}, ';']);
                TEMP.Name = Func_Names{ind}; % make sure it knows its name!
                FUNC{ind} = TEMP;
            end
            FUNC = obj.Set_Evaluation_Domain_Of_Functions(FUNC);
            obj = obj.Read_Incoming_Functions(FUNC);
            if (size(obj.CoefF,2)>1)
                error('obj.CoefF must be a column vector!');
            end
            
            GeoFUNC_Domains = obj.Get_Geometric_Function_Domain_Names(obj.Integrand);
            % read in Level 1 domains from workspace
            Num_Dom = length(GeoFUNC_Domains);
            DOM = cell(Num_Dom,1);
            for ind = 1:Num_Dom
                TEMP = evalin('caller', [GeoFUNC_Domains{ind}, ';']);
                TEMP.Name = GeoFUNC_Domains{ind}; % make sure it knows its name!
                DOM{ind} = TEMP;
            end
            obj = obj.Set_Geometric_Functions(DOM);
            if (size(obj.GeoF,2)>1)
                error('obj.GeoF must be a column vector!');
            end
            
            % make consistency checks on the data.....
            obj.Verify_Consistent_Function_Domains;
            obj.Verify_Sym_Arguments(obj.Integrand);
            obj.Verify_Distinct_Function_Names;
        end
        
        function NEW = plus(I1,I2)
            %plus
            %
            %   This adds two integrals together.  Note: the Domain of both
            %   Integral(s) must be the same.
            %
            %   NEW = I1 + I2;
            %
            %   I1,I2 = Level 1 Integral objects.
            %
            %   NEW   = combined Level 1 Integral object.
            
            if ~isa(I1,'Integral')
                error('''I1'' must be an Integral object!');
            end
            if ~isa(I2,'Integral')
                error('''I2'' must be an Integral object!');
            end
            
            % if the Domain's match, then we might be able to do it...
            SUCCESS = false;
            if isequal(I1.Domain,I2.Domain)
                % make sure these are the same!
                if and(isequal(I1.TestF,I2.TestF),isequal(I1.TrialF,I2.TrialF))
                    % SUCCESS!
                    SUCCESS = true;
                end
            end
            
            NEW = I1; % init
            if SUCCESS
                NEW.Integrand = NEW.Integrand + I2.Integrand;
                % combine CoefFs
                NEW.CoefF = [NEW.CoefF; I2.CoefF];
            end
        end
    end
end

% END %