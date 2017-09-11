function Local_Map = Local_Geometric_Map_Triangles_In_Tetrahedron(obj)
%Local_Geometric_Map_Triangles_In_Tetrahedron
%
%   This sets the struct to have all the necessary info for computing local
%   transformations for the case of a codim=1 domain, i.e. local triangle info
%   from tetrahedron data.

% Copyright (c) 03-19-2012,  Shawn W. Walker

Local_Map.Main_Subroutine = []; % init
Local_Map.Compute_Map = []; % init

% generate compute map code info for each mesh entity
Local_Map.Compute_Map = obj.Set_Geometric_Map_Struct( 1); % face1, pos
Local_Map.Compute_Map( 2) = obj.Set_Geometric_Map_Struct(-1); % face1, neg
Local_Map.Compute_Map( 3) = obj.Set_Geometric_Map_Struct( 2); % face2, pos
Local_Map.Compute_Map( 4) = obj.Set_Geometric_Map_Struct(-2); % face2, neg
Local_Map.Compute_Map( 5) = obj.Set_Geometric_Map_Struct( 3); % face3, pos
Local_Map.Compute_Map( 6) = obj.Set_Geometric_Map_Struct(-3); % face3, neg
Local_Map.Compute_Map( 7) = obj.Set_Geometric_Map_Struct( 4); % face4, pos
Local_Map.Compute_Map( 8) = obj.Set_Geometric_Map_Struct(-4); % face4, neg
Local_Map.Num_Compute_Map = length(Local_Map.Compute_Map);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];

Embed = obj.Domain.Get_Sub_DoI_Embedding_Data;
if Embed.Subdomain_Entity_Index
    entity_index_str = 'Sub_Entity_Index';
elseif Embed.DoI_Entity_Index
    entity_index_str = 'DoI_Entity_Index';
else
    error('Invalid!');
end
elem_index_str = 'Global_Cell_Index';
main = [];
main = [main, TAB, '// if orientation is positive', ENDL];
main = [main, TAB, 'if (', entity_index_str, ' > 0)', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', entity_index_str, '==1) ',      Local_Map.Compute_Map(1).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==2) ', Local_Map.Compute_Map(3).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==3) ', Local_Map.Compute_Map(5).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==4) ', Local_Map.Compute_Map(7).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}', ENDL];
main = [main, TAB, 'else // else it is negative', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', entity_index_str, '==-1) ',      Local_Map.Compute_Map(2).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-2) ', Local_Map.Compute_Map(4).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-3) ', Local_Map.Compute_Map(6).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-4) ', Local_Map.Compute_Map(8).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}'];
Local_Map.Main_Subroutine = main;

end

% function Ref_Face_Basis = Get_Face_Basis(Entity_Index)
% 
% % first row is the vector v2 - v1
% % second row is the vector v3 - v1
% % v1, v2, v3 are the local vertices of the face
% 
% % vertices of the reference tetrahedron
% A1 = [0 0 0];
% A2 = [1 0 0];
% A3 = [0 1 0];
% A4 = [0 0 1];
% 
% if (Entity_Index==1) % face1, pos
%     v1 = A2;
%     v2 = A3;
%     v3 = A4;
% elseif (Entity_Index==2) % face2, pos
%     v1 = A1;
%     v2 = A4;
%     v3 = A3;
% elseif (Entity_Index==3) % face3, pos
%     v1 = A1;
%     v2 = A2;
%     v3 = A4;
% elseif (Entity_Index==4) % face4, pos
%     v1 = A1;
%     v2 = A3;
%     v3 = A2;
% elseif (Entity_Index==-1) % face1, neg
%     v1 = A2; % pivot
%     v2 = A4;
%     v3 = A3;
% elseif (Entity_Index==-2) % face2, neg
%     v1 = A1; % pivot
%     v2 = A3;
%     v3 = A4;
% elseif (Entity_Index==-3) % face3, neg
%     v1 = A1; % pivot
%     v2 = A4;
%     v3 = A2;
% elseif (Entity_Index==-4) % face4, neg
%     v1 = A1; % pivot
%     v2 = A2;
%     v3 = A3;
% else
%     error('Invalid!');
% end
% 
% Ref_Face_Basis = [v2 - v1;
%                   v3 - v1];
% %
% 
% end