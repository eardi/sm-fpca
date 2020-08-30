function COPY_SubMAT = Set_COPY_SubMAT(COPY)
%Set_COPY_SubMAT
%
%   This sets translates L2_Obj_Integral.COPY into a more convenient structure.

% Copyright (c) 04-10-2010,  Shawn W. Walker

if ~isempty(COPY)
    COPY_SubMAT.Use_SubMAT = str2num(COPY.Use_SubMAT_Index);
    if strcmp(COPY.type,'default')
        USE_Transpose = false;
    elseif strcmp(COPY.type,'transpose')
        USE_Transpose = true;
    else
        disp('Sub-Matrix COPY command should be: ''default'' or ''transpose''.');
        error('UNKNOWN copy command.  Check your code generation!');
    end
    COPY_SubMAT.Copy_Transpose = USE_Transpose;
else
    COPY_SubMAT  = [];
end

end