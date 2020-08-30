function TF = Is_Variable_Present(input_str,var_str)
%Is_Variable_Present
%
%   This identifies if the given variable name (var_str) is present in the
%   input string (input_str).
%
%   Note: this must be consistent with "Get_String_Match_Struct.m" under
%         @FiniteElementBasisFunction.

% Copyright (c) 03-23-2018,  Shawn W. Walker

TF = false; % default return value

% get length of variable string
if length(input_str) < (length(var_str)+6)
    return;
end

% keep this order!!!!  val must go last!
% MATCH_STR.hess        = '_v[123456789]_t[123456789]_hess[123][123]';
% MATCH_STR.grad        = '_v[123456789]_t[123456789]_grad[123]';
% MATCH_STR.div         = '_t[123456789]_div';
% MATCH_STR.vector_curl = '_v[123456789]_t[123456789]_curl';
% MATCH_STR.scalar_curl = '_t[123456789]_curl';
% MATCH_STR.dsds        = '_v[123456789]_t[123456789]_dsds';
% MATCH_STR.ds          = '_v[123456789]_t[123456789]_ds';
% MATCH_STR.val         = '_v[123456789]_t[123456789]';

% keep this order!!!!  val must go last! (can now have matrix valued!)
MATCH_STR.hess        = '_v[123456789][123456789]?_t[123456789][123456789]?_hess[123][123]';
MATCH_STR.grad        = '_v[123456789][123456789]?_t[123456789][123456789]?_grad[123]';
MATCH_STR.div         = '_t[123456789][123456789]?_div';
MATCH_STR.vector_curl = '_v[123456789][123456789]?_t[123456789][123456789]?_curl';
MATCH_STR.scalar_curl = '_t[123456789][123456789]?_curl';
MATCH_STR.dsds        = '_v[123456789][123456789]?_t[123456789][123456789]?_dsds';
MATCH_STR.ds          = '_v[123456789][123456789]?_t[123456789][123456789]?_ds';
MATCH_STR.val         = '_v[123456789][123456789]?_t[123456789][123456789]?';

% does the hessian match
if ~isempty(regexp(input_str,[var_str, MATCH_STR.hess], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the gradient matches
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.grad], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the div match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.div], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the vector_curl match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.vector_curl], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the scalar_curl match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.scalar_curl], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the dsds match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.dsds], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the ds match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.ds], 'once'))
    
    % indicate that the function was found
    TF = true;
    
% does the val match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.val], 'once'))
    
    % indicate that the function was found
    TF = true;
    
end

end