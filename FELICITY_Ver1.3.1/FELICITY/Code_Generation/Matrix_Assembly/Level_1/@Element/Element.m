% FELICITY class for processing level 1 user code.
% This defines an element object to be used with a genericform (Bilinear or
% Linear) and for defining Test, Trial, and Coef(s).  In other words, this is
% for defining a Finite Element (FE) space.
%
%   obj        = Element(Domain,Elem_Defn);
%
%   Domain     = Level 1 Domain object.
%   Elem_Defn  = element definition struct obtained by calling one of the files
%                in the ./FELICITY/Elem_Defn directory.
%
%   obj        = Element(Domain,Elem_Defn,Num_Comp);
%
%   Num_Comp   = number of tuple components for the FE space (i.e. spaces can
%                be built by taking cartesian products of base FE spaces).
%                If omitted, then the default value "1" is used.
%                NOTE: if the base FE space is scalar valued, then this
%                treats functions in the product space as a column vector.
%
%   obj        = Element(Domain,Elem_Defn,Num_Row,Num_Col);
%
%                Similar to previous usage, except there are TWO cartesian
%                product indices.  I.e. if the base FE space is scalar
%                valued, then this treats functions in the product space as
%                a matrix with size given by Num_Row x Num_Col.
%
%   obj        = Element(Domain,Elem_Defn,[Num_Row, Num_Col]);
%
%                Same as previous, but different call procedure.
classdef Element
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    properties %(SetAccess=private,GetAccess=private)
        Domain               % Level 1 Domain
        Elem                 % Reference Element Defn struct
        Tensor_Comp          % number of tuple components to the space
    end
    methods
        function obj = Element(varargin)
            
            if or(nargin < 1,nargin > 4)
                disp('Requires 1, 2, 3, or 4 arguments!');
                disp('First  is a Domain.');
                disp('Second is a FELICITY Element definition file.');
                disp('Third/Fourth is the tuple size of the element (i.e. how many cartesian products to take).');
                error('Check the arguments!');
            end
            
            obj.Name = [];
            obj.Elem = constant_one();
            obj.Tensor_Comp = [1 1];
            if nargin >= 1
                obj.Domain = varargin{1};
                Domain_Name = inputname(1);
                if or(isempty(Domain_Name),strcmp(Domain_Name,''))
                    disp('The input Domain must have its own workspace variable,...');
                    error('i.e. Domain must be separately defined.');
                else
                    obj.Domain.Name = Domain_Name;
                end
            end
            if nargin >= 2
                obj.Elem = varargin{2};
            end
            if (nargin==3)
                TC = varargin{3};
                if (size(TC,1)~=1)
                    error('3rd argument must be a row vector.');
                end
                if (size(TC,2) > 2)
                    error('3rd argument must be a row vector of length 1 or 2.');
                end
                if (size(TC,2)==1)
                    TC = [TC(1), 1];
                end
                obj.Tensor_Comp = TC;
            elseif (nargin==4)
                TC_1 = varargin{3};
                TC_2 = varargin{4};
                TC = [TC_1, TC_2];
                if ~and(size(TC,1)==1,size(TC,2)==2)
                    error('3rd and 4th argument must each be a scalar.');
                end
            end
            Check_Element_Definition(obj.Elem);
            
            % check consistency of simplex type with element
            if ~isempty(obj.Elem.Domain) % not the ``constant_one'' case
                if ~strcmp(obj.Elem.Domain,obj.Domain.Type)
                    disp(['Reference Element Simplex Type: ', obj.Elem.Domain]);
                    disp(['Domain            Simplex Type: ', obj.Domain.Type]);
                    error('Reference Element and Domain are *not* defined on the same simplices!');
                end
            end
            
            if (length(obj.Tensor_Comp) > 2)
                error('Tensor_Comp must be length 1 or 2.');
            end
            if (min(obj.Tensor_Comp) < 1)
                error('Tensor_Comp entries must be at least 1.');
            end
            
            if ~isa(obj.Domain,'Domain')
                error('''Domain'' must be a Domain object!');
            end
        end
    end
end

% END %