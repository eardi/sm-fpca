function status = Gen_All_Local_Transformations(obj,fid,BF_CODE,Premap_CODE)
%Gen_All_Local_Transformations
%
%   This creates the necessary transformations for computing with or without
%   subdomains of Codim > 0.

% Copyright (c) 04-07-2010,  Shawn W. Walker

status = obj.Gen_Local_Transformations_Code(fid,BF_CODE,Premap_CODE);

end