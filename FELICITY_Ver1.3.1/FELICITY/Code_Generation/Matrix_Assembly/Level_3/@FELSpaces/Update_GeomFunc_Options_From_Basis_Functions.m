function obj = Update_GeomFunc_Options_From_Basis_Functions(obj,Integration_Index)
%Update_GeomFunc_Options_From_Basis_Functions
%
%   This updates what needs to be computed in the C++ code for the geometric
%   functions in order to compute all the basis function transformations.

% Copyright (c) 01-23-2014,  Shawn W. Walker

All_BF   = obj.Integration(Integration_Index).BasisFunc;
BF_Names = All_BF.keys;

% update the internal geometric function of each basis function
for bi = 1:length(BF_Names)
    
    % parse out
    Current_BasisFunc = All_BF(BF_Names{bi});
    Basis_Func_Opt = Current_BasisFunc.Opt;
    
    % update the geometric options in the GeomFunc associated with the basis function
    Current_BasisFunc.GeomFunc.Opt = Current_BasisFunc.FuncTrans.Update_Geometric_Options(...
                                       Basis_Func_Opt,Current_BasisFunc.GeomFunc.Opt);
    % save it
    All_BF(BF_Names{bi}) = Current_BasisFunc;
end

% next, update the Domain of Integration (DoI) geometric function, if necessary.
DoI_GeomFunc = obj.Integration(Integration_Index).DoI_Geom;
[All_BF, DoI_GeomFunc] = enforce_consistent_geometric_function(BF_Names,All_BF,DoI_GeomFunc);
% don't forget to put it back into the object
obj.Integration(Integration_Index).DoI_Geom  = DoI_GeomFunc;

% now update any other geometric functions, if necessary
GF_Names = obj.Integration(Integration_Index).GeomFunc.keys;
for gi = 1:length(GF_Names)
    Single_GF = obj.Integration(Integration_Index).GeomFunc(GF_Names{gi});
    [All_BF, Single_GF] = enforce_consistent_geometric_function(BF_Names,All_BF,Single_GF);
    % don't forget to put it back into the object
    obj.Integration(Integration_Index).GeomFunc(GF_Names{gi}) = Single_GF;
end

% don't forget to put it back into the object
obj.Integration(Integration_Index).BasisFunc = All_BF;

% disp('==========BEGIN GROUP==============');
% disp('   ');
% 
% % PRINT the internal geometric function of each basis function
% for bi = 1:length(BF_Names)
%     
%     % parse out
%     Current_BasisFunc = All_BF(BF_Names{bi});
% disp('==========START==============');
%     Current_BasisFunc.Func_Name
%     Current_BasisFunc.GeomFunc
% end

end

function [All_BF, GeomFunc] = enforce_consistent_geometric_function(BF_Names,All_BF,GeomFunc)

% make sure the individual basis functions that use the same
% geometric function *share* the same options
for bi = 1:length(BF_Names)
    Current_BasisFunc = All_BF(BF_Names{bi});
    for oi = 1:length(BF_Names)
        if (oi~=bi)
            Other_BasisFunc = All_BF(BF_Names{oi});
            % if the basis function's geom_func matches the other geom_func
            if strcmp(Current_BasisFunc.GeomFunc.CPP.Identifier_Name,Other_BasisFunc.GeomFunc.CPP.Identifier_Name)
                % OR the options together
                Current_BasisFunc.GeomFunc = Current_BasisFunc.GeomFunc.OR_Options(Other_BasisFunc.GeomFunc);
                All_BF(BF_Names{bi}) = Current_BasisFunc;
            end
        end
    end
end

% sometimes, the geometric function for a basis function IS THE SAME as another
% geometric function, such as the integration domain's (DoI) geometric function or some
% other (sub-)domain's geometric function.  In this case, we must ensure that
% both versions (the domain version and the basis function version) have the same options!

Domain_GF_Name = GeomFunc.CPP.Identifier_Name;

for bi = 1:length(BF_Names)
    Current_BasisFunc = All_BF(BF_Names{bi});
    % if the basis function's geom_func matches the domain geom_func
    if strcmp(Domain_GF_Name,Current_BasisFunc.GeomFunc.CPP.Identifier_Name)
        % OR the options together
        GeomFunc = GeomFunc.OR_Options(Current_BasisFunc.GeomFunc);
    end
end
% so now the GeomFunc contains all the options for the domain and ALL of the basis functions

% make sure the basis function versions have the SAME geom options as the domain version
for bi = 1:length(BF_Names)
    Current_BasisFunc = All_BF(BF_Names{bi});
    % if the basis function's geom_func matches the domain geom_func
    if strcmp(Domain_GF_Name,Current_BasisFunc.GeomFunc.CPP.Identifier_Name)
        Current_BasisFunc.GeomFunc.Opt = GeomFunc.Opt; % set them equal
        All_BF(BF_Names{bi}) = Current_BasisFunc;
    end
end

end