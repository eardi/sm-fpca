function Premap_Transformation = Get_Premap_Transformation(obj,Elem)
%Get_Premap_Transformation
%
%   This sets up the code for the "pre-map" transformation for H(div)
%   elements.

% Copyright (c) 10-27-2016,  Shawn W. Walker

% name of sub-routine
Premap_Transformation.CPP_Name = 'Get_Basis_Sign_Change';

% create the input and output arguments

% arguments: mesh orientation,
%            sign changes for basis functions.

% define an output variable name
Basis_Sign_CPP_Name = 'Basis_Sign';
Premap_Transformation.Basis_Sign_CPP = Basis_Sign_CPP_Name;

% setup argument list
Premap_Transformation.Arg_List_Init = ['const double Mesh_Orient[SUB_TD+1], double ', Basis_Sign_CPP_Name, '[NB]'];
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
% determine which sign adjustments must be made using the given mesh orientation info.

% 2-D or 3-D elements:
TD = obj.GeoMap.TopDim;
main = [];
if (TD==2)
    main = [main, TAB, '// get facet (edge) orientation "signature" (takes values from 0 to 7)', ENDL];
    main = [main, TAB, 'const int Facet_Orientation_Signature = (int) ( (Mesh_Orient[0] < 0.0) * 1 +', ENDL];
    main = [main, TAB, '                                                (Mesh_Orient[1] < 0.0) * 2 +', ENDL];
    main = [main, TAB, '                                                (Mesh_Orient[2] < 0.0) * 4 );', ENDL];
elseif (TD==3)
    main = [main, TAB, '// get facet (face) orientation "signature" (takes values from 0 to 15)', ENDL];
    main = [main, TAB, 'const int Facet_Orientation_Signature = (int) ( (Mesh_Orient[0] < 0.0) * 1 +', ENDL];
    main = [main, TAB, '                                                (Mesh_Orient[1] < 0.0) * 2 +', ENDL];
    main = [main, TAB, '                                                (Mesh_Orient[2] < 0.0) * 4 +', ENDL];
    main = [main, TAB, '                                                (Mesh_Orient[3] < 0.0) * 8 );', ENDL];
else
    error('Invalid!');
end
main = [main, ENDL];
main = [main, TAB, '// BEGIN: determine which basis functions must change their signs', ENDL];
if (TD==2)
    main = [main, TAB, '/* 2-D triangle element has 3 facets */', ENDL];
elseif (TD==3)
    main = [main, TAB, '/* 3-D tetrahedron element has 4 facets */', ENDL];
else
    error('Invalid!');
end
%main = [main, TAB, 'mexPrintf("Signature = %%d, Mesh_Orient = [%%1.2f, %%1.2f, %%1.2f]\\n",',...
%                              'Facet_Orientation_Signature, Mesh_Orient[0], Mesh_Orient[1], Mesh_Orient[2]);', ENDL];
main = [main, TAB, 'switch (Facet_Orientation_Signature)', ENDL];
main = [main, TAB, '{', ENDL];

% define pre-map function for adjusting signs of basis functions
if (TD==2)
    Premap = @(MO) Premap_Basis(MO,Elem.Nodal_Top.E,Elem.Num_Basis); % edges
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
elseif (TD==3)
    Premap = @(MO) Premap_Basis(MO,Elem.Nodal_Top.F,Elem.Num_Basis); % faces
    % define all possible orientations
    Mesh_Orient = [ 1,  1,  1,  1;
                   -1,  1,  1,  1;
                    1, -1,  1,  1;
                   -1, -1,  1,  1;
                    1,  1, -1,  1;
                   -1,  1, -1,  1;
                    1, -1, -1,  1;
                   -1, -1, -1,  1;
                    1,  1,  1, -1;
                   -1,  1,  1, -1;
                    1, -1,  1, -1;
                   -1, -1,  1, -1;
                    1,  1, -1, -1;
                   -1,  1, -1, -1;
                    1, -1, -1, -1;
                   -1, -1, -1, -1];
    %
else
    error('Invalid!');
end

Num_Cases = size(Mesh_Orient,1);
Basis_Sign_Change = Premap(Mesh_Orient);
All_DoF_Indices = (0:1:Elem.Num_Basis-1); % adjust for C-style indexing
for ii = 2:Num_Cases
    % get the local DoFs that must change sign
    Basis_Signs = Basis_Sign_Change(ii,:);
    Neg_Mask = (Basis_Signs < 0);
    Basis_Indices = All_DoF_Indices(Neg_Mask);
    
    MO = Mesh_Orient(ii,:); % get current case
    % write facet orientation and signature string
    if (TD==2)
        % compute signature
        Signature = (MO(1) < 0.0) * 1 + (MO(2) < 0.0) * 2 + (MO(3) < 0.0) * 4;
        Orientation_str = [num2str(MO(1)), ', ', num2str(MO(2)), ', ', num2str(MO(3))];
    elseif (TD==3)
        % compute signature
        Signature = (MO(1) < 0.0) * 1 + (MO(2) < 0.0) * 2 + (MO(3) < 0.0) * 4 + (MO(4) < 0.0) * 8;
        Orientation_str = [num2str(MO(1)), ', ', num2str(MO(2)), ', ', num2str(MO(3)), ', ', num2str(MO(4))];
    else
        error('Invalid!');
    end
    
    Signature_str   = num2str(Signature);
    main = [main, TAB, 'case ', Signature_str, ': // (', Orientation_str, ') facet orientation', ENDL];
    for kk = 1:length(Basis_Indices);
        B_Index_str = num2str(Basis_Indices(kk));
        main = [main, TAB2, Basis_Sign_CPP_Name, '[', B_Index_str, '] = -1.0;', ENDL];
    end
    main = [main, TAB2, 'break;', ENDL];
    %     case 1: // (-1, +1, +1) facet orientation
    %         Basis_Sign[0] = -1.0;
    %         break;
    %     case 2: // (+1, -1, +1) facet orientation
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
main = [main, TAB, 'default: ; // Facet_Orientation_Signature==0 (', Orientation_str, ') facet orientation', ENDL];
main = [main, TAB2, '// do nothing; everything is positive already', ENDL];
main = [main, TAB, '}', ENDL];
main = [main, TAB, '// END: determine which basis functions must change their signs', ENDL];
Premap_Transformation.Main_Subroutine = main;

end