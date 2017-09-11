% FELICITY class for processing level 1 user code.
% This defines an element object to be used for specifying how the geometry of
% the global domain is represented, i.e. what is the FE space that the domain
% geometry is built from.  Note: this is similar to the Level 1 Element object.
%
%   obj        = GeoElement(Domain);
%
%   Domain     = Level 1 Domain object.
%
%   obj        = GeoElement(Domain,Elem_Defn);
%
%   Elem_Defn  = element definition struct obtained by calling one of the files
%                in the ./FELICITY/Elem_Defn directory.
%                if 'Elem_Defn' is omitted, then it assumes the domain geometry
%                is built from standard piecewise linear (flat) elements.
classdef GeoElement
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    properties %(SetAccess=private,GetAccess=private)
        Domain               % Level 1 Domain
        Elem                 % Reference Element
        Tensor_Comp          % number of vector components to the space
    end
    methods
        function obj = GeoElement(varargin)
            
            if or(nargin < 1,nargin > 2)
                disp('Requires 1 or 2 arguments!');
                disp('First  is a Domain.');
                disp('Second is a FELICITY Element definition file.');
                error('Check the arguments!');
            end
            obj.Name = [];
            obj.Elem = [];
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
            obj.Tensor_Comp = obj.Domain.GeoDim; % must match the ambient dimension of the domain
            
            if nargin==1
                if strcmp(obj.Domain.Type,'interval')
                    obj.Elem = lagrange_deg1_dim1();
                elseif strcmp(obj.Domain.Type,'triangle')
                    obj.Elem = lagrange_deg1_dim2();
                elseif strcmp(obj.Domain.Type,'tetrahedron')
                    obj.Elem = lagrange_deg1_dim3();
                else
                    error('Domain.Type is not implemented!');
                end
            end
            if strcmp(obj.Elem.Name,'constant_one')
                error('GeoElement cannot be ''constant_one''!');
            end
            % check consistency of simplex type with element
            if ~strcmp(obj.Elem.Domain,obj.Domain.Type);
                disp(['Reference Element Simplex Type: ', obj.Elem.Domain]);
                disp(['Domain            Simplex Type: ', obj.Domain.Type]);
                error('Reference Element and Domain are *not* defined on the same simplices!');
            end
            Check_Element_Definition(obj.Elem);
            
            % basic checks
            class_str = class(obj.Domain);
            if ~strcmp(class_str,'Domain')
                error('''Domain'' must be a Domain object!');
            end

            % make sure that number of vector components is big enough
            if strcmp(obj.Domain.Type,'triangle')
                if obj.Tensor_Comp < 2
                    disp(['Domain.Type = ', obj.Domain.Type]);
                    error('Geometric dimension must be at least 2.');
                end
            end
            if strcmp(obj.Domain.Type,'tetrahedron')
                if obj.Tensor_Comp < 3
                    disp(['Domain.Type = ', obj.Domain.Type]);
                    error('Geometric dimension must be at least 3.');
                end
            end
            % but not bigger than 3
            if obj.Tensor_Comp > 3
                disp('Geometric dimension cannot be bigger than 3.');
                error('Not implemented!');
            end
        end
    end
end

% END %