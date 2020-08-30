function VALID = Check_ARG(ARG)
%Check_ARG
%
%   This verifies that ARG has a valid value.  Used for error checking in other routines.
%
%   ARG can be an empty matrix, a positive integer (1x1 or 1x2 row vector),
%   or the string 'all'.  Nothing else is allowed!

% Copyright (c) 03-26-2018,  Shawn W. Walker

VALID = true; % init

if ~isempty(ARG)
    
    if min(isnumeric(ARG))
        DIFF = max(abs(ARG - floor(ARG)));
        if (DIFF~=0)
            VALID = false;
        elseif (min(ARG) <= 0)
            VALID = false;
        end
    else
        if ~strcmpi(ARG,'all')
            VALID = false;
        end
    end
    
end

if ~VALID
    err = FELerror;
    err = err.Add_Comment('The extra argument is not valid!');
    err = err.Add_Comment('It must either be absent, an empty matrix,');
    err = err.Add_Comment('        a positive integer, or the string ''all''.');
    err.Error;
    error('stop!');
end

end