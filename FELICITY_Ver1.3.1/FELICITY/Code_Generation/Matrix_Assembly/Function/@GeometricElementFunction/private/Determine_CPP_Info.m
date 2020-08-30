function obj = Determine_CPP_Info(obj)
%Determine_CPP_Info
%
%   This determines the structure of the local transformations to compute.
%   This is especially necessary if the domain is of co-dimension > 0.

% Copyright (c) 05-28-2012,  Shawn W. Walker

% Example:
% ------------------------------------------
% FELDomain Object:
%          Hold_All: Info About The 'Hold-All' Domain:          
%   Domain
% 
%   Properties:
%          Name: 'Omega'
%          Type: 'triangle'
%     Subset_Of: []
%        GeoDim: 2
% 
%   Integration_Set: Info About The Domain Of Integration:        
%         Domain: [1x1 Domain]
%     Embeddings: [1x1 Domain]
%       Num_Quad: 5
% 
%         IS_CURVED: (T/F) Indicates if Higher Order Mesh Is Used                 = FALSE
%             Codim: Co-dimension of Integration Domain w.r.t. Hold-All Domain    = 1
% 
% Integration_Set.Domain:
%   Domain
% 
%   Properties:
%          Name: 'Sigma'
%          Type: 'interval'
%     Subset_Of: 'Omega'
%        GeoDim: 2
% 
% Integration_Set.Embeddings:
%   Domain
% 
%   Properties:
%          Name: 'Omega'
%          Type: 'triangle'
%     Subset_Of: []
%        GeoDim: 2

obj.CPP.Identifier_Name    = obj.GeoTrans.Name;
obj.CPP.Data_Type_Name     = ['CLASS_', obj.CPP.Identifier_Name];
obj.CPP.Data_Type_Name_cc  = [obj.CPP.Data_Type_Name, '.cc'];

end