function Local_Trans = Local_Basis_Function_Transformation_Edges_In_Triangle(obj)
%Local_Basis_Function_Transformation_Edges_In_Triangle
%
%   This sets the struct to have all the necessary info for computing local
%   transformations for the case of a codim=1 domain, i.e. local edge info from
%   triangle data.

% Copyright (c) 06-27-2012,  Shawn W. Walker

Local_Trans.Main_Subroutine = []; % init
Local_Trans.Map_Basis = []; % init

% generate compute map code info for each mesh entity
Local_Trans.Map_Basis    = obj.Set_Basis_Transformation_Struct( 1); % edge1, pos
Local_Trans.Map_Basis(2) = obj.Set_Basis_Transformation_Struct(-1); % edge1, neg
Local_Trans.Map_Basis(3) = obj.Set_Basis_Transformation_Struct( 2); % edge2, pos
Local_Trans.Map_Basis(4) = obj.Set_Basis_Transformation_Struct(-2); % edge2, neg
Local_Trans.Map_Basis(5) = obj.Set_Basis_Transformation_Struct( 3); % edge3, pos
Local_Trans.Map_Basis(6) = obj.Set_Basis_Transformation_Struct(-3); % edge3, neg
Local_Trans.Num_Map_Basis = length(Local_Trans.Map_Basis);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];

% error check
Global_Top_Dim     = obj.Domain.Global.Top_Dim;
Subdomain_Top_Dim  = obj.Domain.Subdomain.Top_Dim;
DoI_Top_Dim        = obj.Domain.Integration_Domain.Top_Dim;
Embed = obj.Domain.Get_Sub_DoI_Embedding_Data;
if and(and(Global_Top_Dim==3,Subdomain_Top_Dim==2),DoI_Top_Dim==1)
    if ~and(Embed.Subdomain_Entity_Index,Embed.DoI_Entity_Index)
        disp('The Domain embedding info is not correct for this type of basis function transformation.');
        error('This should not happen...  Report this bug!');
    end
else
    if ~and(~Embed.Subdomain_Entity_Index,Embed.DoI_Entity_Index)
        disp('The Domain embedding info is not correct for this type of basis function transformation.');
        error('This should not happen...  Report this bug!');
    end
end

entity_index_str = 'Entity_Index';
main = [];
main = [main, TAB, '// read in the embedding info', ENDL];
main = [main, TAB, 'const int Entity_Index = Mesh->Domain->DoI_Entity_Index;', ENDL];
main = [main, ENDL];
main = [main, TAB, '// if orientation is positive', ENDL];
main = [main, TAB, 'if (', entity_index_str, ' > 0)', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', entity_index_str, '==1) ',      Local_Trans.Map_Basis(1).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==2) ', Local_Trans.Map_Basis(3).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==3) ', Local_Trans.Map_Basis(5).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}', ENDL];
main = [main, TAB, 'else // else it is negative', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', entity_index_str, '==-1) ',      Local_Trans.Map_Basis(2).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-2) ', Local_Trans.Map_Basis(4).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-3) ', Local_Trans.Map_Basis(6).CPP_Name, '();', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}'];
Local_Trans.Main_Subroutine = main;

end