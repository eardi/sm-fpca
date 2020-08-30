function Local_Map = Local_Geometric_Map_Edges_In_Triangles_In_Tetrahedron(obj)
%Local_Geometric_Map_Edges_In_Triangles_In_Tetrahedron
%
%   This sets the struct to have all the necessary info for computing local
%   transformations for the case of an edge in a triangle in a tetrahedron.

% Copyright (c) 06-26-2012,  Shawn W. Walker

Local_Map.Main_Subroutine = []; % init
Local_Map.Compute_Map     = []; % init

% generate compute map code info for each mesh entity
Local_Map.Compute_Map = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,1); % face1-pos, local edge1-pos
Local_Map.Compute_Map( 2) = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,2); % face1-pos, local edge2-pos
Local_Map.Compute_Map( 3) = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,3); % face1-pos, local edge3-pos

Local_Map.Compute_Map( 4) = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,-1); % face1-pos, local edge1-neg
Local_Map.Compute_Map( 5) = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,-2); % face1-pos, local edge2-neg
Local_Map.Compute_Map( 6) = obj.Set_Geometric_Map_Struct_tet_tri_edge(1,-3); % face1-pos, local edge3-neg

Local_Map.Compute_Map( 7) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,1); % face2-pos, local edge1-pos
Local_Map.Compute_Map( 8) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,2); % face2-pos, local edge2-pos
Local_Map.Compute_Map( 9) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,3); % face2-pos, local edge3-pos

Local_Map.Compute_Map(10) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,-1); % face2-pos, local edge1-neg
Local_Map.Compute_Map(11) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,-2); % face2-pos, local edge2-neg
Local_Map.Compute_Map(12) = obj.Set_Geometric_Map_Struct_tet_tri_edge(2,-3); % face2-pos, local edge3-neg

Local_Map.Compute_Map(13) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,1); % face3-pos, local edge1-pos
Local_Map.Compute_Map(14) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,2); % face3-pos, local edge2-pos
Local_Map.Compute_Map(15) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,3); % face3-pos, local edge3-pos

Local_Map.Compute_Map(16) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,-1); % face3-pos, local edge1-neg
Local_Map.Compute_Map(17) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,-2); % face3-pos, local edge2-neg
Local_Map.Compute_Map(18) = obj.Set_Geometric_Map_Struct_tet_tri_edge(3,-3); % face3-pos, local edge3-neg

Local_Map.Compute_Map(19) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,1); % face4-pos, local edge1-pos
Local_Map.Compute_Map(20) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,2); % face4-pos, local edge2-pos
Local_Map.Compute_Map(21) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,3); % face4-pos, local edge3-pos

Local_Map.Compute_Map(22) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,-1); % face4-pos, local edge1-neg
Local_Map.Compute_Map(23) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,-2); % face4-pos, local edge2-neg
Local_Map.Compute_Map(24) = obj.Set_Geometric_Map_Struct_tet_tri_edge(4,-3); % face4-pos, local edge3-neg

Local_Map.Compute_Map(25) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,1); % face1-neg, local edge1-pos
Local_Map.Compute_Map(26) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,2); % face1-neg, local edge2-pos
Local_Map.Compute_Map(27) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,3); % face1-neg, local edge3-pos

Local_Map.Compute_Map(28) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,-1); % face1-neg, local edge1-neg
Local_Map.Compute_Map(29) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,-2); % face1-neg, local edge2-neg
Local_Map.Compute_Map(30) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-1,-3); % face1-neg, local edge3-neg

Local_Map.Compute_Map(31) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,1); % face2-neg, local edge1-pos
Local_Map.Compute_Map(32) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,2); % face2-neg, local edge2-pos
Local_Map.Compute_Map(33) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,3); % face2-neg, local edge3-pos

Local_Map.Compute_Map(34) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,-1); % face2-neg, local edge1-neg
Local_Map.Compute_Map(35) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,-2); % face2-neg, local edge2-neg
Local_Map.Compute_Map(36) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-2,-3); % face2-neg, local edge3-neg

Local_Map.Compute_Map(37) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,1); % face3-neg, local edge1-pos
Local_Map.Compute_Map(38) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,2); % face3-neg, local edge2-pos
Local_Map.Compute_Map(39) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,3); % face3-neg, local edge3-pos

Local_Map.Compute_Map(40) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,-1); % face3-neg, local edge1-neg
Local_Map.Compute_Map(41) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,-2); % face3-neg, local edge2-neg
Local_Map.Compute_Map(42) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-3,-3); % face3-neg, local edge3-neg

Local_Map.Compute_Map(43) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,1); % face4-neg, local edge1-pos
Local_Map.Compute_Map(44) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,2); % face4-neg, local edge2-pos
Local_Map.Compute_Map(45) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,3); % face4-neg, local edge3-pos

Local_Map.Compute_Map(46) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,-1); % face4-neg, local edge1-neg
Local_Map.Compute_Map(47) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,-2); % face4-neg, local edge2-neg
Local_Map.Compute_Map(48) = obj.Set_Geometric_Map_Struct_tet_tri_edge(-4,-3); % face4-neg, local edge3-neg

Local_Map.Num_Compute_Map = length(Local_Map.Compute_Map);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];

%Embed = obj.Domain.Get_Sub_DoI_Embedding_Data;
Sub_entity_index_str = 'Sub_Entity_Index';
DoI_entity_index_str = 'DoI_Entity_Index';
elem_index_str       = 'Global_Cell_Index';

main = [];
main = [main, TAB, '// if orientation is positive', ENDL];
main = [main, TAB, 'if (', Sub_entity_index_str, ' > 0)', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', Sub_entity_index_str, '==1)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map( 1).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map( 2).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map( 3).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map( 4).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map( 5).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map( 6).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==2)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map( 7).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map( 8).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map( 9).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(10).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(11).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(12).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==3)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(13).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(14).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(15).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(16).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(17).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(18).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==4)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(19).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(20).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(21).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(22).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(23).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(24).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', Sub_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}', ENDL];
main = [main, TAB, 'else // else it is negative', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];

main = [main, TAB2, 'if (', Sub_entity_index_str, '==-1)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(25).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(26).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(27).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(28).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(29).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(30).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==-2)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(31).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(32).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(33).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(34).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(35).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(36).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==-3)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(37).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(38).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(39).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(40).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(41).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(42).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else if (', Sub_entity_index_str, '==-4)', ENDL];
main = [main, TAB3, '{', ENDL];
main = [main, TAB3, 'if (', DoI_entity_index_str, '==1) ',       Local_Map.Compute_Map(43).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==2) ',  Local_Map.Compute_Map(44).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==3) ',  Local_Map.Compute_Map(45).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-1) ', Local_Map.Compute_Map(46).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-2) ', Local_Map.Compute_Map(47).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else if (', DoI_entity_index_str, '==-3) ', Local_Map.Compute_Map(48).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB3, 'else mexErrMsgTxt("ERROR: ', DoI_entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB3, '}', ENDL];

main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', Sub_entity_index_str, ' outside valid range or is zero!");', ENDL];
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