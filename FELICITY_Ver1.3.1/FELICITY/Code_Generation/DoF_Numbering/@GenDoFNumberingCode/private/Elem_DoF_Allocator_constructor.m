function cons = Elem_DoF_Allocator_constructor(obj,Elem)
%Elem_DoF_Allocator_constructor
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Domain                 = Get_Domain_Info(Elem);
Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%     // setup
%     Name              = (char *) ELEM_Name;
%     Dim               = Dimension;
%     Domain            = (char *) Domain_str;
% 
%     /*------------ BEGIN: Auto Generate ------------*/
%     // nodal DoF arrangement
%     Node.V[1][1][1] =   1; // Set1, V1
%     Node.V[1][2][1] =   2; // Set1, V2
%     Node.V[1][3][1] =   3; // Set1, V3
% 
%     Node.V[2][1][1] =  16; // Set2, V1
%     Node.V[2][2][1] =  17; // Set2, V2
%     Node.V[2][3][1] =  18; // Set2, V3
% 
%     Node.E[1][1][1] =   4; // Set1, E1
%     Node.E[1][1][2] =   7; // Set1, E1
%     Node.E[1][2][1] =   5; // Set1, E2
%     Node.E[1][2][2] =   8; // Set1, E2
%     Node.E[1][3][1] =   6; // Set1, E3
%     Node.E[1][3][2] =   9; // Set1, E3
% 
%     Node.E[2][1][1] =  10; // Set2, E1
%     Node.E[2][1][2] =  13; // Set2, E1
%     Node.E[2][2][1] =  11; // Set2, E2
%     Node.E[2][2][2] =  14; // Set2, E2
%     Node.E[2][3][1] =  12; // Set2, E3
%     Node.E[2][3][2] =  15; // Set2, E3
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
cons = FELtext('constructor');
%%%
cons = cons.Append_CR(obj.String.Separator);
cons = cons.Append_CR('/* constructor */');
cons = cons.Append_CR('EDA::EDA ()');
cons = cons.Append_CR('{');
cons = cons.Append_CR('    // setup');
cons = cons.Append_CR('    Name              = (char *) ELEM_Name;');
cons = cons.Append_CR('    Dim               = Dimension;');
cons = cons.Append_CR('    Domain            = (char *) Domain_str;');
if (Elem.Dim >= 2)
    % need to deal with permutating DoFs on adjoining edges
    cons = cons.Append_CR('    Edge_DoF_Perm.Setup_Maps(); // setup edge DoF permutation maps');
end
if (Elem.Dim >= 3)
    % need to deal with permutating DoFs on adjoining faces
    cons = cons.Append_CR('    Face_DoF_Perm.Setup_Maps(); // setup face DoF permutation maps');
end
cons = cons.Append_CR('');
cons = cons.Append_CR(obj.String.BEGIN_Auto_Gen);
cons = cons.Append_CR('    // nodal DoF arrangement');

% store vertex DoF info
Num_Set = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).V)
        Num_Set = Num_Set + 1;
        for vi=1:Domain.Num_Vtx
            for di=1:size(Elem_Nodal_Top(nnt).V{ind},2)
                STR = ['    Node.V[', num2str(Num_Set), '][', num2str(vi),...
                                '][', num2str(di), '] = ', num2str(Elem_Nodal_Top(nnt).V{ind}(vi,di)),...
                                '; // Set', num2str(Num_Set), ', V', num2str(vi)];
                cons = cons.Append_CR(STR);
            end
        end
        cons = cons.Append_CR('');
    end
end

% store edge DoF info
Num_Set = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        Num_Set = Num_Set + 1;
        for ei=1:Domain.Num_Edge
            for di=1:size(Elem_Nodal_Top(nnt).E{ind},2)
                STR = ['    Node.E[', num2str(Num_Set), '][', num2str(ei),...
                                '][', num2str(di), '] = ', num2str(Elem_Nodal_Top(nnt).E{ind}(ei,di)),...
                                '; // Set', num2str(Num_Set), ', E', num2str(ei)];
                cons = cons.Append_CR(STR);
            end
        end
        cons = cons.Append_CR('');
    end
end

% store face DoF info
Num_Set = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        for fi=1:Domain.Num_Face
            for di=1:size(Elem_Nodal_Top(nnt).F{ind},2)
                STR = ['    Node.F[', num2str(Num_Set), '][', num2str(fi),...
                                '][', num2str(di), '] = ', num2str(Elem_Nodal_Top(nnt).F{ind}(fi,di)),...
                                '; // Set', num2str(Num_Set), ', F', num2str(fi)];
                cons = cons.Append_CR(STR);
            end
        end
        cons = cons.Append_CR('');
    end
end

% store tet DoF info
Num_Set = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).T)
        Num_Set = Num_Set + 1;
        for ti=1:Domain.Num_Tet
            for di=1:size(Elem_Nodal_Top(nnt).T{ind},2)
                STR = ['    Node.T[', num2str(Num_Set), '][', num2str(ti),...
                                '][', num2str(di), '] = ', num2str(Elem_Nodal_Top(nnt).T{ind}(ti,di)),...
                                '; // Set', num2str(Num_Set), ', T', num2str(ti)];
                cons = cons.Append_CR(STR);
            end
        end
        cons = cons.Append_CR('');
    end
end

cons = cons.Append_CR(obj.String.END_Auto_Gen);
cons = cons.Append_CR('}');
cons = cons.Append_CR(obj.String.Separator);
cons = cons.Append_CR('');
cons = cons.Append_CR('');

end