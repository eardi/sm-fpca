% FELICITY class for processing level 1 user code:  Trial Functions.
%
%   obj  = Trial(Elem);
%
%   Elem = Level 1 Element object.
%
%   obj  = Trial(Elem,Domain);
%
%   Domain = Level 1 Domain object, which represents the domain that we are
%            restricting the function to.
classdef Trial < l1func
    methods
        function obj = Trial(varargin)
            if (nargin==1)
                Domain = [];
            elseif (nargin==2)
                Domain = varargin{2}; % Domain to evaluate function on
            else
                error('Not yet implemented!');
            end
            obj=obj@l1func(varargin{1},Domain);
            Element_Name = inputname(1);
            if or(isempty(Element_Name),strcmp(Element_Name,''))
                disp('The input Element must have its own workspace variable,...');
                error('i.e. Element must be separately defined.');
            else
                obj.Element.Name = Element_Name;
            end
            
            if (nargin >= 2)
                Domain_Name = inputname(2);
                if or(isempty(Domain_Name),strcmp(Domain_Name,''))
                    disp('The input Domain must have its own workspace variable,...');
                    error('i.e. Domain must be separately defined.');
                else
                    obj.Domain.Name = Domain_Name;
                end
            end
            obj = Verify_Domain_Restriction(obj);
        end
    end
end

% END %