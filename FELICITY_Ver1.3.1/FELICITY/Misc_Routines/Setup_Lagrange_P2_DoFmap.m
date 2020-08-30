function [P2_Tri_Elem, Bdy_Tri_List, P2_Bdy_Elem] = Setup_Lagrange_P2_DoFmap(Triangles,Bdy_Segments)
%Setup_Lagrange_P2_DoFmap
%
%   This routine generates triangle and boundary element data for the Taylor-Hood
%   finite element.  The triangle elements have six nodes ordered like this:
%
%               3
%               |\
%               | \
%               |  \
%               5   4
%               |    \
%               |     \
%               |      \
%               1---6---2
%
%
%   where the '1', '2', and '3' nodes are at the vertices of the triangle, and the
%   '4', '5', and '6' nodes are at the midpoints of the line segments.  Triangles may be
%   curved; for example here only one side is curved:
%
%               3--
%               |   \
%               |     \
%               |      4
%               5        \
%               |         |
%               |         |
%               |        /
%               1---6---2
%
%   note: node '4' does not lie (in general) at the midpoint between nodes '2' and '3'.
%   The curved side is defined using a quadratic parameterization that uses the quadratic
%   basis functions of P2 continuous Lagrange elements.  And the boundary elements have
%   three nodes ordered like this:
%
%               ---------->
%               1----3----2
%            'tail'     'head'
%
%   where the '1' and '2' nodes denote the endpoints of the boundary segment, and the
%   '3' node is between '1' and '2'.  And, of course, the boundary segment may be curved.
%   Note: the boundary segments are oriented so that the unit normal vector to the
%   boundary segment points outward.  All nodes are used in approximating the
%   velocity field.  Only nodes 1,2,3 of the triangle element and nodes 1,2 of the
%   boundary element are used in approximating the pressure field.
%
%   In addition, an alternate numbering of all the boundary nodes is given.  This
%   routine also creates a 'mask' for accessing the velocity only at the nodes that
%   correspond to the mesh vertices, as well as a mask for accessing the velocity
%   only at the nodes that correspond to boundary mesh vertices.
%
%   [P2_Tri_Elem, Bdy_Tri_List, P2_Bdy_Elem] =
%                 Setup_Lagrange_P2_DoFmap(Triangles,Bdy_Segments);
%
%   OUTPUTS
%   -------
%   P2_Tri_Elem:
%       2-D arrays containing the Taylor-Hood triangle element data.  The first three
%       columns specify nodes 1,2,3 which correspond to the vertices of the triangle
%       mesh.  In this function, three extra columns are added for the velocity nodes
%       4,5,6 (see diagram above).  Here is an example of the data structure:
%
%                                Node-1 / Node-2 / Node-3 / Node-4 / Node-5 / Node-6
%                               (Col #1) (Col #2) (Col #3) (Col #4) (Col #5) (Col #6)
%       Tri Elem #1 (Row #1) -->   81       73       91      112      136      179
%       Tri Elem #2 (Row #2) -->   30       29       24      104      103      167
%       Tri Elem #3 (Row #3) -->    2        8        4      135      122      146
%       Tri Elem #4 (Row #4) -->    8        2        1      127      139      188
%       ...
%
%       'TH_Bdy_Tri_Elem' contains the data for all triangles that have ONE side on
%       the boundary (i.e. all 'boundary' triangles); 'TH_Int_Tri_Elem' contains the
%       data for the rest of the triangles (i.e. all 'interior' triangles).
%
%   Bdy_Tri_List:
%       Boolean mask indicating which P2_Tri_Elem have an edge on the boundary.
%
%   P2_Bdy_Elem:
%       2-D array containing the Taylor-Hood boundary element data.  The first two
%       columns specify nodes 1,2 which correspond to the vertices of the boundary
%       mesh.  The first column contains the node number of the 'tail' vertex; the
%       second column contains the 'head' vertex.  The element points from tail to
%       head and is done in a right-handed fashion, meaning the whole boundary is
%       oriented so that the unit normal vector points outward.  In this function,
%       one extra column is added for the velocity node 3, which is at the midpoint
%       of the boundary segment (see diagram above).  Here is an example of the data
%       structure:
%                                         Node-1 / Node-2 / Node-3
%                                        (Col #1) (Col #2) (Col #3)
%       Boundary Element #1 (Row #1) -->     9       10       92
%       Boundary Element #2 (Row #2) -->     1        8       93
%       Boundary Element #3 (Row #3) -->     5        4       94
%       Boundary Element #4 (Row #4) -->     8       69       95
%       ...
%
%   INPUTS
%   ------
%   Triangles:
%       Same as 'P2_Tri_Elem', except without the 4th, 5th, and 6th columns.
%
%   Bdy_Segments:
%       Same as 'P2_Bdy_Elem', except without extra 3rd column.

% Copyright (c) 06-05-2007,  Shawn W. Walker

% get size info
Num_Tri = size(Triangles,1);
Num_Bdy_Seg = size(Bdy_Segments,1);

% get the number of mesh vertices (i.e. just look at the largest vertex number in the
% mesh triangle data structure)
Num_Mesh_Vertices = max(Triangles(:));

% BEGIN: fill in the extra nodes for the P2 triangle

% Note: an extra 4th ~ 6th columns are essentially added to the first 3 columns
% of 'Triangles'

% generate the edge lists that correspond to the new nodes
Node4_Edge = sort(Triangles(:,[2 3]),2);
Node5_Edge = sort(Triangles(:,[3 1]),2);
Node6_Edge = sort(Triangles(:,[1 2]),2);

% all triangle edge list
ALL_TRI_EDGE = [Node4_Edge;Node5_Edge;Node6_Edge];
ALL_TRI_EDGE = unique(ALL_TRI_EDGE,'rows');

% generate indices for the additional edge nodes
Num_NEW_Nodes = size(ALL_TRI_EDGE,1);
NEW_Node_Indices = (1:1:Num_NEW_Nodes)' + Num_Mesh_Vertices;

% initialize
Tri_Node4_Index_Vec = zeros(Num_Tri,1);
Tri_Node5_Index_Vec = zeros(Num_Tri,1);
Tri_Node6_Index_Vec = zeros(Num_Tri,1);

% get the global node number for the local node #4
[TF4, Node4_LOC] = ismember(Node4_Edge,ALL_TRI_EDGE,'rows');
Tri_Node4_Index_Vec(TF4,1) = NEW_Node_Indices(Node4_LOC(TF4),1);

% get the global node number for the local node #5
[TF5, Node5_LOC] = ismember(Node5_Edge,ALL_TRI_EDGE,'rows');
Tri_Node5_Index_Vec(TF5,1) = NEW_Node_Indices(Node5_LOC(TF5),1);

% get the global node number for the local node #6
[TF6, Node6_LOC] = ismember(Node6_Edge,ALL_TRI_EDGE,'rows');
Tri_Node6_Index_Vec(TF6,1) = NEW_Node_Indices(Node6_LOC(TF6),1);

% create the P2 triangle element data structure
P2_Tri_Elem = [Triangles, Tri_Node4_Index_Vec, Tri_Node5_Index_Vec, Tri_Node6_Index_Vec];

% END: fill in the extra nodes for the P2 triangle

% now do the boundary segments!
if Num_Bdy_Seg > 0
    Sorted_Bdy_Seg = sort(Bdy_Segments(:,1:2),2);
    [TF_bdy, Node_bdy_LOC] = ismember(Sorted_Bdy_Seg,ALL_TRI_EDGE,'rows');
    Bdy_Node3_Index_Vec = zeros(Num_Bdy_Seg,1);
    Bdy_Node3_Index_Vec(TF_bdy,1) = NEW_Node_Indices(Node_bdy_LOC(TF_bdy),1);
    
    % create the P2 boundary element data structure
    P2_Bdy_Elem = [Bdy_Segments, Bdy_Node3_Index_Vec];
    
    % get a mask that distinguishes triangles with a side(s) on the boundary and
    % ones that do not!
    Num_Sides_on_Bdy = sum(ismember(P2_Tri_Elem(:,4:6),P2_Bdy_Elem(:,3)),2);
    Bdy_Tri_List = (Num_Sides_on_Bdy > 0);
    Bdy_Tri_List = logical(reshape(Bdy_Tri_List,Num_Tri,1));
    
else
    Bdy_Tri_List = [];
    P2_Bdy_Elem = [];
end

end