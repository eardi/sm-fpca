function IN = inpolyhedron(varargin)
%INPOLYHEDRON  Tests if points are inside a 3D triangulated (faces/vertices) surface
%
%   IN = INPOLYHEDRON(FV,QPTS) tests if the query points (QPTS) are inside the
%   patch/surface/polyhedron defined by FV (a structure with fields 'vertices' and
%   'faces'). QPTS is an N-by-3 set of XYZ coordinates. IN is an N-by-1 logical
%   vector which will be TRUE for each query point inside the surface.
%
%   INPOLYHEDRON(FACES,VERTICES,...) takes faces/vertices separately, rather than in
%   an FV structure.
%
%   IN = INPOLYHEDRON(..., XVEC, YVEC, ZVEC) allows for 3D gridded query points
%   rather than an N-by-3 array of points. X, Y, and Z coordinates of the grid
%   supplied in XVEC, YVEC, and ZVEC respectively. IN will return as a 3D logical
%   volume with SIZE(IN) = [LENGTH(YVEC) LENGTH(XVEC) LENGTH(ZVEC)]. Currently,
%   INPOLYHEDRON uses MESHGRID internally, however this syntax has been reserved as
%   memory/speed improvements may be implemented for this form of input in the
%   future.
%
%   INPOLYHEDRON(...,'PropertyName',VALUE,'PropertyName',VALUE,...) tests query
%   points using the following optional property values:
%
%   TOL           - Tolerance on the tests for "inside" the surface. You can think of
%   tol as the distance a point may possibly lie above/below the surface, and still
%   be perceived as on the surface. Due to numerical rounding nothing can ever be
%   done exactly here. Defaults to ZERO. Note that in the current implementation TOL
%   only affects points lying above/below a surface triangle (in the Z-direction).
%   Points coincident with a vertex in the XY plane are currently considered OUT of
%   the surface. More formal rules can be implemented with input/feedback from users.
%
%   GRIDSIZE      - Internally, INPOLYHEDRON uses a divide-and-conquer algorithm to
%   split all faces into a chessboard-like grid of GRIDSIZE-by-GRIDSIZE regions.
%   Performance will be a tradeoff between a small GRIDSIZE (few iterations, more
%   data per iteration) and a large GRIDSIZE (many iterations of small data
%   calculations). The sweet-spot has been experimentally determined (on a win64
%   system) to be correlated with the number of faces/vertices. You can overwrite
%   this automatically computed choice by specifying a GRIDSIZE parameter.
%
%   FACENORMALS   - By default, the normals to the FACE triangles are computed as the
%   cross-product of the first two triangle edges. You may optionally specify face
%   normals here.
%
%   FLIPNORMALS   - (Defaults FALSE). Triangle face normals are presumed to point
%   towards the "inside" of the surface. If your surface normals are defined pointing
%   "out" of the volume, set FLIPNORMALS to TRUE.
%
%   Example:
%       tmpvol = zeros(20,20,20);       % Empty voxel volume
%       tmpvol(5:15,8:12,8:12) = 1;     % Turn some voxels on
%       tmpvol(8:12,5:15,8:12) = 1;
%       tmpvol(8:12,8:12,5:15) = 1;
%       fv = isosurface(tmpvol, 0.99);  % Create the patch object
%       pts = rand(200,3)*12 + 4;     % Make some query points
%       in = inpolyhedron(fv, pts);     % Test which are inside the patch
%       figure, hold on, view(3)        % Display the result
%       patch(fv,'FaceColor','g','FaceAlpha',0.2)
%       plot3(pts(in,1),pts(in,2),pts(in,3),'bo','MarkerFaceColor','b')
%       plot3(pts(~in,1),pts(~in,2),pts(~in,3),'ro'), axis image

% TODO-list
% - Define exactly how IN/ON should work. (via user feedback)
% - Improve overall memory footprint. (need examples with MEM errors)
% - Implement a low-memory-footprint version for xVec, yVec, zVec input
% - Implement an "ignore these" step to speed up calculations for:
%     * Vertically oriented faces (no z-component in face normal)
%     * Query points outside the convex hull of the faces/vertices input
% - Get a better/best gridSize calculation. User feedback?
% - Detect cases where X-rays or Y-rays would be better than Z-rays?

%
%   Author: Sven Holcombe, 17-8-12

%%

% FACETS is an unpacked arrangement of faces/vertices. It is [3-by-3-by-N],
% with 3 1-by-3 XYZ coordinates of N faces.
[facets, qPts, options] = parseInputs(varargin{:});
numFaces = size(facets,3);

% Function speed can be thought of as a function of grid size. A small number of grid
% squares means iterating over fewer regions (good) but with more faces/qPts to
% consider each time (bad). For any given mesh/queryPt configuration, there will be a
% sweet spot that minimises computation time. There will also be a constraint from
% memory available - low grid sizes means considering many queryPt/faces at once,
% which will require a larger memory footprint. Here we will let the user specify
% gridsize directly, or we will estimate the optimum size based on prior testing.
if ~isempty(options.gridsize)
    gridSize = options.gridsize;
else
    gridSize = round(-1.0e-8*numFaces^2 + 0.00095*numFaces + 18);
    if numFaces>50000, gridSize = 40; end
end


%% Find candidate qPts -> triangles pairs
% We have a large set of query points. For each query point, find potential
% triangles that would be pierced by vertical rays through the qPt. First,
% a simple filter by XY bounding box

% Calculate the bounding box of each facet
minFacetCoords = permute(min(facets(:,1:2,:),[],1),[3 2 1]);
maxFacetCoords = permute(max(facets(:,1:2,:),[],1),[3 2 1]);

% Set rescale values to rescale all vertices between 0(-eps) and 1(+eps)
scalingOffsetsXY = min(minFacetCoords,[],1) - eps;
scalingRangeXY = max(maxFacetCoords,[],1) - scalingOffsetsXY + 2*eps;

% Based on scaled min/max facet coords, get the [lowX lowY highX highY] "grid" index
% of all faces
lowToHighGridIdxs = floor(bsxfun(@rdivide, ...
    bsxfun(@minus, ... % Use min/max coordinates of each facet (+/- the tolerance)
    [minFacetCoords-options.tol maxFacetCoords+options.tol],...
    [scalingOffsetsXY scalingOffsetsXY]),...
    [scalingRangeXY scalingRangeXY]) * gridSize) + 1;

% Build a grid of cells. In each cell, place the facet indices that encroach into
% that grid region. Similarly, each query point will be assigned to a grid region.
% Note that query points will be assigned only one grid region, facets can cover many
% regions. Furthermore, we will add a tolerance to facet region assignment to ensure
% a query point will be compared to facets even if it falls only on the edge of a
% facet's bounding box, rather than inside it.
cells = cell(gridSize);
[unqLHgrids,~,facetInds] = unique(lowToHighGridIdxs,'rows');

%%
tic
tmpInds = accumarray(facetInds,1:length(facetInds), [],@(x){x});
for xi = 1:gridSize
    xyMinMask = xi >= unqLHgrids(:,1) & xi <= unqLHgrids(:,3);
    for yi = 1:gridSize
        cells{yi,xi} = cat(1,tmpInds{xyMinMask & yi >= unqLHgrids(:,2) & yi <= unqLHgrids(:,4)});
        % The above line (with accumarray) is faster with equiv results than:
        % % cells{yi,xi} = find(ismember(facetInds, xyInds));
    end
end
% With large number of facets, memory may be important:
clear lowToHightGridIdxs LHgrids facetInds tmpInds xyMinMask minFacetCoords maxFacetCoords

%%
% Precompute the 3d normals to all facets (triangles). Do this via the cross product
% of the first edge vector with the second. Normalise the result.
allEdgeVecs = facets([2 3 1],:,:) - facets(:,:,:);
if isempty(options.facenormals)
    allFacetNormals =  bsxfun(@times, allEdgeVecs(1,[2 3 1],:), allEdgeVecs(2,[3 1 2],:)) - ...
        bsxfun(@times, allEdgeVecs(2,[2 3 1],:), allEdgeVecs(1,[3 1 2],:));
    allFacetNormals = bsxfun(@rdivide, allFacetNormals, sqrt(sum(allFacetNormals.^2,2)));
else
    allFacetNormals = permute(options.facenormals,[3 2 1]);
end
if options.flipnormals
    allFacetNormals = -allFacetNormals;
end

% Precompute the 2d unit vectors making up each facet's edges in the XY plane.
allEdgeUVecs = bsxfun(@rdivide, allEdgeVecs(:,1:2,:), sqrt(sum(allEdgeVecs(:,1:2,:).^2,2)));

% Precompute the inner product between edgeA.edgeC, edgeB.edgeA, edgeC.edgeB
allEdgeEdgeDotPs = sum(allEdgeUVecs .* -allEdgeUVecs([3 1 2],:,:),2) - 1e-9;


%%
% Since query points are most likely given as a (3D) grid of query locations, we only
% need to consider the unique XY locations when asking which facets a vertical ray
% through an XY location would pierce.

% Gather the unique XY query locations
[unqQpts,~,unqQPtInds] = unique(qPts(:,1:2),'rows');
unqQptIndsCell = accumarray(unqQPtInds,1:length(unqQPtInds), [],@(x){x});

% Assign each query location to a grid region
unqQgridXY = floor(bsxfun(@rdivide, bsxfun(@minus, unqQpts, scalingOffsetsXY),...
    scalingRangeXY) * gridSize) + 1;

% We are about to iterate over grid regions. Since some (relatively small) number of
% unique XY query points will belong to the same grid region, we want to find the
% changes in grid locations as we go through the unique XY query locations. Build
% that list.
newInds = cat(1, 0, find(any(diff(unqQgridXY,[],1),2)), size(unqQgridXY,1));

% To fit nicely into the below calculations, we're going to reshape the query points
% from an N-by-2 array to a 1-by-2-by-1-by-N array. This will make it easier to do
% some tricky bsxfun() calls.
unqQpts = reshape(unqQpts',1,2,1,[]);

% Start with every query point NOT inside the polyhedron. We will iteratively find
% those query points that ARE inside.
IN = false(size(qPts,1),1);

for i = 1:length(newInds)-1
    fromTo = newInds(i)+1:newInds(i+1);
    
    % Gather information about this GRID. We need to know the grid indices, and from
    % that we get the facet indices of all triangles that enter this grid cell
    gridNoXY = unqQgridXY(fromTo(1),:);
    if any(gridNoXY>gridSize | gridNoXY<1), continue; end
    allFacetInds = cells{gridNoXY(2),gridNoXY(1)};
    % If there are no facets in this grid region to consider, we need go no further
    if isempty(allFacetInds), continue; end
    % We get all the facet coordinates (ie, triangle vertices) of triangles that
    % intrude into this grid location. The size is [3-by-2-by-N], for the
    % [3vertices-by-XY-by-Ntriangles]
    candVerts = facets(:,1:2,allFacetInds);
    
    % We need to know about the query points. To check, for intersections with
    % triangles, we only need the distinct XY coordinates of the (possibly many)
    % query points.
    queryPtsXY = unqQpts(1,:,1,fromTo);
    
    % Get unit vectors pointing from each triangle vertex to my query point(s)
    vert2ptVecs = bsxfun(@minus, queryPtsXY, candVerts);
    vert2ptUVecs = bsxfun(@rdivide, vert2ptVecs, sqrt(sum(vert2ptVecs.^2,2)));
    % Get unit vectors pointing around each triangle (along edge A, edge B, edge C)
    edgeUVecs = allEdgeUVecs(:,:,allFacetInds);
    % Get the inner product between edgeA.edgeC, edgeB.edgeA, edgeC.edgeB
    edgeEdgeDotPs = allEdgeEdgeDotPs(:,:,allFacetInds);
    % Get inner products between each edge unit vec and the UVs from qPt to vertex
    edgeQPntDotPs = sum(bsxfun(@times, edgeUVecs, vert2ptUVecs),2);
    qPntEdgeDotPs = sum(bsxfun(@times,vert2ptUVecs, -edgeUVecs([3 1 2],:,:)),2);
    % If both inner products 2 edges to the query point are greater than the inner
    % product between the two edges themselves, the query point is between the V
    % shape made by the two edges. If this is true for all 3 edge pair, the query
    % point is inside the triangle.
    result = all( bsxfun(@gt, edgeQPntDotPs, edgeEdgeDotPs) & bsxfun(@gt, qPntEdgeDotPs, edgeEdgeDotPs),1);
    
    qPtHitsTriangles = any(result,3);
    % If NONE of the query points pierce ANY triangles, we can skip forward
    if ~any(qPtHitsTriangles), continue, end

    % In the next step, we'll need to know the indices of ALL the query points at
    % each of the distinct XY coordinates. Let's get their indices into "qPts" as a
    % cell of length M, where M is the number of unique XY points we had found.
    
    for ptNo = find(qPtHitsTriangles(:))'
        piercedFacetInds = allFacetInds(result(1,1,:,ptNo));
        % Get the 1-by-3-by-N set of triangle normals that this qPt pierces       
        piercedTriNorms = allFacetNormals(:,:,piercedFacetInds);
        % Get
        %         queryPtInds = find(unqQPtInds==fromTo(ptNo));
        queryPtInds = unqQptIndsCell{fromTo(ptNo)};
        
        % Pick the first vertex as the "origin" of a plane through the facet. Get the
        % vectors from each query point to each facet origin
        facetToQptVectors = bsxfun(@minus, qPts(queryPtInds,:), facets(1,:,piercedFacetInds));
        
        % Calculate how far you need to go up/down to pierce the facet's plane.
        % Positive direction means "inside" the facet, negative direction means
        % outside.
        facetToQptDists = bsxfun(@rdivide, ...
            sum(bsxfun(@times,piercedTriNorms,facetToQptVectors),2), ...
            abs(piercedTriNorms(:,3,:)));
        
        [~,triIdx] = min(abs(facetToQptDists),[],3);
        closestFacetDists = zeros(size(queryPtInds));
        for ptSubNo = 1:numel(queryPtInds)
            closestFacetDists(ptSubNo) = facetToQptDists(ptSubNo, triIdx(ptSubNo));
        end
        
        IN(queryPtInds(closestFacetDists > -options.tol)) = true;
    end
    
end

% If they provided X,Y,Z vectors of query points, be kind and reshape the output.
if ~isempty(options.griddedInputSize)
    IN = reshape(IN, options.griddedInputSize);
end


%% Input handling subfunctions
function [facets, qPts, options] = parseInputs(varargin)
    
% Gather FACES and VERTICES
if isstruct(varargin{1})                        % inpolyhedron(FVstruct, ...)
    if ~all(isfield(varargin{1},{'vertices','faces'}))
        error( 'Structure FV must have "faces" and "vertices" fields' );
    end
    faces = varargin{1}.faces;
    vertices = varargin{1}.vertices;
    varargin(1) = []; % Chomp off the faces/vertices
    
else                                            % inpolyhedron(FACES, VERTICES, ...)
    faces = varargin{1};
    vertices = varargin{2};
    varargin(1:2) = []; % Chomp off the faces/vertices
end

% Unpack the faces/vertices into [3-by-3-by-N] facets. It's better to
% perform this now and have FACETS only in memory in the main program,
% rather than FACETS, FACES and VERTICES
facets = vertices';
facets = permute(reshape(facets(:,faces'), 3, 3, []),[2 1 3]);

% Extract query points
if length(varargin)<2 || ischar(varargin{2})    % inpolyhedron(F, V, [x(:) y(:) z(:)], ...)
    qPts = varargin{1};
    varargin(1) = []; % Chomp off the query points
else                                            % inpolyhedron(F, V, xVec, yVec, zVec, ...)
    [x,y,z] = meshgrid(varargin{1:3});
    griddedInputSize = size(x);
    qPts = [x(:) y(:) z(:)];
    % Chomp off the query points and tell the world that it's gridded input.
    varargin(1:3) = [];
    varargin = [varargin {'griddedInputSize',griddedInputSize}];
end
    
% Extract configurable options
options = parseOptions(varargin{:});


function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('gridsize',[], @(x)scalar(x) && isnumeric(x))
IP.addParamValue('tol', 0, @(x)isscalar(x) && isnumeric(x))
IP.addParamValue('facenormals',[]);
IP.addParamValue('flipnormals',false);
IP.addParamValue('griddedInputSize',[]);
IP.parse(varargin{:});
options = IP.Results;
