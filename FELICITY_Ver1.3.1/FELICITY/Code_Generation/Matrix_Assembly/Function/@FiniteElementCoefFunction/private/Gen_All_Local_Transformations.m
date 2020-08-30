function status = Gen_All_Local_Transformations(obj,fid,CF_CODE)
%Gen_All_Local_Transformations
%
%   This creates the necessary transformations to compute regardless of the
%   Co-dim of the Subdomain.

% Copyright (c) 01-18-2018,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% write the definition!
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* compute the local transformation from the standard reference element', ENDL]);
fprintf(fid, ['          to an element in the Domain     */', ENDL]);
fprintf(fid, ['void SpecificFUNC::Compute_Func()', ENDL]);
fprintf(fid, ['{', ENDL]);

% only need to compute when NOT dealing with a global constant
if isa(obj.FuncTrans,'Constant_Trans')
    fprintf(fid, ['    // we read in the given constant elsewhere (and we only do it *once*)', ENDL]);
else
    fprintf(fid, ['// get current FE space element index', ENDL]);
    % the basis function should ALWAYS access the Subdomain_Cell_Index!
    % Note: this is taken care of in the FELDomain::Read_Embed_Data routine.
    fprintf(fid, ['const int elem_index = basis_func->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, ['', ENDL]);
    
    fprintf(fid, ['int kc[NB];      // for indexing through the function''s DoFmap', ENDL]);
    fprintf(fid, ['', ENDL]);
    fprintf(fid, ['basis_func->Get_Local_to_Global_DoFmap(elem_index, kc);', ENDL]);
    fprintf(fid, ['', ENDL]);
    
    status = obj.Write_Func_Computation_Code_snip(fid,CF_CODE);
    
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end