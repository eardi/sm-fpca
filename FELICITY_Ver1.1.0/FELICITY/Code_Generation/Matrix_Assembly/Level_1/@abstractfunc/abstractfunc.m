% FELICITY (abstract) class for processing level 1 user code.
%
%   obj  = abstractfunc(Name);
%
%   Name = (string) name for the function.
%
%   obj  = abstractfunc(Name,Domain);
%
%   Domain = Level 1 Domain object.
classdef abstractfunc
    properties %(SetAccess=private,GetAccess=private)
        Name                % String = external variable name.
        Domain              % Level 1 Domain
    end
    methods
        function obj = abstractfunc(varargin)
            
            if or((nargin < 1),(nargin > 2))
                disp('Requires 1 or 2 arguments!');
                disp('First  is a Name (string).');
                disp('Second is a Level 1 Domain (optional).');
                error('Check the arguments!');
            end
            
            obj.Name = varargin{1};
            if ~isempty(obj.Name)
                if ~ischar(obj.Name)
                    error('Name must be a string!');
                end
            end
            
            if (nargin >= 2)
                obj.Domain = varargin{2};
                if ~isempty(obj.Domain)
                    if ~isa(obj.Domain,'Domain')
                        error('''Domain'' must be a Level 1 Domain object!');
                    end
                end
            else
                obj.Domain = [];
            end
        end
    end
end

% END %