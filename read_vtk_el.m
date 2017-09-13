function [vertex,face,signal] = read_vtk_el(filename)

% read_vtk - read data from VTK file. (Based on a work Mario Richtsfeld)
%
%   [vertex,face] = read_vtk(filename, verbose);
%
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 2' (POLYGONS) or 'nb.face x 2' (LINES) array specifying the connectivity of the mesh.
%
% Authors : this file is a modified version of read_vtk in fshapesTk by B. Charlier, N. Charon, A. Trouve (2012-2014)  


fid = fopen(filename,'r');

%---------------
% read header 
%----------------

if( fid==-1 )
    error('Can''t open the file.');
end

str = fgets(fid);  % -1 if eof
if ~strcmp(str(3:5), 'vtk')
    error('The file is not a valid VTK one.');    
end

%jump 3 lines
[~] = fgets(fid);
[~] = fgets(fid);
[~] = fgets(fid);

%----------------
% read vertices
%----------------

str = fgets(fid);
info = sscanf(str,'%s %*s %*s', 6);

if strcmp(info,'POINTS')
    nvert = sscanf(str,'%*s %d %*s', 1);
    [A,cnt] = fscanf(fid,'%G ', 3*nvert);
    if cnt~=3*nvert
        warning('Problem in reading vertices.');
    end
    A = reshape(A, 3, cnt/3);
    vertex = A';
end

%----------------
% read polygons
%----------------

str = fgets(fid);
info = sscanf(str,'%s %*s %*s');

if strcmp(info,'POLYGONS')  || strcmp(info,'LINES')
    nface = sscanf(str,'%*s %d %d', 2);
    [A,cnt] = fscanf(fid,'%d ', nface(2));
    if cnt~=nface(2)
        warning('Problem in reading faces.');
    end
    A = reshape(A, nface(2)/nface(1),nface(1));
    face = (A(2:end,:)+1)';
else
    error('Problem in reading faces.')
end

%-------------------
% read signal
%-------------------

str = fgets(fid);
info = sscanf(str,'%s %*s', 10);

if strcmp(info,'POINT_DATA')
    
    nvertex = sscanf(str,'%*s %d', 1);
    [~] = fgets(fid);
    [~] = fgets(fid);
    
    [signal,cnt] = fscanf(fid,'%G', nvertex);
    if cnt~=nvertex
        error('Problem in reading signal.');
    end
else
     error('Problem in reading signal.');
end
fclose(fid);

end
