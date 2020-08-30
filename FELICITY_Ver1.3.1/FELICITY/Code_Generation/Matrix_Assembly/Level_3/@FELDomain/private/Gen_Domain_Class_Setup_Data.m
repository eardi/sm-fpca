function Embed = Gen_Domain_Class_Setup_Data(obj,fid)
%Gen_Domain_Class_Setup_Data
%
%   This declares the Domain_Class::Setup_Data routine.

% Copyright (c) 05-15-2020,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];
TAB4 = [TAB, TAB, TAB, TAB];
TAB5 = [TAB, TAB, TAB, TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* setup access to incoming MATLAB data that represents subdomain embedding */', ENDL]);
fprintf(fid, ['void MDC::Setup_Data(const mxArray* Subdomain_Array, ', 'const mxArray* Global_Mesh_DoFmap, ',...
                                   'const mxArray* Sublist_Elem_Indices', ')  // inputs', ENDL]);
fprintf(fid, ['{', ENDL]);

% fprintf(fid, [TAB, 'mexPrintf("Global_Name: %%s\\n"', ',Global_Name);', ENDL]);
% fprintf(fid, [TAB, 'mexPrintf("Sub_Name: %%s\\n"', ',Sub_Name);', ENDL]);
% fprintf(fid, [TAB, 'mexPrintf("DoI_Name: %%s\\n"', ',DoI_Name);', ENDL]);

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
fprintf(fid, ['', ENDL]);

% parse the sublist of elements
fprintf(fid, [TAB, 'size_t Num_Lists = 0; // init', ENDL]);
fprintf(fid, [TAB, 'if (Sublist_Elem_Indices!=NULL)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// then we have a valid input', ENDL]);
fprintf(fid, [TAB2, 'Num_Lists = mxGetNumberOfElements(Sublist_Elem_Indices);', ENDL]);
fprintf(fid, [TAB2, 'if (Num_Lists > 0)', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, '// check the struct', ENDL]);
fprintf(fid, [TAB3, 'const int mxName_state = mxGetFieldNumber(Sublist_Elem_Indices,"DoI_Name");', ENDL]);
fprintf(fid, [TAB3, 'const int mxElem_Ind_state = mxGetFieldNumber(Sublist_Elem_Indices,"Elem_Indices");', ENDL]);
fprintf(fid, [TAB3, 'if ( (mxName_state==-1) || (mxElem_Ind_state==-1) )', ENDL]);
fprintf(fid, [TAB4, '{', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: The sublist element index data from MATLAB does not have the correct format.\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: The struct should look like this:\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR:            .DoI_Name (Domain of Integration)\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR:            .Elem_Indices\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: (Note that .Elem_Indices indexes into the embedding data for the DoI.)\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexErrMsgTxt("ERROR: make sure you provide the correct data structure!");', ENDL]);
fprintf(fid, [TAB4, '}', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB, 'int LIST_INDEX = -1; // init', ENDL]);
fprintf(fid, [TAB, 'if (Num_Lists > 0)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// find the right list', ENDL]);
fprintf(fid, [TAB2, 'for (unsigned int index = 0; index < Num_Lists; index++)', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, '// get the name of the sub-domain', ENDL]);
fprintf(fid, [TAB3, 'const mxArray* mxDoI_Name_Input = mxGetField(Sublist_Elem_Indices, (mwIndex)index, "DoI_Name");', ENDL]);
fprintf(fid, [TAB3, 'if (!mxIsEmpty(mxDoI_Name_Input))', ENDL]);
fprintf(fid, [TAB4, '{', ENDL]);
fprintf(fid, [TAB4, 'mwSize DoI_len = mxGetNumberOfElements(mxDoI_Name_Input) + 1;', ENDL]);
fprintf(fid, [TAB4, 'char* DoI_in   = (char*) mxCalloc(DoI_len, sizeof(char));', ENDL]);
fprintf(fid, [TAB4, '/* Copy the string data over... */', ENDL]);
fprintf(fid, [TAB4, 'if (mxGetString(mxDoI_Name_Input, DoI_in, DoI_len) != 0)', ENDL]);
fprintf(fid, [TAB5, '{', ENDL]);
fprintf(fid, [TAB5, 'mexPrintf("The sublist of elements has a bad .DoI_Name field, i.e. it is not a string!\\n");', ENDL]);
fprintf(fid, [TAB5, 'mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Sublist string data.");', ENDL]);
fprintf(fid, [TAB5, '}', ENDL]);

fprintf(fid, [TAB4, 'const bool DoI_equal = (strcmp(DoI_Name,DoI_in)==0);', ENDL]);
fprintf(fid, [TAB4, 'mxFree(DoI_in);', ENDL]);
fprintf(fid, [TAB4, 'if (DoI_equal)', ENDL]);
fprintf(fid, [TAB5, '{', ENDL]);
fprintf(fid, [TAB5, 'LIST_INDEX = index;', ENDL]);
fprintf(fid, [TAB5, 'break;', ENDL]);
fprintf(fid, [TAB5, '}', ENDL]);
fprintf(fid, [TAB4, '}', ENDL]);
fprintf(fid, [TAB3, 'else // the name is empty!', ENDL]);
fprintf(fid, [TAB4, '{', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("The sublist of elements has a bad .DoI_Name field, i.e. it is empty!\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Sublist string data.");', ENDL]);
fprintf(fid, [TAB4, '}', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);
fprintf(fid, ['', ENDL]);

%fprintf(fid, [TAB, 'mexPrintf("Setup_Data:  4!!\\n"', ');', ENDL]);

fprintf(fid, [TAB2, '// if it was not found, then assume we assemble all elements', ENDL]);
fprintf(fid, [TAB2, 'if (LIST_INDEX < 0)', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, '// output a message saying this...', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("-------------------------------------\\n");', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("Matrix assembler could not find a sublist of elements for %%s\\n",DoI_Name);', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("       Therefore, matrix assembler will assemble *all* elements.\\n");', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("-------------------------------------\\n");', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, ['', ENDL]);

% put in code to allow for assembling over a subset of elements
fprintf(fid, [TAB, '// loop over a subset of the DoI', ENDL]);
fprintf(fid, [TAB, 'if (LIST_INDEX >= 0)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// get the sub-list', ENDL]);
fprintf(fid, [TAB2, 'const mxArray* mxDoI_Sublist_Input = mxGetField(Sublist_Elem_Indices, (mwIndex)LIST_INDEX, "Elem_Indices");', ENDL]);
fprintf(fid, [TAB2, 'const unsigned int Sublist_Len = (unsigned int) mxGetNumberOfElements(mxDoI_Sublist_Input);', ENDL]);

fprintf(fid, [TAB2, '// verify that the data is 32-bit unsigned int', ENDL]);
fprintf(fid, [TAB2, 'if ((mxGetClassID(mxDoI_Sublist_Input)!=mxUINT32_CLASS) && (!mxIsEmpty(mxDoI_Sublist_Input)))', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("ERROR: Sublist index data for %%s has incorrect type!\\n",DoI_Name);', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("ERROR:      .Elem_Indices should be uint32.\\n");', ENDL]);
fprintf(fid, [TAB3, 'mexErrMsgTxt("ERROR: use the MATLAB uint32() command!");', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB2, 'const unsigned int* Sublist_Ind = (const unsigned int*) mxGetPr(mxDoI_Sublist_Input);', ENDL]);
fprintf(fid, [TAB2, '// check that nothing is out of range', ENDL]);

fprintf(fid, [TAB2, 'if (Sublist_Len > 0)', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, 'const unsigned int Max_DoI_Index = *std::max_element(Sublist_Ind, Sublist_Ind + Sublist_Len);', ENDL]);
fprintf(fid, [TAB3, 'const unsigned int Min_DoI_Index = *std::min_element(Sublist_Ind, Sublist_Ind + Sublist_Len);', ENDL]);

fprintf(fid, [TAB3, 'if ((Min_DoI_Index < 1) || (Max_DoI_Index > Num_Elem))', ENDL]);
fprintf(fid, [TAB4, '{', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: ---> There are problems with the sublist of indices for this:\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR:      Domain of Integration: %%s\\n",DoI_Name);', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: The sublist of element indices is outside [1, %%d].\\n",Num_Elem);', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("ERROR: Note that .Elem_Indices indexes into the embedding data,\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexPrintf("       i.e. .Elem_Indices are *not* global element indices.\\n");', ENDL]);
fprintf(fid, [TAB4, 'mexErrMsgTxt("ERROR: Fix your .Elem_Indices OR use the correct mesh embedding data!");', ENDL]);
fprintf(fid, [TAB4, '}', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB3, '// setup sub-list of elements to loop over in assembly', ENDL]);
fprintf(fid, [TAB3, 'Sub_Assem_List.reserve(Sublist_Len);', ENDL]);
fprintf(fid, [TAB3, 'for (unsigned int ii=0; ii < Sublist_Len; ++ii)', ENDL]);
fprintf(fid, [TAB4, 'Sub_Assem_List.push_back(Sublist_Ind[ii] - 1); // C-style indexing', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);
fprintf(fid, [TAB2, 'else // the list is empty so do not assemble', ENDL]);
fprintf(fid, [TAB3, 'Sub_Assem_List.clear(); // make it empty', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, 'else // loop over entire DoI', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// initialize list of elements to loop over in assembly', ENDL]);
fprintf(fid, [TAB2, 'Sub_Assem_List.reserve(Num_Elem);', ENDL]);
fprintf(fid, [TAB2, 'for (unsigned int ii=0; ii < Num_Elem; ++ii)', ENDL]);
fprintf(fid, [TAB3, 'Sub_Assem_List.push_back(ii); // C-style indexing', ENDL]);
fprintf(fid, [TAB2, 'if (Num_Elem==0) Sub_Assem_List.clear(); // make it empty', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end