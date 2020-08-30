function Specific_GeomFunc = Find_GeomFuncs_For_FEM_Matrix(SpecificMAT,GeomFunc)
%Find_GeomFuncs_For_FEM_Matrix
%
%   This just determines which geometric function mappings to use in the matrix
%   assembly for this particular FEM matrix.

% Copyright (c) 04-07-2010,  Shawn W. Walker

GF_Indices = []; % init

for ind = 1:SpecificMAT.Num_SubMAT
for gi = 1:length(GeomFunc)
    if strcmp(SpecificMAT.SubMAT(ind).GeomFunc_CPP.Identifier_Name,GeomFunc(gi).CPP.Identifier_Name)
        GF_Indices = [gi; GF_Indices];
    end
end
end

GF_Indices = unique(GF_Indices); % don't need any repeats

Specific_GeomFunc = GeomFunc(GF_Indices);

end