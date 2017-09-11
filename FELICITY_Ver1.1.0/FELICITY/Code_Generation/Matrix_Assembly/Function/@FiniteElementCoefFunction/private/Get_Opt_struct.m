function CF_Opt = Get_Opt_struct(obj)
%Get_Opt_struct
%
%   This just inits the struct fieldnames.

% Copyright (c) 04-10-2010,  Shawn W. Walker

if ~isempty(obj.FuncTrans)
    CF_Opt = obj.FuncTrans(1).Output_FUNC_Struct;
    for ind=2:length(obj.FuncTrans)
        CF_Opt(ind) = obj.FuncTrans(ind).Output_FUNC_Struct;
    end
else
    CF_Opt = [];
end

end