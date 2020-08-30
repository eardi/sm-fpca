% FELICITY class for processing level 1 user code.
% This defines a domain object to be used with defining Finite Element (FE)
% spaces (i.e. Element objects) and Integral(s) (i.e. for defining the
% Domain of Integration).
%
%   obj     = Domain(Type);
%
%   Type    = (string) specifies the base element that makes up the domain:
%             'interval':    domain made up of line segments/edges (1-D).
%             'triangle':    domain made up of triangles    (2-D).
%             'tetrahedron': domain made up of tetrahedrons (3-D).
%
%   obj     = Domain(Type,Geo_Dim);
%
%   Geo_Dim = specifies the ambient geometric dimension of the domain (e.g. an
%             intrinsically 2-D surface in 3-D).
classdef Domain
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
    properties (SetAccess=private) %(SetAccess=private,GetAccess=private)
        Type                 % String = 'interval', 'triangle', or 'tetrahedron'
        Subset_Of            % String holding the external variable name of the
                             % domain which this domain is a subset of
        GeoDim               % ambient geometric dimension
    end
    methods
        function obj = Domain(varargin)
            
            obj.Name = [];
            obj.Subset_Of = [];
            if or(nargin < 1,nargin > 2)
                disp('Requires 1 or 2 arguments!');
                disp('First   is the Domain type.');
                disp('Second  is the ambient geometric dimension that contains the Domain.');
                error('Check the arguments!');
            end
            obj.Type = varargin{1};
            if nargin==2
                obj.GeoDim = varargin{2};
                if (length(obj.GeoDim) > 1)
                    error('Geometric dimension must be a scalar!');
                end
                if obj.GeoDim < 1
                    error('Geometric dimension must be positive!');
                end
                if obj.GeoDim > 3
                    error('Not implemented!');
                end
            else
                obj.GeoDim = [];
            end
            
            INT = strcmp(obj.Type,'interval');
            TRI = strcmp(obj.Type,'triangle');
            TET = strcmp(obj.Type,'tetrahedron');
            if ~or(or(INT,TRI),TET)
                error('Type must be a string = ''interval'', ''triangle'', or ''tetrahedron''.');
            end
            
            if isempty(obj.GeoDim)
                if INT
                    obj.GeoDim = 1;
                elseif TRI
                    obj.GeoDim = 2;
                elseif TET
                    obj.GeoDim = 3;
                else
                    error('Should not be here!');
                end
            end
            if and(TRI,obj.GeoDim==1)
                disp('Domain type is ''triangle''...');
                error('Geometric dimension must be >= 2.');
            end
            if and(TET,obj.GeoDim < 3)
                disp('Domain type is ''tetrahedron''...');
                error('Geometric dimension must be == 3.');
            end
        end
        
        function obj = lt(a,b)
            %lt
            %
            %   This specifies how two domains are related (inclusion relation),
            %   i.e.  a is a subset of b.
            %
            %   NEW = a < b;
            %
            %   a,b = Level 1 Domain objects.
            %
            %   NEW = 'a', but extra information is recorded (internal to
            %         object) stating that 'a' is a subset of 'b'.
            
            if ~isa(a,'Domain')
                error('''a'' must be a Domain object!');
            end
            if ~isa(b,'Domain')
                error('''b'' must be a Domain object!');
            end

            if or(and(strcmp(b.Type,'interval'),~strcmp(a.Type,'interval')),...
                  and(strcmp(b.Type,'triangle'), strcmp(a.Type,'tetrahedron')))
                disp('The intrinsic dimension of ''a'' is greater than ''b''.');
                error('Therefore, ''a'' cannot be a subset of ''b''.');
            end
            obj = a; % init
            obj.Name = inputname(1);
            if isempty(b.Subset_Of)
                Container_Domain_Name = inputname(2);
                if or(isempty(Container_Domain_Name),strcmp(Container_Domain_Name,''))
                    disp('The container domain must have its own workspace variable.');
                    error('The ''b'' domain must be separately defined.');
                else
                    obj.Subset_Of = inputname(2);
                end
            else
                obj.Subset_Of = b.Subset_Of;
            end
            obj.GeoDim = b.GeoDim;
        end
    end
end

% END %