function MATCH_STR = Get_String_Match_Struct(obj)
%Get_String_Match_Struct
%
%   This is a struct containing the pattern matching strings to use for
%   identifying symbolic variables in expressions.
%
%   Note: if you modify this, then you must also modify
%         "Is_Variable_Present.m" under FELMatrix\private\
%   Note: be aware of "Parse_Vars_From_Given_Function.m" in
%         Level_1\@abstractexpr\
%         which has related stuff.

% Copyright (c) 03-23-2018,  Shawn W. Walker

% setup matching strings
% keep this order!!!!  If you search for ``val'' first, then you may mistake
% ``grad'' for ``val''
MATCH_STR.hess        = '_v[123456789][123456789]?_t[123456789][123456789]?_hess[123][123]';
MATCH_STR.grad        = '_v[123456789][123456789]?_t[123456789][123456789]?_grad[123]';
MATCH_STR.div         = '_t[123456789][123456789]?_div';
MATCH_STR.vector_curl = '_v[123456789][123456789]?_t[123456789][123456789]?_curl';
MATCH_STR.scalar_curl = '_t[123456789][123456789]?_curl';
MATCH_STR.dsds        = '_v[123456789][123456789]?_t[123456789][123456789]?_dsds';
MATCH_STR.ds          = '_v[123456789][123456789]?_t[123456789][123456789]?_ds';
MATCH_STR.val         = '_v[123456789][123456789]?_t[123456789][123456789]?';

end