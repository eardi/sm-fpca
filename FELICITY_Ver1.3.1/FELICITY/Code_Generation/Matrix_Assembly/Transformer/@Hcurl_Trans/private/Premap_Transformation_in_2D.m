function Premap_Transformation = Premap_Transformation_in_2D(obj,Elem)
%Premap_Transformation_in_2D
%
%   This sets up the code for the "pre-map" transformation for H(curl)
%   elements in 2-D.

% Copyright (c) 10-28-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;
if (TD~=GD)
    error('Not implemented or invalid!');
end
if (TD~=2)
    error('This routine is meant for 2-D only!');
end

% name of sub-routine
Premap_Transformation.CPP_Name = 'Get_Basis_Sign_Change';

% arguments: mesh element vertex indices,
%            sign changes for basis functions.

% define output variable name
Basis_Sign_CPP_Name = 'Basis_Sign';
Premap_Transformation.Basis_Sign_CPP = Basis_Sign_CPP_Name;

% setup argument list
Premap_Transformation.Arg_List_Init = ['const int Mesh_Vertex[SUB_TD+1], double ', Basis_Sign_CPP_Name, '[NB]'];
Premap_Transformation.Arg_List_Defn = Premap_Transformation.Arg_List_Init;

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];

% write a snippet for initializing the output
Init_Snippet = [];
Init_Signs = '1.0';
for jj = 2:Elem.Num_Basis
    Init_Signs = [Init_Signs, ', 1.0'];
end
Init_Snippet = [Init_Snippet, 'double ', Basis_Sign_CPP_Name, '[NB] = {', Init_Signs, '}; // init to all positive (no sign change)'];
Premap_Transformation.Init_Snippet = Init_Snippet;

% write the sub-routine:
% determine which sign adjustments must be made using the given mesh vertex index info.

% 2-D elements:
% determine tangent (edge) vector orientations
main = [];
main = [main, TAB, 'double Mesh_Orient[3] = {1.0, 1.0, 1.0}; // into to all positive', ENDL];
main = [main, ENDL];

main = [main, TAB, '/* edge orientation is chosen in the following way:', ENDL];
main = [main, TAB, '   Each edge points from the vertex of lower (global) index to the vertex of higher (global) index;', ENDL];
main = [main, TAB, '   On a triangle, a positive orientation means:', ENDL];
main = [main, TAB, '   edge #0: Mesh_Vertex[1] < Mesh_Vertex[2]', ENDL];
main = [main, TAB, '   edge #1: Mesh_Vertex[0] < Mesh_Vertex[2]', ENDL];
main = [main, TAB, '   edge #2: Mesh_Vertex[0] < Mesh_Vertex[1] */', ENDL];
main = [main, ENDL];

main = [main, TAB, '// flip orientation if global vertex indices do not satisfy the above', ENDL];
main = [main, TAB, 'if (Mesh_Vertex[1] > Mesh_Vertex[2]) Mesh_Orient[0] = -1.0;', ENDL];
main = [main, TAB, 'if (Mesh_Vertex[0] > Mesh_Vertex[2]) Mesh_Orient[1] = -1.0;', ENDL];
main = [main, TAB, 'if (Mesh_Vertex[0] > Mesh_Vertex[1]) Mesh_Orient[2] = -1.0;', ENDL];
main = [main, ENDL];
main = [main, TAB, '// get edge orientation "signature" (takes values from 0 to 7)', ENDL];
main = [main, TAB, 'const int Edge_Orientation_Signature = (int) ( (Mesh_Orient[0] < 0.0) * 1 +', ENDL];
main = [main, TAB, '                                               (Mesh_Orient[1] < 0.0) * 2 +', ENDL];
main = [main, TAB, '                                               (Mesh_Orient[2] < 0.0) * 4 );', ENDL];
main = [main, ENDL];

main = [main, TAB, '// BEGIN: determine which basis functions must change their signs', ENDL];
main = [main, TAB, '/* 2-D triangle element has 3 edges */', ENDL];
%main = [main, TAB, 'mexPrintf("Signature = %%d, Mesh_Orient = [%%1.2f, %%1.2f, %%1.2f]\\n",',...
%                              'Edge_Orientation_Signature, Mesh_Orient[0], Mesh_Orient[1], Mesh_Orient[2]);', ENDL];
main = [main, TAB, 'switch (Edge_Orientation_Signature)', ENDL];
main = [main, TAB, '{', ENDL];

% define pre-map function for adjusting signs of basis functions
Premap = @(MO) Premap_Basis_in_2D(MO,Elem.Nodal_Top.E,Elem.Num_Basis); % edges
% define all possible orientations
Mesh_Orient = [ 1,  1,  1;
               -1,  1,  1;
                1, -1,  1;
               -1, -1,  1;
                1,  1, -1;
               -1,  1, -1;
                1, -1, -1;
               -1, -1, -1];
%

Num_Cases = size(Mesh_Orient,1);
Basis_Sign_Change_Data = Premap(Mesh_Orient);
All_DoF_Indices = (0:1:Elem.Num_Basis-1); % adjust for C-style indexing
for ii = 2:Num_Cases % skip the first row
    % get the local DoFs that must change sign
    Basis_Signs = Basis_Sign_Change_Data(ii,:);
    Neg_Mask = (Basis_Signs < 0);
    Basis_Indices = All_DoF_Indices(Neg_Mask);
    
    MO = Mesh_Orient(ii,:); % get current case
    % write edge orientation and signature string
    
    % compute signature
    Signature = (MO(1) < 0.0) * 1 + (MO(2) < 0.0) * 2 + (MO(3) < 0.0) * 4;
    Orientation_str = [num2str(MO(1)), ', ', num2str(MO(2)), ', ', num2str(MO(3))];
    
    Signature_str   = num2str(Signature);
    main = [main, TAB, 'case ', Signature_str, ': // (', Orientation_str, ') edge orientation', ENDL];
    for kk = 1:length(Basis_Indices);
        B_Index_str = num2str(Basis_Indices(kk));
        main = [main, TAB2, Basis_Sign_CPP_Name, '[', B_Index_str, '] = -1.0;', ENDL];
    end
    main = [main, TAB2, 'break;', ENDL];
    %     case 1: // (-1, +1, +1) edge orientation
    %         Basis_Sign[0] = -1.0;
    %         break;
    %     case 2: // (+1, -1, +1) edge orientation
    %     etc...
end
% write default case
if (TD==2)
    Orientation_str = [num2str(Mesh_Orient(1,1)), ', ', num2str(Mesh_Orient(1,2)), ', ', num2str(Mesh_Orient(1,3))];
elseif (TD==3)
    Orientation_str = [num2str(Mesh_Orient(1,1)), ', ', num2str(Mesh_Orient(1,2)), ', ', num2str(Mesh_Orient(1,3)), ', ', num2str(Mesh_Orient(1,4))];
else
    error('Invalid!');
end
main = [main, TAB, 'default: ; // Edge_Orientation_Signature==0 (', Orientation_str, ') edge orientation', ENDL];
main = [main, TAB2, '// do nothing; everything is positive already', ENDL];
main = [main, TAB, '}', ENDL];
main = [main, TAB, '// END: determine which basis functions must change their signs', ENDL];
Premap_Transformation.Main_Subroutine = main;

end