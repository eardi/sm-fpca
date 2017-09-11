function status = Process_Quad_Data_to_CPP_Code(fid_Open,Quad_Data,COMMENT)
%Process_Quad_Data_to_CPP_Code
%
%   This takes given quadrature points and converts into C++ code!

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';

Quad_Data = double(Quad_Data); % make sure it is double!

% first setup the format string
FORMAT_STR = '%2.17E';
for k=2:size(Quad_Data,2)
    FORMAT_STR = [FORMAT_STR, ', %2.17E'];
end

if (size(Quad_Data,2) > 1)
    FORMAT_STR = ['{', FORMAT_STR, '}'];
end

Num_Lines = size(Quad_Data,1);
if (Num_Lines > 1)
    % now loop through and output the basis function evaluations for each quad point
    status = fprintf(fid_Open, [COMMENT, '    ', FORMAT_STR, ', \\', ENDL], Quad_Data(1:end-1,:)');
    % the last line does not have a comma!
    status = fprintf(fid_Open, [COMMENT, '    ', FORMAT_STR, '  \\', ENDL], Quad_Data(end,:)');
elseif (Num_Lines == 1)
    % one line does not have a comma!
    status = fprintf(fid_Open, [COMMENT, '    ', FORMAT_STR, '  \\', ENDL], Quad_Data(1,:)');
else
    error('Invalid!');
end

end