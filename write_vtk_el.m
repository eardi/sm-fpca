function [] = write_vtk_el(vertex,face,signal,fname,signal_name)
% EXPORT_VTK(data,fname,funname) save a fshape structure into a .vtk file
%
%Input
%   data : struct with fields 'x','G' and 'f'. (the field 'f' may be optional)
%   fname : name of the output file
%   signal_name (optional) : name of the functional to be set in the.vtk file
%
% Authors : this file is part of the fshapesTk by B. Charlier, N. Charon, A. Trouve (2012-2014)


if nargin == 4
    signal_name = 'signal';
end

if size(vertex,2)<=2
    vertex = [vertex,zeros(size(vertex,1),3-size(vertex,2))];
end



% open file
fid = fopen(fname,'w');

% header
fprintf(fid,'# vtk DataFile Version 3.0\n');
fprintf(fid,'vtk generated by fshapesTk\n');

fprintf(fid,'%s\n','ASCII');
fprintf(fid,'DATASET POLYDATA\n');

%points
fprintf(fid,'POINTS %u double\n', size(vertex,1));

x = repmat('%G ',1,size(vertex,2)-1);
fprintf(fid,[x,'%G\n'], vertex');



%edges
if size(face,2) == 3
    type = 'POLYGONS';
elseif size(face,2) == 2
    type = 'LINES';
end
fprintf(fid,['\n%s %u %u\n'], type,size(face,1),(size(face,2)+1).*size(face,1));

x = [num2str(size(face,2)),' ',repmat('%u ',1,size(face,2)-1)];
fprintf(fid,[x,'%u\n'], (face-1)');


% functional
if size(signal,2)==1
    signal = signal';
end

fprintf(fid,['\nPOINT_DATA ','%u\n'],size(vertex,1)); % 5== triangle, 1 == vertex, 3 == lines,
for i=1:size(signal,1)
   fprintf(fid,['SCALARS ',[signal_name num2str(i)],' double\nLOOKUP_TABLE default\n']);
   fprintf(fid,['%G\n'],signal(i,:));
end
fclose(fid);

fprintf('\nFile saved in %s',fname)

end