% FELICITY Class for outputting information about Finite Element Definitions
%
%   obj = FELOutputElemInfo(Elem);
%
%   Elem = element definition struct obtained by calling one of the files in the
%          ./FELICITY/Elem_Defn directory.
classdef FELOutputElemInfo
    properties (SetAccess = private)
        Elem
    end
    methods
        function obj = FELOutputElemInfo(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 arguments!');
                disp('First  is an element definition struct.');
                error('Check the arguments!');
            end
            
            Elem_Defn = varargin{1};
            obj.Elem = ReferenceFiniteElement(Elem_Defn,true);
        end
    end
end

% END %