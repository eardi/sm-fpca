function Opt = Resolve_FUNC_Dependencies(obj,Opt)
%Resolve_FUNC_Dependencies
%
%   This sets the fields in the given struct to true if they are needed to
%   compute other (field) quantities.

% Copyright (c) 03-22-2018,  Shawn W. Walker

NewOpt = obj.set_struct_dependencies(Opt);

while ~isequal(NewOpt,Opt)
    Opt = NewOpt; % update
    NewOpt = obj.set_struct_dependencies(Opt);
end

% output!
Opt = NewOpt;

end