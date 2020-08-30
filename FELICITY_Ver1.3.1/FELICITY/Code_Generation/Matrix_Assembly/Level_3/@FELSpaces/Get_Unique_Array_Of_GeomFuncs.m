function GeomFunc = Get_Unique_Array_Of_GeomFuncs(obj,Integration_Indices)
%Get_Unique_Array_Of_GeomFuncs
%
%   This returns a cell array containing a unique list of GeomFunc(s).

% Copyright (c) 01-24-2014,  Shawn W. Walker

if (nargin==1)
    Integration_Indices = (1:1:length(obj.Integration))';
end

Map_Names = containers.Map; % init

Num_Integration = length(Integration_Indices);
for ii = 1:Num_Integration
    index = Integration_Indices(ii);
    
    % DoI GeomFunc
    Main_GF = obj.Integration(index).DoI_Geom;
    Main_GF_Name = Main_GF.CPP.Identifier_Name;
    Map_Names(Main_GF_Name) = Main_GF;
    
    % GeomFunc(s) associated with basis functions
    BF      = obj.Integration(index).BasisFunc;
    BF_val  = BF.values;
    for bi = 1:length(BF_val)
        BF_GF = BF_val{bi}.GeomFunc;
        BF_GF_Name = BF_GF.CPP.Identifier_Name;
        Map_Names(BF_GF_Name) = BF_GF;
    end
    
    % other GeomFunc(s)...
    GeomFunc = obj.Integration(index).GeomFunc;
    GF_val   = GeomFunc.values;
    for gi = 1:length(GF_val)
        GF = GF_val{gi};
        GF_Name = GF.CPP.Identifier_Name;
        Map_Names(GF_Name) = GF;
    end
end

GeomFunc = Map_Names.values;

end