function status = Gen_Domain_Class_Read_Embed_Data(obj,fid,Embed)
%Gen_Domain_Class_Read_Embed_Data
%
%   This declares the Domain_Class::Read_Embed_Data routine.

% Copyright (c) 06-06-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* read the subdomain embedding data for this domain;', ENDL]);
fprintf(fid, ['   the input is the current DoI element. */', ENDL]);
fprintf(fid, ['void MDC::Read_Embed_Data(const unsigned int& doi_elem_index)  // inputs', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, [TAB, '// read it!', ENDL]);

if Embed.Global_Cell_Index
    fprintf(fid, [TAB, 'Global_Cell_Index = Data.Global_Cell_Index[doi_elem_index] - 1; // put into C-style', ENDL]);
    % make error check on sub-domain cell index to make sure it is within range
    fprintf(fid, ['', ENDL]);
    fprintf(fid, [TAB, '// error check:  make sure doi_elem_index is >= 0 and', ENDL]);
    fprintf(fid, [TAB, '//               does not exceed the number of elements in the sub-domain', ENDL]);
    fprintf(fid, [TAB, 'if ( (doi_elem_index < 0) || (doi_elem_index >= Num_Elem) )', ENDL]);
    fprintf(fid, [TAB2, '{', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("ERROR: The number of elements (cells) in the sub-domain is %%d.\\n",Num_Elem);', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("ERROR: But the sub-domain cell index == %%d.\\n",doi_elem_index+1); // put into MATLAB style', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("ERROR: It *should* satisfy: 1 <= cell index <= %%d.\\n",Num_Elem);', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("\\n");', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("Either the subdomain embedding data is wrong,\\n");', ENDL]);
    fprintf(fid, [TAB2, 'mexPrintf("    or you have passed incorrect cell indices to this code.\\n");', ENDL]);
    fprintf(fid, [TAB2, 'mexErrMsgTxt("STOP!");', ENDL]);
    fprintf(fid, [TAB2, '}', ENDL]);
    fprintf(fid, ['', ENDL]);
else
    % this must be the case where all three domains are equal
    if and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        fprintf(fid, [TAB, 'Global_Cell_Index = doi_elem_index; // the DoI must be the Global domain (already in C-style)', ENDL]);
        % make error check on sub-domain cell index to make sure it is within range
        fprintf(fid, ['', ENDL]);
        fprintf(fid, [TAB, '// error check:  make sure Global_Cell_Index is >= 0 and', ENDL]);
        fprintf(fid, [TAB, '//               does not exceed the number of elements in the sub-domain', ENDL]);
        fprintf(fid, [TAB, 'if ( (Global_Cell_Index < 0) || ((unsigned int) Global_Cell_Index >= Num_Elem) )', ENDL]);
        fprintf(fid, [TAB2, '{', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("ERROR: The number of elements (cells) in the sub-domain is %%d.\\n",Num_Elem);', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("ERROR: But the Global_Cell_Index == %%d.\\n",Global_Cell_Index+1); // put into MATLAB style', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("ERROR: It *should* satisfy: 1 <= Global_Cell_Index <= %%d.\\n",Num_Elem);', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("\\n");', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("Either the subdomain embedding data is wrong,\\n");', ENDL]);
        fprintf(fid, [TAB2, 'mexPrintf("    or you have passed incorrect cell indices to this code.\\n");', ENDL]);
        fprintf(fid, [TAB2, 'mexErrMsgTxt("STOP!");', ENDL]);
        fprintf(fid, [TAB2, '}', ENDL]);
        fprintf(fid, ['', ENDL]);
    else
        error('Invalid!  Should not happen!');
    end
end

if Embed.Subdomain_Cell_Index
    fprintf(fid, [TAB, 'Sub_Cell_Index = Data.Sub_Cell_Index[doi_elem_index] - 1; // put into C-style', ENDL]);
else
    if and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        fprintf(fid, [TAB, 'Sub_Cell_Index = doi_elem_index; // Global==Subdomain==DoI (already in C-style)', ENDL]);
    elseif and(Embed.Global_Equal_Subdomain,~Embed.Subdomain_Equal_DoI)
        fprintf(fid, [TAB, 'Sub_Cell_Index = Global_Cell_Index; // Global==Subdomain!=DoI', ENDL]);
    elseif and(~Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        fprintf(fid, [TAB, 'Sub_Cell_Index = doi_elem_index; // Global!=Subdomain==DoI', ENDL]);
    else
        error('Invalid!  Should not happen!');
    end
end

if Embed.Subdomain_Entity_Index
    fprintf(fid, [TAB, 'Sub_Entity_Index = Data.Sub_Entity_Index[doi_elem_index];', ENDL]);
end
if Embed.DoI_Entity_Index
    fprintf(fid, [TAB, 'DoI_Entity_Index = Data.DoI_Entity_Index[doi_elem_index];', ENDL]);
end
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end