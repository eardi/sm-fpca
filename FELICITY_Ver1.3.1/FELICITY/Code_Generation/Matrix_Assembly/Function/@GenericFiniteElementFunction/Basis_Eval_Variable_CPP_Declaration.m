function status = Basis_Eval_Variable_CPP_Declaration(obj,NUM_PT_str,NUM_BASIS_str,fid,COMMENT)
%Basis_Eval_Variable_CPP_Declaration
%
%   This writes the C++ code for declaring the variables to hold the basis
%   function evaluations.

% Copyright (c) 10-27-2016,  Shawn W. Walker

status = 0;
ENDL = '\n';
COM_PLUS_TAB = [COMMENT, '    '];

% get info for C++ code
CPP_Type_Info  = obj.FuncTrans.Get_Reference_Basis_Function_CPP_Type_Info(obj.Opt);
CPP_Eval_Names = fieldnames(CPP_Type_Info); % get needed options

% define func for basis var declare
if isempty(NUM_PT_str)
    % there are no quad points (this must be for interpolation)
    Basis_Declare_func = @(Type_str,Basis_Name_str) [Type_str, ' ', Basis_Name_str, '[', NUM_BASIS_str, '];'];
else
    Basis_Declare_func = @(Type_str,Basis_Name_str) [Type_str, ' ', Basis_Name_str, '[', NUM_PT_str, '][', NUM_BASIS_str, '];'];
end

CPP_Name_Hdr = obj.Get_Basis_Eval_Name_CPP_Hdr([]);
for oi = 1:length(CPP_Eval_Names)
    Single_Eval_Name = CPP_Eval_Names{oi};
    Num_Vars = length(CPP_Type_Info.(Single_Eval_Name));
    for jj = 1:Num_Vars
        fprintf(fid, [COM_PLUS_TAB, '// get "', CPP_Type_Info.(Single_Eval_Name)(jj).Suffix_str, '" of basis functions', ENDL]);
        
        % write local variable declaration to hold evaluations at all quad
        % points and for all basis functions
        Basis_Name_str = [CPP_Name_Hdr, '_', CPP_Type_Info.(Single_Eval_Name)(jj).Suffix_str];
        Basis_Declare_str = Basis_Declare_func(CPP_Type_Info.(Single_Eval_Name)(jj).Type_str,Basis_Name_str);
        
        fprintf(fid, [COM_PLUS_TAB, Basis_Declare_str, ENDL]);
    end
end
fprintf(fid, ['', ENDL]);

end