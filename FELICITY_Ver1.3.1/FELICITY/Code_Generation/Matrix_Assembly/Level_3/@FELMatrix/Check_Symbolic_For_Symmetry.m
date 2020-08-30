function SYMM = Check_Symbolic_For_Symmetry(obj,Symbolic,v_str,u_str)
%Check_Symbolic_For_Symmetry
%
%   This will check the symbolic expression to see if it is symmetric with
%   respect to the v and u variables.
%   NOTE: Symbolic may contain many variables.  But this routine assumes that
%   there is only (at most) one variable involving ``v'' and (at most) one
%   variable involving ``u''.

% Copyright (c) 06-03-2012,  Shawn W. Walker

SYMM = false; % default value

if ~strcmp(obj.row_func.Space_Name,obj.col_func.Space_Name)
    % if the spaces are NOT the same, then it cannot be symmetric
    return;
end

Var_Names = symvar(Symbolic);
Num_Vars = length(Var_Names);

% identify the v variable; there is only one (at most)
v_arg = [];
TF = false;
for ind = 1:Num_Vars
    input_str = char(Var_Names(ind));
    TF = Is_Variable_Present(input_str,v_str);
    if TF
        v_arg   = input_str;
        break;
    end
end
if ~TF
    return;
end
% identify the u variable; there is only one (at most)
u_arg = [];
TF = false;
for ind = 1:Num_Vars
    input_str = char(Var_Names(ind));
    TF = Is_Variable_Present(input_str,u_str);
    if TF
        u_arg   = input_str;
        break;
    end
end
if ~TF
    return;
end

% check that interchanging the arguments for the variables keeps them the same
LEN_u_str = length(u_str);
LEN_v_str = length(v_str);
v_arg_swap = [v_str, u_arg(LEN_u_str+1:end)]; % put u's arguments with v
u_arg_swap = [u_str, v_arg(LEN_v_str+1:end)]; % put v's arguments with u
if ~and(strcmp(v_arg_swap,v_arg),strcmp(u_arg_swap,u_arg))
    % if switching doesn't keep them the same, then it cannot be symmetric!
    return;
end

% now check that swapping the variables in the expression does not change the
% expression
New_Sym = Symbolic;
% change symbols for convenience
New_Sym = subs(New_Sym,v_arg,[v_arg, 'XXX']);
New_Sym = subs(New_Sym,u_arg,[u_arg, 'XXX']);
% now swap
New_Sym = subs(New_Sym,[v_arg, 'XXX'],u_arg);
New_Sym = subs(New_Sym,[u_arg, 'XXX'],v_arg);

% compare
Sym_str     = char(Symbolic);
New_Sym_str = char(New_Sym);

if strcmp(Sym_str,New_Sym_str)
    SYMM = true;
end

end