% FELICITY Class for accessing FE matrices by name only.
%
%   obj  = FEMatrixAccessor(Name,FEM);
%
%   Name = (string) name for the set of matrices.
%   FEM  = array of FEM structs as output from a FELICITY auto-generated matrix
%          assembly routine.
%          FEM(i).Type = string representing name of the matrix.
%          FEM(i).MAT  = matrix data (most likely sparse).
classdef FEMatrixAccessor
    properties (SetAccess='private')%(SetAccess='private',GetAccess='private')
        Name              % name for the set of matrices
        FEM               % array of structs containing FEM data
    end
    properties (SetAccess='private',GetAccess='private')
        Matrix_Name_Map   % map keys
    end
    methods
        function obj = FEMatrixAccessor(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is an appropriate name for the set of matrices.');
                disp('Second is an array of structs containing FEM matrix data.');
                error('Check the arguments!');
            end
            
            obj.Name  = varargin{1};
            obj.FEM   = varargin{2};
            
            if ~ischar(obj.Name)
                error('Name is not a string!');
            end
            fields = isfield(obj.FEM,{'Type','MAT'});
            if (min(fields)==0)
                error('FEM must be a struct with fields .Type and .FEM!');
            end
            if ~ischar(obj.FEM(1).Type)
                error('Fields should be a string!');
            end
            if ~isnumeric(obj.FEM(1).MAT)
                error('Matrix data should be numeric!');
            end
            
            obj.Matrix_Name_Map = containers.Map();
            % init
            for ind = 1:length(obj.FEM)
                obj.Matrix_Name_Map(obj.FEM(ind).Type) = ind;
            end
        end
    end
end

% END %