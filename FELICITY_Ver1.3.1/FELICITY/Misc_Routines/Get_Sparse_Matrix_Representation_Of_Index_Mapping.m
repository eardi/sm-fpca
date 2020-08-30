function A_MAT = Get_Sparse_Matrix_Representation_Of_Index_Mapping(Index_Vec_J,Max_J_Index,...
                                                                   Index_Vec_I,Max_I_Index)
%Get_Sparse_Matrix_Representation_Of_Index_Mapping
%
%   This routine creates a sparse rectangular matrix that represents a
%   mapping, i.e. a kind of permutation matrix, e.g.
%
%        J = (4, 2, 1, 3, ..., 23) ----> (3, 7, 2, 5, ..., 56) = I
%
%   i.e.  A = [0, 0, 0, 0, ...;
%              1, 0, 0, 0, ...;
%              0, 0, 0, 1, ...;
%              0, 0, 0, 0, ...;
%              0, 0, 1, 0, ...;
%              0, 0, 0, 0, ...;
%              0, 1, 0, 0, ...;
%              ...
%  (56th row)  0, 0, 0, 0, ... 1 (23rd col)],
%
%   where   A_{ij} = 1,  if   j ----> i,
%           A_{ij} = 0,  else.
%
%   and A is a sparse, QxT matrix, where  Q >= max value in the output of
%   the map, i.e. max(I), and T >= max value in the input of the map,
%   i.e. max(J).  Typically, Q = max value in I, T = max value in J, but
%   this is not necessary.
%
%   Note:  I and J must be sets of positive integers.
%
%   EXAMPLE: let T = M = length(I) = length(J), suppose I = (1,2,3,4,...,M),
%   and let V be an Mx1 vector of real numbers ordered so that they
%   correspond to the indexing in J.  We want to reorder V into an Mx1
%   vector W that corresponds to the indexing in I.  This is achieved by:
%
%                            W = A*V
%
%   A_MAT = Get_Sparse_Matrix_Representation_Of_Index_Mapping(...
%                      Index_Vec_J,Max_J_Index)
%
%   OUTPUTS
%   -------
%   A_MAT:
%       The sparse MxT matrix described above.
%
%   INPUTS
%   ------
%   Index_Vec_J:
%       An Mx1 vector of positive integers representing the input indices, e.g.
%
%                    Index_Vec_J
%          (Row #1):      4
%          (Row #2):      2
%          (Row #3):      1
%          (Row #4):      3
%                       ...
%          (Row #M):     23
%
%   Max_J_Index:
%       (optional) this is the value of T, i.e. an integer that must be
%                  >= max(Index_Vec_J).   If omitted, then
%                            Max_J_Index := max(Index_Vec_J).
%
%   NOTE: in the above calling procedure, it is assumed that Index_Vec_I
%         has the form:  I = (1, 2, 3, 4, 5, ..., M).
%
%   another option if I has an arbitrary form:
%
%   A_MAT = Get_Sparse_Matrix_Representation_Of_Index_Mapping(...
%                      Index_Vec_J,Max_J_Index,Index_Vec_I,Max_I_Index)
%
%   OUTPUTS
%   -------
%   A_MAT:
%       The sparse QxT matrix described above.
%
%   INPUTS
%   ------
%   Index_Vec_J: An Mx1 vector of positive integers representing the input
%                indices (similar to above).
%
%   Max_J_Index: (NOT optional) this is the value of T (see above).
%
%   Index_Vec_I:
%       An Mx1 vector of positive integers representing the output indices, e.g.
%
%                    Index_Vec_I
%          (Row #1):      3
%          (Row #2):      7
%          (Row #3):      2
%          (Row #4):      5
%                       ...
%          (Row #M):     56
%
%   Max_I_Index:
%       (optional) this is the value of Q, i.e. an integer that must be
%                  >= max(Index_Vec_I).   If omitted, then
%                            Max_I_Index := max(Index_Vec_I).

% Copyright (c) 08-25-2019,  Shawn W. Walker

if or(min(Index_Vec_J) < 1, max(abs(Index_Vec_J - round(Index_Vec_J)))~=0 )
    error('The J vector should contain positive integers.');
end
max_J = max(Index_Vec_J);
if (nargin < 2)
    Max_J_Index = max_J;
end
if (Max_J_Index < max_J)
    error('The maximum input index should be >= max(Index_Vec_J).');
end

if (nargin < 3)
    Index_Vec_I = (1:1:length(Index_Vec_J))';
end
if or(min(Index_Vec_I) < 1, max(abs(Index_Vec_I - round(Index_Vec_I)))~=0 )
    error('The I vector should contain positive integers.');
end
max_I = max(Index_Vec_I);
if (nargin < 4)
    Max_I_Index = max_I;
end
if (Max_I_Index < max_I)
    error('The maximum output index should be >= max(Index_Vec_I).');
end
if (length(Index_Vec_J)~=length(Index_Vec_I))
    error('Both Index_Vec_I and Index_Vec_J must have the same length.');
end

num_row = Max_I_Index;
num_col = Max_J_Index;

% put it into a sparse matrix
VAL_ARR = ones(length(Index_Vec_I),1);
A_MAT = sparse(Index_Vec_I,Index_Vec_J,VAL_ARR,num_row,num_col);

end