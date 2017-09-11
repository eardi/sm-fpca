function [Global_to_Local_Indexing, Local_to_Global_Indexing] =...
                 Create_Global_Local_Index_Mapping(Ordered_Indices,Max_Global_Index)
%Create_Global_Local_Index_Mapping
%
%   This routine creates two vectors of data that act as mappings between 'local' and
%   'global' indexing.
%
%   [Global_to_Local_Indexing, Local_to_Global_Indexing] =
%              Create_Global_Local_Index_Mapping(Ordered_Indices,Max_Global_Index)
%
%   OUTPUTS
%   -------
%   Global_to_Local_Indexing:
%       A (Max_Global_Index x 1) array that maps from global indices to local
%       indices.  In other words, to get the local index corresponding to global
%       index 'j', just look at Global_to_Local_Indexing(j).  Note: some of the riws
%
%   Local_to_Global_Indexing:
%       An Nx1 array that maps from local indices to global indices.  In other words,
%       to get the global index corresponding to local index 'i', just look at
%       Local_to_Global_Indexing(i).
%       Note: 'Local_to_Global_Indexing' = 'Ordered_Indices'.
%
%   Examples:
%
%   Global_to_Local_Indexing:
%
%         (Global Indexing)     (Col)       (Local Indexing)
%          Node #1 (Row #1):      6     <-- Local Node #6
%          Node #2 (Row #2):      3     <-- Local Node #3
%          Node #3 (Row #3):      0     <-- NOT a Local Node
%          Node #4 (Row #4):      0     <-- NOT a Local Node
%          Node #5 (Row #5):      2     <-- Local Node #2
%          Node #6 (Row #6):      1     <-- Local Node #1
%          Node #7 (Row #7):      0     <-- NOT a Local Node
%          Node #8 (Row #8):      7     <-- Local Node #7
%          ...
%
%   Local_to_Global_Indexing:
%
%          (Local Indexing)     (Col)      (Global Indexing)
%          Node #1 (Row #1):      6     <-- Global Node #6
%          Node #2 (Row #2):      5     <-- Global Node #5
%          Node #3 (Row #3):      2     <-- Global Node #2
%          Node #4 (Row #4):     10     <-- Global Node #10
%          Node #5 (Row #5):     14     <-- Global Node #14
%          Node #6 (Row #6):      1     <-- Global Node #1
%          Node #7 (Row #7):      8     <-- Global Node #8
%          Node #8 (Row #8):     17     <-- Global Node #17
%          ...
%
%   INPUTS
%   ------
%   Ordered_Indices:
%       An Nx1 array of numbers considered to be indices into a global data
%       structure.  However, row i of 'Ordered_Indices' corresponds to index 'i' in
%       the local data structure.
%
%   Max_Global_Index:
%       Largest index value in the global data structure (must be greater than N).

% Copyright (c) 06-05-2007,  Shawn W. Walker

Local_to_Global_Indexing = Ordered_Indices;
Local_Index_Vec = (1:1:length(Ordered_Indices))';
Global_to_Local_Indexing = zeros(Max_Global_Index,1);
Global_to_Local_Indexing(Local_to_Global_Indexing,1) = Local_Index_Vec;

end