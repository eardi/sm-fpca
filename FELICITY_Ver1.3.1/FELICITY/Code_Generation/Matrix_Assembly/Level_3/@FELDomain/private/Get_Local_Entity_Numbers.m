function [Num_Sub, Num_DoI] = Get_Local_Entity_Numbers(obj)
%Get_Num_Local_Entities
%
%   This gets the number of local mesh entities for the subdomain and the domain
%   of integration.  Note: either may not be appropriate in some cases.

% Copyright (c) 06-06-2012,  Shawn W. Walker

Sub_TD = obj.Subdomain.Top_Dim;
Sub_CD = obj.Global.Top_Dim - Sub_TD;
Num_Sub = Get_Num_Local_Entities(Sub_TD,Sub_CD);

DoI_TD = obj.Integration_Domain.Top_Dim;
DoI_CD = Sub_TD - DoI_TD;
Num_DoI = Get_Num_Local_Entities(DoI_TD,DoI_CD);

end