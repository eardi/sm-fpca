function Opt = Resolve_PHI_Dependencies(obj,Opt)
%Resolve_PHI_Dependencies
%
%   This sets the fields in the given struct to true if they are needed to
%   compute other (field) quantities.

% Copyright (c) 02-20-2012,  Shawn W. Walker

NewOpt = obj.set_struct_dependencies(Opt);

while ~isequal(NewOpt,Opt)
    Opt = NewOpt; % update
    NewOpt = obj.set_struct_dependencies(Opt);
end

% output!
Opt = NewOpt;

end