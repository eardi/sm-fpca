function SS = Get_Sub_DoI_Embedding_Struct()
%Get_Sub_DoI_Embedding_Struct
%
%   This returns a struct, whose fields have boolean values.

% Copyright (c) 06-07-2012,  Shawn W. Walker

SS.Global_Cell_Index        = false;
SS.Subdomain_Cell_Index     = false;
SS.Subdomain_Entity_Index   = false;
SS.DoI_Entity_Index         = false;
SS.Global_Equal_Subdomain   = false;
SS.Subdomain_Equal_DoI      = false;

end