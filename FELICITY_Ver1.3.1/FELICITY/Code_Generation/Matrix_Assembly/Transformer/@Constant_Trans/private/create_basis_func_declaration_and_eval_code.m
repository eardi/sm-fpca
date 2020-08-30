function CODE = create_basis_func_declaration_and_eval_code(obj,Var_Str,TYPE_str,Eval_Str,...
                                                 Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_TF)
%create_basis_func_declaration_and_eval_code
%
%   Setup struct to contain declaration code and evaluation code.

% Copyright (c) 01-11-2018,  Shawn W. Walker

% create struct (init)
CODE.Var_Name.line = Var_Str;
CODE.Constant  = CONST_TF; % is the variable a constant (does not vary over the quad points)
CODE.Defn      = [];
CODE.Eval_Snip = [];

% create declaration code
CODE.Defn(2).line = [];
CODE.Defn(1).line = Defn_Hdr;

% if CODE.Constant % variable is constant!
%     NQ_str = '[1]';
% else
%     NQ_str = '[NQ]';
% end

% number of basis functions!
CODE.Defn(2).line = [TYPE_str, ' ', CODE.Var_Name(1).line, ';'];

% create evaluation code
num_eval = length(Eval_Str(:));
CODE.Eval_Snip(num_eval+5).line = [];
CODE.Eval_Snip(1).line = Loop_Hdr;
TAB = '    ';
CODE.Eval_Snip(2).line = '// evaluate at one point';
%CODE.Eval_Snip(3).line = 'for (int qp_i = 0; (qp_i < 1); qp_i++)';

% write the body of the loop!
CODE.Eval_Snip(3).line = '    {';
if ~isempty(Loop_Comment)
    CODE.Eval_Snip(4).line = [TAB, Loop_Comment];
else
    CODE.Eval_Snip(4).line = [TAB, '//'];
end
% write the code for declaring the reference variable
for ind=1:num_eval
    CODE.Eval_Snip(ind+4).line = [TAB, Eval_Str(ind).line];
end
CODE.Eval_Snip(num_eval+5).line = '    }';

end