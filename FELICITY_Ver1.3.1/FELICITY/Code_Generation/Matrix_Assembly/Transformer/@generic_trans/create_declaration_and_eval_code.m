function CODE = create_declaration_and_eval_code(obj,Var_Str,TYPE_str,Eval_Str,...
                                                 Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_TF)
%create_declaration_and_eval_code
%
%   Setup struct to contain declaration code and quad-loop evaluation code.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% create struct (init)
CODE.Var_Name  = Var_Str;
CODE.Constant  = CONST_TF; % is the variable a constant (does not vary over the quad points)
CODE.Defn      = [];
CODE.Eval_Snip = [];

% create declaration code
Len_Var_Str = length(CODE.Var_Name(:));
if (Len_Var_Str~=1)
    error('Should only be ONE variable!');
end
CODE.Defn(2).line = [];
CODE.Defn(1).line = Defn_Hdr;
if CODE.Constant % variable is constant!
    NQ_str = '[1]';
else
    NQ_str = '[NQ]';
end
CODE.Defn(2).line = [TYPE_str, ' ', CODE.Var_Name(1).line, NQ_str, ';'];

% create evaluation code
num_eval = length(Eval_Str(:));
CODE.Eval_Snip(num_eval+7).line = [];
CODE.Eval_Snip(1).line = Loop_Hdr;
TAB = '    ';
if CODE.Constant % variable is constant!
    CODE.Eval_Snip(2).line = '// evaluate at one point';
    CODE.Eval_Snip(3).line = 'for (int qp_i = 0; (qp_i < 1); qp_i++)';
else
    CODE.Eval_Snip(2).line = '// loop through quad points';
    CODE.Eval_Snip(3).line = 'for (int qp_i = 0; (qp_i < Num_QP); qp_i++)';
end

% write the body of the loop!
CODE.Eval_Snip(4).line = '    {';
if ~isempty(Loop_Comment)
    CODE.Eval_Snip(5).line = [TAB, Loop_Comment];
else
    CODE.Eval_Snip(5).line = [TAB, '//'];
end
% write the code for declaring the reference variable
CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
CODE.Eval_Snip(6).line = [TAB, TYPE_str, '& ', CPP_REF_Var_str, ' = ', CODE.Var_Name(1).line, '[qp_i];'];
for ind=1:num_eval
    CODE.Eval_Snip(ind+6).line = [TAB, Eval_Str(ind).line];
end
CODE.Eval_Snip(num_eval+7).line = '    }';

end