function obj = Append_Domain(obj,DOM)
%Append_Domain
%
%   This appends a single Domain to the internal data struct.
%
%   obj    = obj.Append_Domain(DOM);
%
%   DOM = is an object of class Domain.

% Copyright (c) 06-13-2014,  Shawn W. Walker

Check_For_Valid_Domain(DOM);

% make sure the Domain KNOWS its name!
DOM_NAME = inputname(2);
DOM.Name = DOM_NAME;

Num_Domain = length(obj.Search_Domain);
if (Num_Domain==0)
    obj.Search_Domain = DOM;
else
    obj.Search_Domain(Num_Domain+1) = DOM;
end

end