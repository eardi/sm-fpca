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
else
    % this must be the case where all three domains are equal
    if and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        fprintf(fid, [TAB, 'Global_Cell_Index = doi_elem_index; // the DoI must be the Global domain (already in C-style)', ENDL]);
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