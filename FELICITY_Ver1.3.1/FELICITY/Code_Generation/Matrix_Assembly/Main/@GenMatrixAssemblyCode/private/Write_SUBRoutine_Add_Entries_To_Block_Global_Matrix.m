function status = Write_SUBRoutine_Add_Entries_To_Block_Global_Matrix(obj,fid,Specific,MAT_CPP_Info,Row_Space_Num_Comp,Col_Space_Num_Comp)
%Write_SUBRoutine_Add_Entries_To_Block_Global_Matrix
%
%   This writes snippets of code for assembling many local block matrices
%   into a *big* block global FE matrix.  This is for one "specific" Domain
%   of Integration.

% Copyright (c) 06-15-2016,  Shawn W. Walker

status = 0;

ENDL = '\n';
TAB = '    ';

% SWW: need to modify this when we have more than one block!

MAT     = Specific.MAT;
RowFunc = Specific.RowFunc;
ColFunc = Specific.ColFunc;
GeoFunc = Specific.GeoFunc;

Num_Blocks = 1;
Function_Call_Defn_str = Get_Assemble_Matrix_Call(Num_Blocks,MAT_CPP_Info,GeoFunc);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* assemble a local FE matrix on the domain ', GeoFunc.Domain.Integration_Domain.Name, ' */', ENDL]);
%fprintf(fid, ['', 'void SpecificFEM::', 'Add_Entries_To_Global_Matrix(const ', GeoFunc.CPP.Data_Type_Name, '& ', 'Mesh', ')', ENDL]);
fprintf(fid, ['', 'void SpecificFEM::', Function_Call_Defn_str, ENDL]);
fprintf(fid, ['', '{', ENDL]);

% load up the row DoF indices:

% get row indices
fprintf(fid, [TAB, '// get local to global index map for the current ROW element', ENDL]);
fprintf(fid, [TAB, 'int  Row_Indices_0[ROW_NB];', ENDL]);
if isempty(RowFunc)
    fprintf(fid, [TAB, 'Row_Indices_0[0] = 0;', ENDL]);
elseif isa(RowFunc.FuncTrans,'Constant_Trans')
    fprintf(fid, [TAB, 'Row_Indices_0[0] = 0;', ENDL]); % always only 1 DoF!
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    Row_Basis_Func_str = ['Block_00->', RowFunc.CPP_Var];
    fprintf(fid, [TAB, 'const int row_elem_index = ', Row_Basis_Func_str, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, Row_Basis_Func_str, '->Get_Local_to_Global_DoFmap(row_elem_index, Row_Indices_0);', ENDL]);
end
% shift the initial indices, then the rest will get shifted automatically!
fprintf(fid, [TAB, '// shift Row_Indices_0 to account for the block matrix offset', ENDL]);
fprintf(fid, [TAB, 'for (unsigned int ri = 0; ri < ROW_NB; ++ri)', ENDL]);
fprintf(fid, [TAB, TAB, 'Row_Indices_0[ri] += Block_Row_Shift[0];', ENDL]);
fprintf(fid, ['', ENDL]);

% load up the col DoF indices:

% get col indices
fprintf(fid, [TAB, '// get local to global index map for the current COL element', ENDL]);
fprintf(fid, [TAB, 'int  Col_Indices_0[COL_NB];', ENDL]);
if isempty(ColFunc)
    fprintf(fid, [TAB, 'Col_Indices_0[0] = 0;', ENDL]);
elseif isa(ColFunc.FuncTrans,'Constant_Trans')
    fprintf(fid, [TAB, 'Col_Indices_0[0] = 0;', ENDL]); % always only 1 DoF!
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    Col_Basis_Func_str = ['Block_00->', ColFunc.CPP_Var];
    fprintf(fid, [TAB, 'const int col_elem_index = ', Col_Basis_Func_str, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, Col_Basis_Func_str, '->Get_Local_to_Global_DoFmap(col_elem_index, Col_Indices_0);', ENDL]);
end
% shift the initial indices, then the rest will get shifted automatically!
fprintf(fid, [TAB, '// shift Col_Indices_0 to account for the block matrix offset', ENDL]);
fprintf(fid, [TAB, 'for (unsigned int ci = 0; ci < COL_NB; ++ci)', ENDL]);
fprintf(fid, [TAB, TAB, 'Col_Indices_0[ci] += Block_Col_Shift[0];', ENDL]);
fprintf(fid, ['', ENDL]);

% next, sort the main Row_Indices to allow for faster lookup
if isempty(RowFunc)
    Row_NB = MAT.row_func.Elem.Num_Basis;
else
    Row_NB = RowFunc.Elem.Num_Basis;
end
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

% next, sort the main Col_Indices to allow for faster lookup
if isempty(ColFunc)
    Col_NB = MAT.col_func.Elem.Num_Basis;
else
    Col_NB = ColFunc.Elem.Num_Basis;
end
fprintf(fid, [TAB, '// sort col indices (ascending order)', ENDL]);
Local_Ind_Init_String = num2str(0);
for ib = 1:Col_NB-1
    Next_String = num2str(ib);
    Local_Ind_Init_String = [Local_Ind_Init_String, ', ', Next_String];
end
fprintf(fid, [TAB, 'int  Local_Col_Ind[COL_NB] = {', Local_Ind_Init_String, '};', ENDL]);
fprintf(fid, [TAB, 'std::sort(Local_Col_Ind, Local_Col_Ind+COL_NB,', ENDL]);
fprintf(fid, [TAB, '          [&Col_Indices_0](int kk, int qq) { return (Col_Indices_0[kk] < Col_Indices_0[qq]); });', ENDL]);
fprintf(fid, ['', ENDL]);

% determine the actual number of valid sub-matrices
Fixed_Num_SubMAT = 0;
for index = 1:MAT.Num_SubMAT
    SubMAT_VALID = ~isempty(MAT.SubMAT(index).Ccode_Frag);
    if SubMAT_VALID
        Fixed_Num_SubMAT = Fixed_Num_SubMAT + 1;
    end
end

% collect the each block column of matrices into separate sets, e.g.
% suppose the block matrix looks like this:
%     [A_00 A_01 A_02]
% A = [A_10 A_11 A_12]
%     [A_20 A_21 A_22]
%
% Then we collect the sub-matrices into 3 distinct sets:
%   {A_00, A_10, A_20},  {A_01, A_11, A_21},  {A_02, A_12, A_22}
% then loop through the first set, then the second, then third.
%
% This will make for more efficient matrix assembly
SubMAT_Sets = {};
for sub_i = 1:MAT.Num_SubMAT
    SubMAT_VALID = ~isempty(MAT.SubMAT(sub_i).Ccode_Frag);
    if SubMAT_VALID
        row_ind = MAT.SubMAT(sub_i).Row_Shift;
        col_ind = MAT.SubMAT(sub_i).Col_Shift;
        SubMAT_Sets{row_ind+1,col_ind+1} = sub_i;
    end
end
% process it further
Num_SubMAT_Sets = size(SubMAT_Sets,2);
SM_Sets = cell(1,Num_SubMAT_Sets);
for sub_i = 1:Num_SubMAT_Sets
    SM_Sets{sub_i} = cell2mat(SubMAT_Sets(:,sub_i));
end
% SM_Sets{1}
% SM_Sets{2}
% SM_Sets{3}

% allocate fixed arrays (I,J,V) for holding the big concatenated matrix
fprintf(fid, [TAB, '// allocate (I,J,V) arrays to hold "big" local matrix', ENDL]);
fprintf(fid, [TAB, 'int     COO_I[', num2str(Fixed_Num_SubMAT), '*ROW_NB*COL_NB];', ENDL]);
fprintf(fid, [TAB, 'int     COO_J[', num2str(Num_SubMAT_Sets), '*COL_NB];', ENDL]);
fprintf(fid, [TAB, 'int     COO_J_IV_Range[', num2str(Num_SubMAT_Sets), '*COL_NB + 1]; // indicates what parts I,V correspond to J', ENDL]);
fprintf(fid, [TAB, 'double  COO_V[', num2str(Fixed_Num_SubMAT), '*ROW_NB*COL_NB];', ENDL]);
fprintf(fid, ['', ENDL]);

% now fill them!  (note: these are local write operations...)
fprintf(fid, [TAB, '/* fill the (I,J,V) arrays (sorted) */', ENDL]);
fprintf(fid, ['', ENDL]);
Current_IV_Index = -1;
Current_J_Index  = -1;

% go through each block column set of sub-matrices
for ss = 1:length(SM_Sets)
    SM_Set_current = SM_Sets{ss};
    % go through each (local) column
    Num_in_Block_Col = length(SM_Set_current);
    Num_IV_in_One_Col = Num_in_Block_Col * Row_NB;
    for jj = 0:Col_NB-1
        jj_str = num2str(jj);
        fprintf(fid, [TAB, '// write column #', jj_str, ENDL]);
        % loop through each valid sub-matrix
        for SM_index = 1:Num_in_Block_Col
            index = SM_Set_current(SM_index); % get the specific SubMAT
            SubMAT_VALID = ~isempty(MAT.SubMAT(index).Ccode_Frag);
            if SubMAT_VALID
                SubMAT_ind = num2str(MAT.SubMAT(index).cpp_index);
                Local_Mat_Data_str = ['Block_00->FE_Tensor_', SubMAT_ind];
                row_ind = MAT.SubMAT(index).Row_Shift;
                col_ind = MAT.SubMAT(index).Col_Shift;
                row_ind_str = num2str(row_ind);
                col_ind_str = num2str(col_ind);
                fprintf(fid, [TAB, '// write (I,J,V) data for ', Local_Mat_Data_str, ', i.e. the (', row_ind_str, ',', col_ind_str, ') block', ENDL]);
                
                % are we just copying the matrix?
                TF_COPY_SubMAT = ~isempty(MAT.SubMAT(index).COPY_SubMAT);
                if TF_COPY_SubMAT
                    % get other matrix
                    Other_Local_Mat_Data_str = ['Block_00->FE_Tensor_', num2str(MAT.SubMAT(index).COPY_SubMAT.Use_SubMAT - 1)]; % C-style index
                    % make comment:
                    fprintf(fid, [TAB, '// actually:  copy ', Other_Local_Mat_Data_str, ' to ', Local_Mat_Data_str, ENDL]);
                    TF_STRAIGHT_COPY = ~MAT.SubMAT(index).COPY_SubMAT.Copy_Transpose; % normal straight copy
                    Actual_Local_Mat_Data_str = Other_Local_Mat_Data_str;
                else
                    % not copying another sub-block (just normal)
                    TF_STRAIGHT_COPY = true;
                    Actual_Local_Mat_Data_str = Local_Mat_Data_str;
                end
                if TF_STRAIGHT_COPY
                    fprintf(fid, [TAB, '// write the data directly', ENDL]);
                else
                    % this only works with square sub-matrices
                    if (Row_NB~=Col_NB)
                        error('Must be square matrices!  Please report this bug!');
                    end
                    fprintf(fid, [TAB, '// write the data directly (but take the transpose!)', ENDL]);
                end
                % go through all the rows in the current column
                for ii = 0:Row_NB-1
                    ii_str = num2str(ii);
                    Current_IV_Index = Current_IV_Index + 1;
                    IV_str = num2str(Current_IV_Index);
                    % do a block row shift if necessary
                    if row_ind==0
                        BRS_str = '';
                    else
                        BRS_str = [' + Block_00->', 'Row_Shift[', row_ind_str, ']'];
                    end
                    fprintf(fid, [TAB, 'COO_I[', IV_str, '] = ', 'Row_Indices_0[Local_Row_Ind[', ii_str, ']]', BRS_str, ';', ENDL]);
                    if and((SM_index==1),ii==0)
                        % only need this for the first one, because all the
                        % matrices in this set have the same columns!
                        Current_J_Index = Current_J_Index + 1;
                        J_str = num2str(Current_J_Index);
                        
                        % do a block col shift if necessary
                        if col_ind==0
                            BCS_str = '';
                        else
                            BCS_str = [' + Block_00->', 'Col_Shift[', col_ind_str, ']'];
                        end
                        fprintf(fid, [TAB, 'COO_J[', J_str, '] = ', 'Col_Indices_0[Local_Col_Ind[', jj_str, ']]', BCS_str, ';', ENDL]);
                        fprintf(fid, [TAB, 'COO_J_IV_Range[', J_str, '] = ', IV_str, ';', ENDL]);
                    end
                    
                    ord_jj_str = ['Local_Col_Ind[', jj_str, ']'];
                    ord_ii_str = ['Local_Row_Ind[', ii_str, ']'];
                    if (TF_STRAIGHT_COPY)
                        V_index_str = [ord_jj_str, '*ROW_NB', ' + ', ord_ii_str];
                        fprintf(fid, [TAB, 'COO_V[', IV_str, '] = ', Actual_Local_Mat_Data_str, '[', V_index_str, ']', ';', ENDL]);
                    else
                        % take the transpose!  Note: this only works when the
                        % sub-blocks are square matrices
                        V_index_str = [ord_ii_str, '*COL_NB', ' + ', ord_jj_str];
                        fprintf(fid, [TAB, 'COO_V[', IV_str, '] = ', Actual_Local_Mat_Data_str, '[', V_index_str, ']', ';', ENDL]);
                    end
                end
            end
            fprintf(fid, ['', ENDL]);
        end
    end
end
fprintf(fid, [TAB, 'COO_J_IV_Range[', num2str(Num_SubMAT_Sets*Col_NB), '] = ', num2str(Current_IV_Index+1), '; // end of range', ENDL]);
%%%%%%%

fprintf(fid, [TAB, '// now insert into the matrix!', ENDL]);
fprintf(fid, [TAB, 'MAT->add_entries(COO_I, COO_J, COO_J_IV_Range, COO_V, ', num2str(Num_SubMAT_Sets), '*COL_NB);', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);




% % OLD WAY!!!!
% 
% 
% MAT     = Specific.MAT;
% RowFunc = Specific.RowFunc;
% ColFunc = Specific.ColFunc;
% GeoFunc = Specific.GeoFunc;
% 
% Num_Blocks = 1;
% Function_Call_Defn_str = Get_Assemble_Matrix_Call(Num_Blocks,MAT_CPP_Info,GeoFunc);
% fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
% fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
% fprintf(fid, ['', '/* assemble a local FE matrix on the domain ', GeoFunc.Domain.Integration_Domain.Name, ' */', ENDL]);
% %fprintf(fid, ['', 'void SpecificFEM::', 'Add_Entries_To_Global_Matrix(const ', GeoFunc.CPP.Data_Type_Name, '& ', 'Mesh', ')', ENDL]);
% fprintf(fid, ['', 'void SpecificFEM::', Function_Call_Defn_str, ENDL]);
% fprintf(fid, ['', '{', ENDL]);
% % get row indices
% fprintf(fid, [TAB, '// get local to global index map for the current ROW element', ENDL]);
% fprintf(fid, [TAB, 'int  Row_Indices_0[ROW_NB];', ENDL]);
% 
% if isempty(RowFunc)
%     fprintf(fid, [TAB, 'Row_Indices_0[0] = 0;', ENDL]);
% elseif isa(RowFunc.FuncTrans,'Constant_Trans')
%     fprintf(fid, [TAB, 'Row_Indices_0[0] = 0;', ENDL]); % always only 1 DoF!
% else
%     % basis function should always access the Subdomain_Cell_Index
%     %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
%     Row_Basis_Func_str = ['Block_00->', RowFunc.CPP_Var];
%     fprintf(fid, [TAB, 'const int row_elem_index = ', Row_Basis_Func_str, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
%     fprintf(fid, [TAB, Row_Basis_Func_str, '->Get_Local_to_Global_DoFmap(row_elem_index, Row_Indices_0);', ENDL]);
% end
% % shift the initial indices, then the rest will get shifted automatically!
% fprintf(fid, [TAB, '// shift Row_Indices_0 to account for the block matrix offset', ENDL]);
% fprintf(fid, [TAB, 'for (unsigned int ri = 0; ri < ROW_NB; ++ri)', ENDL]);
% fprintf(fid, [TAB, TAB, 'Row_Indices_0[ri] += Block_Row_Shift[0];', ENDL]);
% fprintf(fid, ['', ENDL]);
% % get col indices
% fprintf(fid, [TAB, '// get local to global index map for the current COL element', ENDL]);
% fprintf(fid, [TAB, 'int  Col_Indices_0[COL_NB];', ENDL]);
% if isempty(ColFunc)
%     fprintf(fid, [TAB, 'Col_Indices_0[0] = 0;', ENDL]);
% elseif isa(ColFunc.FuncTrans,'Constant_Trans')
%     fprintf(fid, [TAB, 'Col_Indices_0[0] = 0;', ENDL]); % always only 1 DoF!
% else
%     % basis function should always access the Subdomain_Cell_Index
%     %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
%     Col_Basis_Func_str = ['Block_00->', ColFunc.CPP_Var];
%     fprintf(fid, [TAB, 'const int col_elem_index = ', Col_Basis_Func_str, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
%     fprintf(fid, [TAB, Col_Basis_Func_str, '->Get_Local_to_Global_DoFmap(col_elem_index, Col_Indices_0);', ENDL]);
% end
% % shift the initial indices, then the rest will get shifted automatically!
% fprintf(fid, [TAB, '// shift Col_Indices_0 to account for the block matrix offset', ENDL]);
% fprintf(fid, [TAB, 'for (unsigned int ci = 0; ci < COL_NB; ++ci)', ENDL]);
% fprintf(fid, [TAB, TAB, 'Col_Indices_0[ci] += Block_Col_Shift[0];', ENDL]);
% fprintf(fid, ['', ENDL]);
% 
% % generate row part:
% if isempty(RowFunc)
%     Row_NB = MAT.row_func.Elem.Num_Basis;
% else
%     Row_NB = RowFunc.Elem.Num_Basis;
% end
% if (Row_Space_Num_Comp > 1)
%     fprintf(fid, [TAB, '// compute shifted row indices', ENDL]);
%     for ic = 2:Row_Space_Num_Comp
%         ic_str = num2str(ic-1);
%         BRS_str = ['BRS_', ic_str];
%         fprintf(fid, [TAB, 'const int& ', BRS_str, ' = ', 'Block_00->', 'Row_Shift[', ic_str, '];', ENDL]);
%         %Shift_Row_str = ['Row_Shift[', ic_str, ']'];
%         Shift_Row_str = BRS_str;
%         Row_Ind_Init_String = ['(Row_Indices_0[0] + ', Shift_Row_str, ')'];
%         for ib = 2:Row_NB
%             Row_Ind_Init_String = [Row_Ind_Init_String, ', ', '(Row_Indices_0[', num2str(ib-1), '] + ', Shift_Row_str, ')'];
%         end
%         fprintf(fid, [TAB, 'const int  Row_Indices_', ic_str, '[ROW_NB] = {', Row_Ind_Init_String, '};', ENDL]);
%     end
%     fprintf(fid, ['', ENDL]);
% end
% 
% % generate col part:
% if isempty(ColFunc)
%     Col_NB = MAT.col_func.Elem.Num_Basis;
% else
%     Col_NB = ColFunc.Elem.Num_Basis;
% end
% if (Col_Space_Num_Comp > 1)
%     fprintf(fid, [TAB, '// compute shifted column indices', ENDL]);
%     for ic = 2:Col_Space_Num_Comp
%         ic_str = num2str(ic-1);
%         BCS_str = ['BCS_', ic_str];
%         fprintf(fid, [TAB, 'const int& ', BCS_str, ' = ', 'Block_00->', 'Col_Shift[', ic_str, '];', ENDL]);
%         %Shift_Col_str = ['Col_Shift[', ic_str, ']'];
%         Shift_Col_str = BCS_str;
%         Col_Ind_Init_String = ['(Col_Indices_0[0] + ', Shift_Col_str, ')'];
%         for ib = 2:Col_NB
%             Col_Ind_Init_String = [Col_Ind_Init_String, ', ', '(Col_Indices_0[', num2str(ib-1), '] + ', Shift_Col_str, ')'];
%         end
%         fprintf(fid, [TAB, 'const int  Col_Indices_', ic_str, '[COL_NB] = {', Col_Ind_Init_String, '};', ENDL]);
%     end
%     fprintf(fid, ['', ENDL]);
% end
% 
% % next, must sort the main Row_Indices to allow for faster lookup when
% % inserting multiple sub-matrices
% fprintf(fid, [TAB, '// sort row indices (ascending order)', ENDL]);
% Local_Ind_Init_String = num2str(0);
% for ib = 1:Row_NB-1
%     Next_String = num2str(ib);
%     Local_Ind_Init_String = [Local_Ind_Init_String, ', ', Next_String];
% end
% fprintf(fid, [TAB, 'int  Local_Row_Ind[ROW_NB] = {', Local_Ind_Init_String, '};', ENDL]);
% fprintf(fid, [TAB, 'std::sort(Local_Row_Ind, Local_Row_Ind+ROW_NB,', ENDL]);
% fprintf(fid, [TAB, '          [&Row_Indices_0](int kk, int qq) { return (Row_Indices_0[kk] < Row_Indices_0[qq]); });', ENDL]);
% fprintf(fid, ['', ENDL]);
% 
% % now, initialize the starting point for searching the rows in the sparse
% % data structure
% fprintf(fid, [TAB, '// store the row search start index (for more efficient searching)', ENDL]);
% fprintf(fid, [TAB, 'const mwIndex* Row_Start[COL_NB];', ENDL]);
% fprintf(fid, ['', ENDL]);
% 
% % EXAMPLE:
% % %%%%%%%
% %     /* assemble sub-matrices */
% % 
% %     // assemble FE_Tensor_0, i.e. the (0,0) block
% %     MAT->add_entries(Row_Indices_0,   Col_Indices_0,  FE_Tensor_0,
% %                      ROW_NB,          COL_NB,
% %                      Local_Row_Ind,   Row_Start,   true);
% % 
% %     // assemble FE_Tensor_1, i.e. the (1,0) block
% %     MAT->add_entries(Row_Indices_1,   Col_Indices_0,  FE_Tensor_1,
% %                      ROW_NB,          COL_NB,
% %                      Local_Row_Ind,   Row_Start,   false);
% %  etc.....
% 
% % write sub-assembly commands
% fprintf(fid, [TAB, '/* assemble sub-matrices */', ENDL]);
% fprintf(fid, ['', ENDL]);
% Current_Col_Index = -1;
% for index = 1:MAT.Num_SubMAT
%     SubMAT_VALID = ~isempty(MAT.SubMAT(index).Ccode_Frag);
%     if SubMAT_VALID
%         SubMAT_ind = num2str(MAT.SubMAT(index).cpp_index);
%         Local_Mat_Data_str = ['Block_00->FE_Tensor_', SubMAT_ind];
%         row_ind = num2str(MAT.SubMAT(index).Row_Shift);
%         col_ind = num2str(MAT.SubMAT(index).Col_Shift);
%         fprintf(fid, [TAB, '// assemble ', Local_Mat_Data_str, ', i.e. the (', row_ind, ',', col_ind, ') block', ENDL]);
%         % get correct row and column indices
%         Row_Indices_str = ['Row_Indices_', row_ind];
%         Col_Indices_str = ['Col_Indices_', col_ind];
%         
%         % are we just copying the matrix?
%         TF_COPY_SubMAT = ~isempty(MAT.SubMAT(index).COPY_SubMAT);
%         if TF_COPY_SubMAT
%             % get other matrix
%             Other_Local_Mat_Data_str = ['Block_00->FE_Tensor_', num2str(MAT.SubMAT(index).COPY_SubMAT.Use_SubMAT - 1)]; % C-style index
%             % make comment:
%             fprintf(fid, [TAB, '// copy ', Other_Local_Mat_Data_str, ' to ', Local_Mat_Data_str, ENDL]);
%             TF_STRAIGHT_COPY = ~MAT.SubMAT(index).COPY_SubMAT.Copy_Transpose; % normal straight copy
%             if (TF_STRAIGHT_COPY)
%                 fprintf(fid, [TAB, '// add in the data directly', ENDL]);
%                 fprintf(fid, [TAB, 'MAT->add_entries(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Other_Local_Mat_Data_str, ',', ENDL]);
%                 SP1              = '                 ';
%             else
%                 fprintf(fid, [TAB, '// add in the data directly (but take the transpose!)', ENDL]);
%                 fprintf(fid, [TAB, 'MAT->add_entries_transpose(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Other_Local_Mat_Data_str, ',', ENDL]);
%                 SP1              = '                           ';
%             end
%         else
%             % use direct computation
%             fprintf(fid, [TAB, 'MAT->add_entries(', Row_Indices_str, ',   ', Col_Indices_str, ',  ', Local_Mat_Data_str, ',', ENDL]);
%             SP1              = '                 ';
%         end
%         
%         fprintf(fid, [TAB, SP1, 'ROW_NB,          COL_NB,', ENDL]);
%         
%         if (Current_Col_Index~=MAT.SubMAT(index).Col_Shift)
%             % update current column shift
%             Current_Col_Index = MAT.SubMAT(index).Col_Shift;
%             reset_str = 'true'; % reset row search location
%         else
%             reset_str = 'false';
%         end
%         Arg_str =         [SP1, 'Local_Row_Ind,   Row_Start,   ', reset_str, ');'];
%         fprintf(fid, [TAB, Arg_str, ENDL]);
%         fprintf(fid, ['', ENDL]);
%     end
% end
% %%%%%%%
% 
% fprintf(fid, ['', '}', ENDL]);
% fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
% fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
% fprintf(fid, ['', ENDL]);

end