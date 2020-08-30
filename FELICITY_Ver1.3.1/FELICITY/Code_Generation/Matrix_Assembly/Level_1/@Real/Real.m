% FELICITY class for processing level 1 user code.
% This defines a Real (form) object.  This is for defining a small dense matrix,
% whose entries are direct evaluations of integrals of known coefficient
% functions and geometric data.
%
%   obj = Real(Num_Row,Num_Col);
%
%   Num_Row, Num_Col = the size of the matrix, i.e. the size of 'obj'.
classdef Real < genericform
    properties %(SetAccess=private,GetAccess=private)
        Name                 % String = external variable name.
    end
%     properties (SetAccess=private) %(SetAccess=private,GetAccess=private)
%     end
    methods
        function obj = Real(varargin)
            if (nargin ~= 0) % Allow nargin == 0 syntax
                if (nargin ~= 2)
                    disp('Requires 2 arguments!');
                    disp('First  is the number of rows of the matrix.');
                    disp('Second is the number of cols of the matrix.');
                    error('Check the arguments!');
                end
                OUT_str = '|---> Define Real Form...';
                disp(OUT_str);
                
                num_row = varargin{1};
                num_col = varargin{2};
                if num_row < 1
                    error('Number of rows must be positive.');
                end
                if num_col < 1
                    error('Number of cols must be positive.');
                end
                if or(num_row > 1000, num_col > 1000)
                    error('The ''Real'' class is only meant for *small* matrices...');
                end
                
                obj(num_row,num_col) = Real; % Preallocate object array
                for ii = 1:num_row
                    for jj = 1:num_col
                        obj(ii,jj).Name     = [];
                        obj(ii,jj).Integral = [];
                    end
                end
            end
        end
    end
end

% END %