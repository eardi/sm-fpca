function Local_Map = Local_Geometric_Map_Edges_In_Triangle(obj)
%Local_Geometric_Map_Edges_In_Triangle
%
%   This sets the struct to have all the necessary info for computing local
%   transformations for the case of a codim=1 domain, i.e. local edge info from
%   triangle data.

% Copyright (c) 03-18-2012,  Shawn W. Walker

Local_Map.Main_Subroutine = []; % init
Local_Map.Compute_Map     = []; % init

% generate compute map code info for each mesh entity
Local_Map.Compute_Map = obj.Set_Geometric_Map_Struct( 1); % edge1, pos
Local_Map.Compute_Map(2) = obj.Set_Geometric_Map_Struct(-1); % edge1, neg
Local_Map.Compute_Map(3) = obj.Set_Geometric_Map_Struct( 2); % edge2, pos
Local_Map.Compute_Map(4) = obj.Set_Geometric_Map_Struct(-2); % edge2, neg
Local_Map.Compute_Map(5) = obj.Set_Geometric_Map_Struct( 3); % edge3, pos
Local_Map.Compute_Map(6) = obj.Set_Geometric_Map_Struct(-3); % edge3, neg
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
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}', ENDL];
main = [main, TAB, 'else // else it is negative', ENDL];
main = [main, TAB2, '{', ENDL];
main = [main, TAB2, '// pick the correct one', ENDL];
main = [main, TAB2, 'if (', entity_index_str, '==-1) ',      Local_Map.Compute_Map(2).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-2) ', Local_Map.Compute_Map(4).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else if (', entity_index_str, '==-3) ', Local_Map.Compute_Map(6).CPP_Name, '(', elem_index_str, ');', ENDL];
main = [main, TAB2, 'else mexErrMsgTxt("ERROR: ', entity_index_str, ' outside valid range or is zero!");', ENDL];
main = [main, TAB2, '}'];
Local_Map.Main_Subroutine = main;

end

% function Ref_Edge_Vec = Get_Edge_Vec(Entity_Index)
% 
% if (Entity_Index==1)
%     Ref_Edge_Vec = [-1 1];   % edge1, pos
% elseif (Entity_Index==2)
%     Ref_Edge_Vec = [0, -1];  % edge2, pos
% elseif (Entity_Index==3)
%     Ref_Edge_Vec = [1, 0];   % edge3, pos
% elseif (Entity_Index==-1)
%     Ref_Edge_Vec = -[-1 1];  % edge1, neg
% elseif (Entity_Index==-2)
%     Ref_Edge_Vec = -[0, -1]; % edge2, neg
% elseif (Entity_Index==-3)
%     Ref_Edge_Vec = -[1, 0];  % edge3, neg
% else
%     error('Invalid!');
% end
% 
% end