function status = Write_SUBRoutine_Add_Entries_To_Global_Matrix(obj,fid,Specific)
%Write_SUBRoutine_Add_Entries_To_Global_Matrix
%
%   This writes snippets of code for mapping gradients of basis functions from
%   the reference element to the local element.

% Copyright (c) 06-13-2016,  Shawn W. Walker

error('do not use!!!');

status = 0;

ENDL = '\n';
TAB = '    ';

MAT     = Specific.MAT;
RowFunc = Specific.RowFunc;
ColFunc = Specific.ColFunc;
GeoFunc = Specific.GeoFunc;

fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* assemble a local FEM matrix */', ENDL]);
fprintf(fid, ['', 'void SpecificFEM::Add_Entries_To_Global_Matrix(const ', GeoFunc.CPP.Data_Type_Name, '& ', 'Mesh', ')', ENDL]);
fprintf(fid, ['', '{', ENDL]);
% get row indices
fprintf(fid, [TAB, '// get local to global index map for the current ROW element', ENDL]);
fprintf(fid, [TAB, 'int  Row_Indices_0[ROW_NB];', ENDL]);
if isempty(RowFunc)
    fprintf(fid, [TAB, 'Row_Indices_0[0] = 0;', ENDL]);
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    fprintf(fid, [TAB, 'const int row_elem_index = ', RowFunc.CPP_Var, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, RowFunc.CPP_Var, '->Get_Local_to_Global_DoFmap(row_elem_index, Row_Indices_0);', ENDL]);
end
% get col indices
fprintf(fid, [TAB, '// get local to global index map for the current COL element', ENDL]);
fprintf(fid, [TAB, 'int  Col_Indices_0[COL_NB];', ENDL]);
if isempty(ColFunc)
    fprintf(fid, [TAB, 'Col_Indices_0[0] = 0;', ENDL]);
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    fprintf(fid, [TAB, 'const int col_elem_index = ', ColFunc.CPP_Var, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, ColFunc.CPP_Var, '->Get_Local_to_Global_DoFmap(col_elem_index, Col_Indices_0);', ENDL]);
end
fprintf(fid, ['', ENDL]);

% compute the shifted row and column indices (for inserting sub-matrices)

% generate row part:
if isempty(RowFunc)
    Row_NC = MAT.row_func.Elem.Num_Comp;
    Row_NB = MAT.row_func.Elem.Num_Basis;
else
    Row_NC = RowFunc.Elem.Num_Comp;
    Row_NB = RowFunc.Elem.Num_Basis;
end
if (Row_NC > 1)
    fprintf(fid, [TAB, '// compute shifted row indices', ENDL]);
    for ic = 2:Row_NC
        ic_str = num2str(ic-1);
        Shift_Row_str = ['Shift_Row_Index[', ic_str, ']'];
        Row_Ind_Init_String = ['(Row_Indices_0[0] + ', Shift_Row_str, ')'];
        for ib = 2:Row_NB
            Row_Ind_Init_String = [Row_Ind_Init_String, ', ', '(Row_Indices_0[', num2str(ib-1), '] + ', Shift_Row_str, ')'];
        end
        fprintf(fid, [TAB, 'const int  Row_Indices_', ic_str, '[ROW_NB] = {', Row_Ind_Init_String, '};', ENDL]);
    end
    fprintf(fid, ['', ENDL]);
end

% generate col part:
if isempty(ColFunc)
    Col_NC = MAT.col_func.Elem.Num_Comp;
    Col_NB = MAT.col_func.Elem.Num_Basis;
else
    Col_NC = ColFunc.Elem.Num_Comp;
    Col_NB = ColFunc.Elem.Num_Basis;
end
if (Col_NC > 1)
    fprintf(fid, [TAB, '// compute shifted column indices', ENDL]);
    for ic = 2:Col_NC
        ic_str = num2str(ic-1);
        Shift_Col_str = ['Shift_Col_Index[', ic_str, ']'];
        Col_Ind_Init_String = ['(Col_Indices_0[0] + ', Shift_Col_str, ')'];
        for ib = 2:Col_NB
            Col_Ind_Init_String = [Col_Ind_Init_String, ', ', '(Col_Indices_0[', num2str(ib-1), '] + ', Shift_Col_str, ')'];
        end
        fprintf(fid, [TAB, 'const int  Col_Indices_', ic_str, '[COL_NB] = {', Col_Ind_Init_String, '};', ENDL]);
    end
    fprintf(fid, ['', ENDL]);
end

% call the *big* tabulate tensor routine
fprintf(fid, [TAB, '/* evaluate local finite element (FE) matrix/sub-matrices */', ENDL]);
Tab_Tensor_str = ['Tabulate_Tensor(Mesh);'];
fprintf(fid, [TAB, Tab_Tensor_str, ENDL]);
fprintf(fid, ['', ENDL]);

% next, must sort the main Row_Indices to allow for faster lookup when
% inserting multiple sub-matrices
fprintf(fid, [TAB, '// sort row indices (ascending order)', ENDL]);
Local_Ind_Init_String = num2str(0);
for ib = 1:Row_NB-1
    Next_String = num2str(ib);
    Local_Ind_Init_String = [Local_Ind_Init_String, ', ', Next_String];
end
fprintf(fid, [TAB, 'int  Local_Row_Ind[ROW_NB] = {', Local_Ind_Init_String, '};', ENDL]);
fprintf(fid, [TAB, 'std::sort(Local_Row_Ind, Local_Row_Ind+ROW_NB,', ENDL]);
fprintf(fid, [TAB, '          [&Row_Indices_0](int kk, int qq) { return (Row_Indices_0[kk] < Row_Indices_0[qq]); });', ENDL]);
fprintf(fid, ['', ENDL]);

% now, initialize the starting point for searching the rows in the sparse
% data structure
fprintf(fid, [TAB, '// store the row search start index (for more efficient searching)', ENDL]);
fprintf(fid, [TAB, 'const mwIndex* Row_Start[COL_NB];', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
% %%%%%%%
%     /* assemble sub-matrices */
% 
%     // assemble FE_Tensor_0, i.e. the (0,0) block
%     MAT->add_entries(Row_Indices_0,   Col_Indices_0,  FE_Tensor_0,
%                      ROW_NB,          COL_NB,
%                      Local_Row_Ind,   Row_Start,   true);
% 
%     // assemble FE_Tensor_1, i.e. the (1,0) block
%     MAT->add_entries(Row_Indices_1,   Col_Indices_0,  FE_Tensor_1,
%                      ROW_NB,          COL_NB,
%                      Local_Row_Ind,   Row_Start,   false);
%  etc.....

% write sub-assembly commands
fprintf(fid, [TAB, '/* assemble sub-matrices */', ENDL]);
fprintf(fid, ['', ENDL]);
Current_Col_Index = -1;
for index = 1:MAT.Num_SubMAT
    SubMAT_ind = num2str(MAT.SubMAT(index).cpp_index);
    Local_Mat_Data_str = ['FE_Tensor_', SubMAT_ind];
    row_ind = num2str(MAT.SubMAT(index).Row_Shift);
    col_ind = num2str(MAT.SubMAT(index).Col_Shift);
    fprintf(fid, [TAB, '// assemble ', Local_Mat_Data_str, ', i.e. the (', row_ind, ',', col_ind, ') block', ENDL]);
    % get correct row and column indices
    Row_Indices_str = ['Row_Indices_', row_ind];
    Col_Indices_str = ['Col_Indices_', col_ind];
    
    % are we just copying the matrix?
    TF_COPY_SubMAT = ~isempty(MAT.SubMAT(index).COPY_SubMAT);
    if TF_COPY_SubMAT
        % get other matrix
        Other_Local_Mat_Data_str = ['FE_Tensor_', num2str(MAT.SubMAT(index).COPY_SubMAT.Use_SubMAT - 1)]; % C-style index
        % make comment:
        fprintf(fid, [TAB, '// copy ', Other_Local_Mat_Data_str, ' to ', Local_Mat_Data_str, ENDL]);
        TF_STRAIGHT_COPY = ~MAT.SubMAT(index).COPY_SubMAT.Copy_Transpose; % normal straight copy
        if (TF_STRAIGHT_COPY)
            fprintf(fid, [TAB, '// add in the data directly', ENDL]);
            fprintf(fid, [TAB, 'MAT->add_entries(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Other_Local_Mat_Data_str, ',', ENDL]);
            SP1              = '                 ';
        else
            fprintf(fid, [TAB, '// add in the data directly (but take the transpose!)', ENDL]);
            fprintf(fid, [TAB, 'MAT->add_entries_transpose(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Other_Local_Mat_Data_str, ',', ENDL]);
            SP1              = '                           ';
        end
    else
        % use direct computation
        fprintf(fid, [TAB, 'MAT->add_entries(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Local_Mat_Data_str, ',', ENDL]);
        SP1              = '                 ';
    end
    
    fprintf(fid, [TAB, SP1, 'ROW_NB,          COL_NB,', ENDL]);
    
    if (Current_Col_Index~=MAT.SubMAT(index).Col_Shift)
        % update current column shift
        Current_Col_Index = MAT.SubMAT(index).Col_Shift;
        reset_str = 'true'; % reset row search location
    else
        reset_str = 'false';
    end
    Arg_str =         [SP1, 'Local_Row_Ind,   Row_Start,   ', reset_str, ');'];
    fprintf(fid, [TAB, Arg_str, ENDL]);
    fprintf(fid, ['', ENDL]);
end
%%%%%%%

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

end