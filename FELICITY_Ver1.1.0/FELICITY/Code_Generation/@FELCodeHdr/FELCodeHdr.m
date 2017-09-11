% this class is for copying static pieces of code (i.e. header files).
%
%   obj  = FELCodeHdr;
classdef FELCodeHdr
    properties %(SetAccess='private',GetAccess='private')
        Dir                     % struct containing directory names
    end
    methods
        function obj = FELCodeHdr(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            obj.Dir = [];
            obj = Setup_Dirs(obj);
        end
    end
end

% END %