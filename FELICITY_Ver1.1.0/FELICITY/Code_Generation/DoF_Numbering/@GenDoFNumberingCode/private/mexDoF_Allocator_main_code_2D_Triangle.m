function main = mexDoF_Allocator_main_code_2D_Triangle(obj,mex_strings,Elem_Alloc)
%mexDoF_Allocator_main_code_2D_Triangle
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

TAB  = '    ';

%%%%%%%
main = FELtext('main code');
% store text-lines
main = main.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);

% EXAMPLE:
%%%%%%%
%     // declare triangle edge searcher object
%     TRIANGLE_EDGE_SEARCH    Tri_Edge_Search;
%     Tri_Edge_Search.Setup_Mesh(prhs[PRHS_Tri_List]);
main = main.Append_CR([TAB, '// declare triangle edge searcher object']);
main = main.Append_CR([TAB, 'TRIANGLE_EDGE_SEARCH    Tri_Edge_Search;']);
main = main.Append_CR([TAB, 'Tri_Edge_Search.Setup_Mesh(prhs[PRHS_Tri_List]);']);
main = main.Append_CR('');

% EXAMPLE:
%%%%%%%
%     // declare DoF allocator
%     Elem3_Test_DoF_Allocator      Elem3_Test_DoF_Obj;
%     // do some initial allocation
%     plhs[PLHS_Elem3_Test_DoF_Map] = Elem3_Test_DoF_Obj.Init_DoF_Map(Tri_Edge_Search.Num_Tri);
%     // create the DoFmap
%     Elem3_Test_DoF_Obj.Fill_DoF_Map(&Tri_Edge_Search);
for ind=1:length(Elem_Alloc)
    main = main.Append_CR([TAB, '// declare DoF allocator']);
    DoF_Obj_str = [obj.Elem(ind).Name, '_DoF_Obj'];
    DoF_Allocator_str = [Elem_Alloc(ind).CPP_Data_Type_str, '      ', DoF_Obj_str, ';'];
    main = main.Append_CR([TAB, DoF_Allocator_str]);
    main = main.Append_CR([TAB, '// do some initial allocation']);
    Init_DoF_Map_str = ['plhs[', mex_strings.PLHS_Elem_DoF(ind).str, '] = ', DoF_Obj_str,...
                        '.Init_DoF_Map(Tri_Edge_Search.Num_Tri);'];
    main = main.Append_CR([TAB, Init_DoF_Map_str]);
    main = main.Append_CR([TAB, '// create the DoFmap']);
    main = main.Append_CR([TAB, DoF_Obj_str, '.Fill_DoF_Map(&Tri_Edge_Search);']);
    main = main.Append_CR('');
end
main = main.Append_CR([TAB, obj.String.END_Auto_Gen]);

main = main.Append_CR('');
main = main.Append_CR([TAB, '// output the Euler characteristic of the domain']);
main = main.Append_CR([TAB, 'const int CHI = Tri_Edge_Search.Num_Unique_Vertices - Tri_Edge_Search.Num_Unique_Edges + Tri_Edge_Search.Num_Tri;']);
% only print Euler characteristic if we have all the info
TAB2 = [TAB, TAB];
main = main.Append_CR([TAB, 'const bool INVALID = (Tri_Edge_Search.Num_Unique_Vertices==0) || ',...
                                                 '(Tri_Edge_Search.Num_Unique_Edges==0) || ',...
                                                 '(Tri_Edge_Search.Num_Tri==0);']);
main = main.Append_CR([TAB, 'if (!INVALID)']);
main = main.Append_CR([TAB2, '{']);
main = main.Append_CR([TAB2, 'mexPrintf("Euler Characteristic of the Domain: CHI = V - E + F\\n");']);
main = main.Append_CR([TAB2, 'mexPrintf("                                     %%d = %%d - %%d + %%d \\n",',...
                             'CHI,Tri_Edge_Search.Num_Unique_Vertices,Tri_Edge_Search.Num_Unique_Edges,Tri_Edge_Search.Num_Tri);']);
main = main.Append_CR([TAB2, '}']);

end