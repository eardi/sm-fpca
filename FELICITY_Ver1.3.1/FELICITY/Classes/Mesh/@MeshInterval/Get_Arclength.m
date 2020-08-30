function AL = Get_Arclength(obj)
%Get_Arclength
%
%   This returns the local arc-length value at each vertex in the curve mesh.
%   Note: the arc-length value at the first vertex is zero.  This also assume that the 1-D
%   curve mesh is a manifold (e.g. no T-junctions).
%
%   AL = obj.Get_Arclength();
%
%   AL = Mx1 column vector, where M is the number of vertices in the mesh.
%
%   Note: the arc-length variable is computed in an ordered way.  Thus, the difference in
%   the arc-length value between two vertices of a given edge is the length of the edge.

% Copyright (c) 11-07-2014,  Shawn W. Walker

% get the lengths of all the edges
Edge_Lengths = obj.Volume;

% init
AL = 0*obj.Points(:,1);

% need to order the edges
EI = obj.vertexAttachments(); % for all vertices

% error checks!
Tail_Empty = (EI(:,1)==0);
Head_Empty = (EI(:,2)==0);
Num_Tail_Empty = sum(Tail_Empty);
Num_Head_Empty = sum(Head_Empty);
if (Num_Tail_Empty~=Num_Head_Empty)
    error('These should be equal.  Something is wrong with the mesh!');
end
if (Num_Tail_Empty > 1)
    error('There should not be more than one vertex with an empty tail edge!');
end
if (Num_Head_Empty > 1)
    error('There should not be more than one vertex with an empty head edge!');
end

% check if the curve is open or closed
if (Num_Head_Empty==1) % the curve is open
    % start at the vertex that is a tail, but not a head
    VI = find(Head_Empty);
    VI_final = find(Tail_Empty);
else
    % start anywhere (the curve is closed)
    VI = 1;
    VI_final = 1;
end

while (true)
    Edge_Ind = EI(VI,1); % get tail edge
    Edge = obj.ConnectivityList(Edge_Ind,:);
    if (Edge(1)~=VI)
        error('This should not happen!');
    end
    AL(Edge(2)) = AL(VI) + Edge_Lengths(Edge_Ind);
    VI = Edge(2);
    if (VI==VI_final)
        break;
    end
end

end