function status = Write_SUBRoutine_Add_Entries_To_Global_Matrix(obj,fid,Specific)
%Write_SUBRoutine_Add_Entries_To_Global_Matrix
%
%   This writes snippets of code for mapping gradients of basis functions from
%   the reference element to the local element.

% Copyright (c) 06-20-2012,  Shawn W. Walker

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
if isempty(RowFunc)
    fprintf(fid, [TAB, 'Row_Indices[0] = 0;', ENDL]);
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    fprintf(fid, [TAB, 'const int row_elem_index = ', RowFunc.CPP_Var, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, RowFunc.CPP_Var, '->Get_Local_to_Global_DoFmap(row_elem_index, Row_Indices);', ENDL]);
end
% get col indices
fprintf(fid, [TAB, '// get local to global index map for the current COL element', ENDL]);
if isempty(ColFunc)
    fprintf(fid, [TAB, 'Col_Indices[0] = 0;', ENDL]);
else
    % basis function should always access the Subdomain_Cell_Index
    %       (see FELDomain::Gen_Domain_Class_Read_Embed_Data)
    fprintf(fid, [TAB, 'const int col_elem_index = ', ColFunc.CPP_Var, '->Mesh->Domain->Sub_Cell_Index;', ENDL]);
    fprintf(fid, [TAB, ColFunc.CPP_Var, '->Get_Local_to_Global_DoFmap(col_elem_index, Col_Indices);', ENDL]);
end
fprintf(fid, ['', ENDL]);

% NOTE: make sure you assemble the sub-matrices FIRST that are then copied
% later...
SubMAT_COPY_List = zeros(MAT.Num_SubMAT,2);
for i1 = 1:MAT.Num_SubMAT
    TF_COPY_SubMAT = ~isempty(MAT.SubMAT(i1).COPY_SubMAT);
    if TF_COPY_SubMAT
        SubMAT_COPY_List(i1,:) = [i1, MAT.SubMAT(i1).COPY_SubMAT.Use_SubMAT];
    else
        SubMAT_COPY_List(i1,:) = [i1, 0];
    end
end
% now search the list and ensure that all of the matrices that are NOT copied
% from anything are done first!
SubMAT_COPY_List_Sorted = sortrows(SubMAT_COPY_List,2);
if (SubMAT_COPY_List_Sorted(1,2)~=0)
    error('SubMAT to copy from does NOT exist!');
end
SubMAT_Order_List = SubMAT_COPY_List_Sorted; % init

% now order the list so that it is guaranteed that sub-matrices are copied from
% PREVIOUSLY computed sub-matrices
NOT_DONE = true;
% Test Code:
% SubMAT_Order_List = SubMAT_Order_List(randperm(size(SubMAT_Order_List,1)),:);
% SubMAT_Order_List
while NOT_DONE
    NOT_DONE = false;
    for i1 = 1:MAT.Num_SubMAT
        if (SubMAT_Order_List(i1,2)~=0)
            TF1 = ismember(SubMAT_Order_List(i1,2),SubMAT_Order_List(1:i1-1,1));
            if ~TF1
                [TF2, LOC2] = ismember(SubMAT_Order_List(i1,2),SubMAT_Order_List(:,1));
                if ~TF2
                    error('SubMAT to copy from does NOT exist!');
                else
                    TEMP = SubMAT_Order_List(i1,:);
                    SubMAT_Order_List(i1,:) = SubMAT_Order_List(LOC2(TF2),:);
                    SubMAT_Order_List(LOC2(TF2),:) = TEMP;
                    NOT_DONE = true;
                    break;
                end
            end
        end
    end
end
% SubMAT_Order_List
% disp('====================');

% EXAMPLE:
%%%%%%%
%     Tabulate_Tensor_0(SubMAT_Info[0].Local_Mat_Data);
%     MAT->add_entries(Row_Indices,     Col_Indices,    SubMAT_Info[0].Local_Mat_Data,
%                      ROW_NB,          COL_NB,
%                      SubMAT_Info[0].Shift_Row_Index,  SubMAT_Info[0].Shift_Col_Index);

% output text-lines
SubMAT_Order_List = SubMAT_Order_List(:,1);
for ind = 1:MAT.Num_SubMAT
    index = SubMAT_Order_List(ind);
    cpp_ind = num2str(MAT.SubMAT(index).cpp_index);
    Local_Mat_Data_str = ['SubMAT_Info[', cpp_ind, '].Local_Mat_Data'];
    Tab_Tensor_str = ['Tabulate_Tensor_', cpp_ind, '(', Local_Mat_Data_str, ', ',...
                      'Mesh', ');'];
    Arg_str = ['                 SubMAT_Info[', cpp_ind, '].Shift_Row_Index,  SubMAT_Info[', cpp_ind, '].Shift_Col_Index);'];
    
    TF_COPY_SubMAT = ~isempty(MAT.SubMAT(index).COPY_SubMAT);
    if TF_COPY_SubMAT
        TF_STRAIGHT_COPY = ~MAT.SubMAT(index).COPY_SubMAT.Copy_Transpose; % normal straight copy
    else
        TF_STRAIGHT_COPY = false;
    end
    if and(TF_COPY_SubMAT,TF_STRAIGHT_COPY) % don't need to explicitly copy in this case!
        % change which submatrix data to use
        Local_Mat_Data_str = ['SubMAT_Info[', num2str(MAT.SubMAT(index).COPY_SubMAT.Use_SubMAT-1), '].Local_Mat_Data'];
        fprintf(fid, [TAB, '// just copy the data over...', ENDL]);
    else
        fprintf(fid, [TAB, Tab_Tensor_str, ENDL]);
    end
    
    fprintf(fid, [TAB, 'MAT->add_entries(Row_Indices,     Col_Indices,    ', Local_Mat_Data_str, ',', ENDL]);
    fprintf(fid, [TAB, '                 ROW_NB,          COL_NB,', ENDL]);
    fprintf(fid, [TAB, Arg_str, ENDL]);
    fprintf(fid, ['', ENDL]);
end
%%%%%%%

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

end