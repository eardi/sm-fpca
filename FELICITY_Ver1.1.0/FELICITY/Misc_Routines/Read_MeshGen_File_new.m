function [Vtx, Tri_Elem, Bdy_Edge] = Read_MeshGen_File_new(varargin)
%Read_MeshGen_File_3x7
%
%   This routine reads a data file in the MeshGen 2-D format for an unstructured triangle
%   grid.  See their documentation for more information.  Note: the MeshGen file can
%   contain very specific data on the types of boundary edges.  Most of that is thrown
%   away here.  Could be useful later on.
%
%   [Vtx, Tri_Elem, Bdy_Edge, Middle_Bdy_Vtx] = Read_MeshGen_File(FileName)
%
%   OUTPUTS
%   -------
%   Vtx, Tri_Elem, Bdy_Seg, Middle_Bdy_Vtx:
%       Mesh data structures.
%
%   INPUTS
%   ------
%   FileName:
%       Text string specifying the filename to write to.

% Copyright (c) 04-03-2008,  Shawn W. Walker

% parse input
FileName = varargin{1};
if ~ischar(FileName)
    error('Need a FileName string as input!');
end

% BEGIN: header info

fid = fopen(FileName,'r');

dummy_1 = Skim_Filler(fid);

% END: header info

% get the total number of vertices, triangles, and boundary edges
Num_Vtx     = fscanf(fid, '%d', 1);
Num_Tri     = fscanf(fid, '%d', 1);
Num_BdyEdge = fscanf(fid, '%d', 1);
LINE = fgetl(fid); % remove the rest of the line

dummy_1 = Skim_Filler(fid);

% read in the vertices
Vtx = fscanf(fid,'%u  %f  %f\n',[3,Num_Vtx])';
Vtx(:,1) = [];

dummy_1 = Skim_Filler(fid);

% read in the triangles
Tri_Elem = fscanf(fid,'%u  %u  %u  %u\n',[4,Num_Tri])';
Tri_Elem(:,1) = [];

dummy_1 = Skim_Filler(fid);

% read in the edges
Bdy_Edge = fscanf(fid,'%u  %u  %u\n',[5,Num_BdyEdge])';
Bdy_Edge(:,1) = [];

% END: read in the edges

fclose(fid);

end

function LINE = Skim_Filler(fid)
%Read_MeshGen_File_3x7
%
%   This reads through the useless stuff.

% Copyright (c) 04-03-2008,  Shawn W. Walker

% skim through the filler
START = ftell(fid);
LINE  = fgetl(fid);
END   = ftell(fid);

count = 0;
while strncmp(LINE,';',1)
    START = ftell(fid);
    % keep reading
    LINE = fgetl(fid);
    END = ftell(fid);
    
    count = count + 1;
    if count > 100
        disp('Too many '';''.');
        error('Error reading MeshGen File!');
    end
end

% set the file pointer back
status = fseek(fid, START - END, 0);

end