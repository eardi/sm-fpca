function status = Write_Sub_DoI_Embedding_Info_in_Setup_Data(obj,fid,Embed)
%Write_Sub_DoI_Embedding_Info_in_Setup_Data
%
%   This determines the kind of Subdomain/Domain of Integration (DoI)
%   information that is needed to represent the following containment:
%   DoI  \subset  Subdomain  \subset  Global.
%   See also:  FELDomain::Get_Sub_DoI_Embedding_Data.
%
%   and then it writes that portion of the Setup_Data C++ method to read in this
%   information from MATLAB.

% Copyright (c) 06-07-2012,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

% topological dimensions
Global_TD = obj.Global.Top_Dim;
Sub_TD    = obj.Subdomain.Top_Dim;
DoI_TD    = obj.Integration_Domain.Top_Dim;

fprintf(fid, [TAB, '// check that we have the correct data', ENDL]);
fprintf(fid, [TAB, 'const bool Global_Cell_EMPTY = mxIsEmpty(mxData.mxGlobal_Cell);', ENDL]);
fprintf(fid, [TAB, 'const bool Sub_Cell_EMPTY    = mxIsEmpty(mxData.mxSub_Cell);', ENDL]);
fprintf(fid, [TAB, 'const bool Sub_Entity_EMPTY  = mxIsEmpty(mxData.mxSub_Entity);', ENDL]);
fprintf(fid, [TAB, 'const bool DoI_Entity_EMPTY  = mxIsEmpty(mxData.mxDoI_Entity);', ENDL]);
status = fprintf(fid, ['', ENDL]);

write_error_check_snippet(fid,Embed);

if or(Sub_TD > DoI_TD,Global_TD > Sub_TD)
    fprintf(fid, [TAB, '// check the entity indices', ENDL]);
end
if (Sub_TD > DoI_TD)
    fprintf(fid, [TAB, 'Error_Check_DoI_Entity_Indices(Data);', ENDL]);
end
if (Global_TD > Sub_TD)
    fprintf(fid, [TAB, 'Error_Check_Sub_Entity_Indices(Data);', ENDL]);
end

end

function write_error_check_snippet(fid,Embed)

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];

if Embed.Global_Cell_Index
    Global_Cell_STR = '(!Global_Cell_EMPTY)'; % not empty
else
    Global_Cell_STR = '(Global_Cell_EMPTY)';
end
if Embed.Subdomain_Cell_Index
    Sub_Cell_STR = '(!Sub_Cell_EMPTY)'; % not empty
else
    Sub_Cell_STR = '(Sub_Cell_EMPTY)';
end
if Embed.Subdomain_Entity_Index
    Sub_Entity_STR = '(!Sub_Entity_EMPTY)'; % not empty
else
    Sub_Entity_STR = '(Sub_Entity_EMPTY)';
end
if Embed.DoI_Entity_Index
    DoI_Entity_STR = '(!DoI_Entity_EMPTY)'; % not empty
else
    DoI_Entity_STR = '(DoI_Entity_EMPTY)';
end

fprintf(fid, [TAB, 'if ( (Num_Elem > 0) && ( !(', Global_Cell_STR, ' && ', Sub_Cell_STR,...
                         ' && ', Sub_Entity_STR, ' && ', DoI_Entity_STR, ') ) )', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR: ---> There are problems with this Subdomain:\\n");', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR:         Global Domain: %%s\\n",Global_Name);', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR:             Subdomain: %%s\\n",Sub_Name);', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR: Domain of Integration: %%s\\n",DoI_Name);', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR: See Subdomain number %%d.\\n",DOM_INDEX+1);', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("ERROR: Subdomain data must include the following information:\\n");', ENDL]);
if Embed.Global_Cell_Index
    fprintf(fid, [TAB2, 'mexPrintf("ERROR:           Global_Cell_Index.\\n");', ENDL]);
end
if Embed.Subdomain_Cell_Index
    fprintf(fid, [TAB2, 'mexPrintf("ERROR:           Subdomain_Cell_Index.\\n");', ENDL]);
end
if Embed.Subdomain_Entity_Index
    fprintf(fid, [TAB2, 'mexPrintf("ERROR:           Subdomain_Entity_Index.\\n");', ENDL]);
end
if Embed.DoI_Entity_Index
    fprintf(fid, [TAB2, 'mexPrintf("ERROR:           DoI_Entity_Index.\\n");', ENDL]);
end
fprintf(fid, [TAB2, 'mexErrMsgTxt("ERROR: Fix your subdomain embedding mesh data!");', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);

end