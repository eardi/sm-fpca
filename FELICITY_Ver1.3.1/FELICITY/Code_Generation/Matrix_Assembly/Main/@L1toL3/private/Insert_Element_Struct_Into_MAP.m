function MAP = Insert_Element_Struct_Into_MAP(Func_Element,MAP)
%Insert_Element_Struct_Into_MAP
%
%   This inserts a struct describing an FE space into a MAP container.
%   This is useful for getting a UNIQUE list of FE spaces.

% Copyright (c) 05-29-2012,  Shawn W. Walker

if ~isa(Func_Element,'Element')
    error('Must be an object of type Element!');
end

ES.Domain      = Func_Element.Domain;
ES.Space_Name  = Func_Element.Name;
ES.Elem        = Func_Element.Elem;
ES.Tensor_Comp = Func_Element.Tensor_Comp;

if ismember(ES.Space_Name,MAP.keys)
    % if that space's name has already been used, then make sure the
    % struct matches what was used before!
    if ~isequal(ES,MAP(ES.Space_Name))
        % if it doesn't match, then the user was doing things he shouldn't!
        disp(['ERROR: This Element was redefined: ', ES.Space_Name]);
        error('You should not redefine an Element!');
    end
end
MAP(ES.Space_Name) = ES;

end