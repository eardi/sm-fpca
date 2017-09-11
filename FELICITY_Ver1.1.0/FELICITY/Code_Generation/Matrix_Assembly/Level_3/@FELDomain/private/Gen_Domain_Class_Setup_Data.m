function Embed = Gen_Domain_Class_Setup_Data(obj,fid)
%Gen_Domain_Class_Setup_Data
%
%   This declares the Domain_Class::Setup_Data routine.

% Copyright (c) 06-06-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* setup access to incoming MATLAB data that represents subdomain embedding */', ENDL]);
fprintf(fid, ['void MDC::Setup_Data(const mxArray* Subdomain_Array, const mxArray* Global_Mesh_DoFmap)  // inputs', ENDL]);
fprintf(fid, ['{', ENDL]);

% if all three domains are the same, then we don't need any special subdomain
% embedding data
Embed = obj.Get_Sub_DoI_Embedding_Data;
ALL_SAME = and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI);
if ALL_SAME
    fprintf(fid, [TAB, '// just get number of cells in the global mesh because: Global==Subdomain==DoI', ENDL]);
    fprintf(fid, [TAB, 'Num_Elem = (unsigned int) mxGetM(Global_Mesh_DoFmap);', ENDL]);
else
    fprintf(fid, [TAB, '// retrieve the particular subdomain we need', ENDL]);
    fprintf(fid, [TAB, 'const unsigned int DOM_INDEX = Find_Subdomain_Array_Index(Subdomain_Array,"',...
                        obj.Global.Name, '","', obj.Subdomain.Name, '","', obj.Integration_Domain.Name,'");', ENDL]);
    fprintf(fid, [TAB, 'Parse_mxSubdomain(', 'Subdomain_Array, ', 'DOM_INDEX, ', 'mxData', ');', ENDL]);
    fprintf(fid, [TAB, '// get number of elements in the Domain of Integration (DoI)', ENDL]);
    fprintf(fid, [TAB, 'Num_Elem = (unsigned int) mxGetM(mxData.mxGlobal_Cell);', ENDL]);
    fprintf(fid, [TAB, '// parse the subdomain data into a DOMAIN_EMBEDDING_DATA struct', ENDL]);
    fprintf(fid, [TAB, 'Parse_Subdomain(Global_Mesh_DoFmap, ', 'mxData, ', 'Data);', ENDL]);
    obj.Write_Sub_DoI_Embedding_Info_in_Setup_Data(fid,Embed);
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end