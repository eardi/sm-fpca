function Premap_Transformation = Premap_Transformation_in_3D(obj)
%Premap_Transformation_in_3D
%
%   This sets up the code for the permutation transformation for H(curl)
%   elements in 3-D.

% Copyright (c) 10-28-2016,  Shawn W. Walker

% setup output type
TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;
if (TD~=GD)
    error('Not implemented or invalid!');
end
if (TD~=3)
    error('This routine is meant for 3-D only!');
end

% name of sub-routine
Premap_Transformation.CPP_Name = 'Determine_Element_Order';

% create the input and output arguments

% arguments: mesh element vertex indices,
%            permutation "signature"

% define output variable name
Std_Elem_Order_CPP_Name = 'Std_Elem_Order';
Premap_Transformation.Std_Elem_Order_CPP_Name = Std_Elem_Order_CPP_Name;

% setup function declaration
Premap_Transformation.Arg_List_Init = ['const int Mesh_Vertex[SUB_TD+1], bool& ', Std_Elem_Order_CPP_Name];
Premap_Transformation.Arg_List_Defn = Premap_Transformation.Arg_List_Init;

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];

% write the sub-routine:
% basically, we determine which "permutation set" of basis functions to use
% when computing the basis functions on the mesh element.

main = [];
% put the element vertex indices into ascending order (with respect to the global index number)
main = [main, TAB, '// determine ascending order of local mesh vertices', ENDL];
main = [main, TAB, 'int Sorted_Indices[SUB_TD+1];', ENDL];
main = [main, ENDL];

main = [main, TAB, 'Sort_Four_Ints(Mesh_Vertex[0], Mesh_Vertex[1], Mesh_Vertex[2], Mesh_Vertex[3], Sorted_Indices);', ENDL];
main = [main, ENDL];

main = [main, TAB, '// determine which vertex order case we have', ENDL];
main = [main, TAB, 'const bool ascending = (Sorted_Indices[0]==0) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[1]==1) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[2]==2) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[3]==3);', ENDL];
main = [main, TAB, 'const bool mirror    = (Sorted_Indices[0]==0) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[1]==2) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[2]==1) & ', ENDL];
main = [main, TAB, '                       (Sorted_Indices[3]==3);', ENDL];
main = [main, ENDL];

main = [main, TAB,  'if (ascending)', ENDL];
main = [main, TAB2, Std_Elem_Order_CPP_Name, ' = true;', ENDL];
main = [main, TAB,  'else if (mirror)', ENDL];
main = [main, TAB2, Std_Elem_Order_CPP_Name, ' = false;', ENDL];
main = [main, TAB,  'else', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, 'mexPrintf("FELICITY ERROR\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("-----------------------------------------------------------------------------\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("Given mesh element [V_1, V_2, V_3, V_4] does not satisfy either ordering:\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("        V_1 < V_2 < V_3 < V_4, (ascending order);\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("        V_1 < V_3 < V_2 < V_4, (mirror reflection ascending order).\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("The actual order is:\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("        V_%%d < V_%%d < V_%%d < V_%%d.\\n",Sorted_Indices[0]+1,Sorted_Indices[1]+1,Sorted_Indices[2]+1,Sorted_Indices[3]+1);', ENDL];
main = [main, TAB2, 'mexPrintf("\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("You must sort your triangulation!\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("    I.e. use the MeshTetrahedron method ''Order_Cell_Vertices_For_Hcurl''.\\n");', ENDL];
main = [main, TAB2, 'mexPrintf("-----------------------------------------------------------------------------\\n");', ENDL];
main = [main, TAB2, 'mexErrMsgTxt("Triangulation is not sorted correctly!\\n");', ENDL];
main = [main, TAB2, '}', ENDL];

Premap_Transformation.Main_Subroutine = main;

end