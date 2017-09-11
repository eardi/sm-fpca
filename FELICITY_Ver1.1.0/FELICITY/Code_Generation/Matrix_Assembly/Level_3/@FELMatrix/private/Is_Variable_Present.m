function TF = Is_Variable_Present(input_str,var_str)
%Is_Variable_Present
%
%   This identifies if the given variable name (var_str) is present in the
%   input string (input_str).

% Copyright (c) 03-14-2012,  Shawn W. Walker

TF = false; % default return value

% get length of variable string
len_var_str = length(var_str);
if length(input_str) < (len_var_str+7)
    return;
end

% keep this order!!!!  val must go last!
MATCH_STR.grad = '_v[123456789]_t[123456789]_grad[123456789]';
MATCH_STR.hess = '_v[123456789]_t[123456789]_hess[123456789][123456789]';
MATCH_STR.div  = '_t[123456789]_div';
MATCH_STR.ds   = '_v[123456789]_t[123456789]_ds';
MATCH_STR.val  = '_v[123456789]_t[123456789]';

% first see if the gradient matches
if ~isempty(regexp(input_str,[var_str, MATCH_STR.grad], 'once'))
    
    % indicate that the function was found
    TF = true;

% does the hessian match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.hess], 'once'))
    
    % indicate that the function was found
    TF = true;

% does the div match
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.div], 'once'))
    
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