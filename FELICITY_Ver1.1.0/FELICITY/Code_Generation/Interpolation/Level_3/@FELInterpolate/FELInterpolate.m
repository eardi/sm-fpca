% Class for Interpolating a single expression (FELICITY Matrix Language)
% Contains info about the domain of expression (DoE), as well as the expression
% itself.  This generates code for computing the interpolation.
classdef FELInterpolate < FELExpression
    properties %(SetAccess='private',GetAccess='private')
        Domain               % a level 1 domain object (DoE)
        Expression           % symbolic expression to interpolate (vector or matrix valued)
        NumRow_SubINT        % number rows of sub-interpolations
        NumCol_SubINT        % number cols of sub-interpolations
        SubINT               % struct containing info about the sub-interpolations
    end
    methods
        function obj = FELInterpolate(varargin)
            
            if nargin ~= 4
                disp('Requires 4 arguments!');
                disp('First   is a name for the interpolation.');
                disp('Second  is a level 1 Domain of the expressions domain.');
                disp('Third   is the symbolic expression to interpolate.');
                disp('Fourth  is the temporary snippet directory to use.');
                error('Check the arguments!');
            end
            
            obj = obj@FELExpression(varargin{1},varargin{4});
            OUT_str  = '|---> Init FELInterpolate Object...';
            disp(OUT_str);
            
            obj.Domain               = varargin{2};
            obj.Expression           = varargin{3};
            
            if ~isa(obj.Domain,'Domain')
                error('Should be a level 1 Domain.');
            end
            if ~isa(obj.Expression,'sym')
                error('Must be a symbolic expression.');
            end
            obj.NumRow_SubINT = size(obj.Expression,1);
            obj.NumCol_SubINT = size(obj.Expression,2);
            if or(obj.NumRow_SubINT < 1,obj.NumCol_SubINT < 1)
                error('Number of sub-interpolations must be at least 1.');
            end
            ND = ndims(obj.Expression);
            if (ND > 2)
                error('Only 2nd-order tensor valued expressions are allowed!');
            end
            
            obj.SubINT   = Get_SubINT_struct();
            for ri = 1:obj.NumRow_SubINT
                for ci = 1:obj.NumCol_SubINT
                    obj.SubINT(ri,ci) = Get_SubINT_struct();
                end
            end
        end
    end
end

% END %