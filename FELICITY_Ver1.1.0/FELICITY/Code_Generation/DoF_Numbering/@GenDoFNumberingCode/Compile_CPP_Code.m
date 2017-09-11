function [status, Path_To_Mex] = Compile_CPP_Code(obj,mexFileDir,mexFileName)
%Compile_CPP_Code
%
%   This compiles the code for DoF allocation.

% Copyright (c) 12-10-2010,  Shawn W. Walker

disp('---------------------------------------------------------------');
disp('***Compile DoF Map Allocation C++ Code...');
disp('');

% compile it
Main_Code_File = fullfile(obj.Output_Dir, 'mexDoF_Allocator.cpp');
disp('Compile DoF numbering code...');
% compile auto generated FEM DoF allocator
MEX_str = ['mex', ' -v ', ' -largeArrayDims ', Main_Code_File, ' -outdir ', mexFileDir, ' -output ', mexFileName];
disp(['---->  ', MEX_str]);
%eval(MEX_str);
feval(@mex, '-v', '-largeArrayDims', Main_Code_File, '-outdir', mexFileDir, '-output', mexFileName);
Path_To_Mex = fullfile(mexFileDir,mexFileName);

disp('');
disp('***Code Compiling Complete...');
disp('---------------------------------------------------------------');

% make sure it really did get made!
if ~(exist(Path_To_Mex,'file')==3)
    disp('MEX file does NOT exist!');
    status = -1;
else
    disp('***MEX File Generated.');
    status = 0;
end

end