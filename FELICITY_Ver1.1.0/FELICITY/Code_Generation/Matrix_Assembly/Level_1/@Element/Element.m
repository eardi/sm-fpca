% FELICITY class for processing level 1 user code.
% This defines an element object to be used with a genericform (Bilinear or
% Linear) and for defining Test, Trial, and Coef(s).  In other words, this is
% for defining a Finite Element (FE) space.
%
%   obj        = Element(Domain,Elem_Defn,Num_Tensor);
%
%   Domain     = Level 1 Domain object.
%   Elem_Defn  = element definition struct obtained by calling one of the files
%                in the ./FELICITY/Elem_Defn directory.
%   Num_Tensor = number of tensor components for the FE space (e.g. spaces can
%                be built by taking tensor products of scalar-valued spaces).
classdef Element
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    properties %(SetAccess=private,GetAccess=private)
        Domain               % Level 1 Domain
        Elem                 % Reference Element Defn struct
        Tensor_Comp          % number of vector (or tensor) components to the space
    end
    methods
        function obj = Element(varargin)
            
            if or(nargin < 1,nargin > 3)
                disp('Requires 1, 2, or 3 arguments!');
                disp('First  is a Domain.');
                disp('Second is a FELICITY Element definition file.');
                disp('Third  is the number of vector (tensor) components.');
                error('Check the arguments!');
            end
            
            obj.Name = [];
            obj.Elem = constant_one();
            obj.Tensor_Comp = 1;
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
            if nargin >= 3
                obj.Tensor_Comp = varargin{3};
            end
            Check_Element_Definition(obj.Elem);
            
            % check consistency of simplex type with element
            if ~isempty(obj.Elem.Domain) % not the ``constant_one'' case
                if ~strcmp(obj.Elem.Domain,obj.Domain.Type);
                    disp(['Reference Element Simplex Type: ', obj.Elem.Domain]);
                    disp(['Domain            Simplex Type: ', obj.Domain.Type]);
                    error('Reference Element and Domain are *not* defined on the same simplices!');
                end
            end
            
            if or((size(obj.Tensor_Comp,1) ~= 1),(size(obj.Tensor_Comp,2) > 1))
                disp('Tensor_Comp must be a 1x1 matrix.');
                error('This will be extended later...');
            end
            if (min(obj.Tensor_Comp) < 1)
                error('Tensor_Comp must be at least 1.');
            end
            
            if ~isa(obj.Domain,'Domain')
                error('''Domain'' must be a Domain object!');
            end
        end
    end
end

% END %