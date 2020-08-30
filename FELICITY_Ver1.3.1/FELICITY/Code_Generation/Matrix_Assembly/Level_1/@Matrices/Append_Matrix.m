function obj = Append_Matrix(obj,Matrix)
%Append_Matrix
%
%   This appends a single matrix (form) to the internal data struct.
%
%   obj    = obj.Append_Matrix(Matrix);
%
%   Matrix = is a genericform object (i.e. Bilinear, Linear, or Real object).

% Copyright (c) 08-01-2011,  Shawn W. Walker

Check_For_Valid_Matrix(Matrix);

% make sure the matrix KNOWS its name!
num_row = size(Matrix,1);
num_col = size(Matrix,2);
M_NAME = inputname(2);

% note: we need to loop when the matrix is the ``Real'' class
for ii = 1:num_row
    for jj = 1:num_col
        % store the external workspace name of the matrix
        Matrix(ii,jj).Name = M_NAME;
        
        % Error Check: make sure the form has an integral defined!
        Num_ID = length(Matrix(ii,jj).Integral);
        Num_Undefined = 0;
        if (Num_ID==0)
            if ~isa(Matrix(ii,jj),'Real')
                disp(['The matrix ''', M_NAME, '''', ' has no integral defined.']);
                error('You must define an integral!');
            else
                % keep track of the number of undefined
                Num_Undefined = Num_Undefined + 1;
            end
        end
    end
end

% verify that an integral was defined
if and(isa(Matrix,'Real'), Num_Undefined==(num_row*num_col))
    % then this must be a Real matrix with all entries zero
    disp(['The Real matrix ''', M_NAME, ' has no integrals defined.']);
    error('You must define at least one integral for at least one of the matrix components!');
end

% store the matrix (form)
Num_MD = length(obj.Matrix_Data);
if (Num_MD==0)
    obj.Matrix_Data{1} = Matrix;
else
    obj.Matrix_Data{Num_MD+1} = Matrix;
end

end