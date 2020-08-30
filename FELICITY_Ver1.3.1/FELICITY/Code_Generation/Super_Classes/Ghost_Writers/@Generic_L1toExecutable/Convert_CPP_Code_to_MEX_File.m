function [status, Path_To_Mex] = Convert_CPP_Code_to_MEX_File(obj,cpp_file_name,mex_file_name,Type_STR)
%Convert_CPP_Code_to_MEX_File
%
%   This compiles the generated C++ code into a MEX file.

% Copyright (c) 06-16-2016,  Shawn W. Walker

[~, FILE] = fileparts(cpp_file_name);
SRC = fullfile(obj.GenCode_Dir, cpp_file_name);

if isempty(mex_file_name)
    OUT_FILE_STR = FILE;
else
    OUT_FILE_STR = mex_file_name;
end

disp('---------------------------------------------------------------');
disp(['***Converting C++ ', Type_STR, ' Code =====> MATLAB MEX File']);
disp('FELICITY is executing this command:');

% compile auto generated C++ code
% different compiler options
if ismac
    MEX_str = ['mex', ' -v ', 'CFLAGS="$CFLAGS -std=c++0x"', ' -largeArrayDims ', SRC, ' -outdir ', obj.MEXFile_Dir, ' -output ', OUT_FILE_STR];
    disp(['---->  ', MEX_str]);
    feval(@mex, '-v', 'CFLAGS="$CFLAGS -std=c++0x"', '-largeArrayDims', SRC, '-outdir', obj.MEXFile_Dir, '-output', OUT_FILE_STR);
elseif isunix
    MEX_str = ['mex', ' -v ', 'CXXFLAGS="$CXXFLAGS -std=c++0x"', ' -largeArrayDims ', SRC, ' -outdir ', obj.MEXFile_Dir, ' -output ', OUT_FILE_STR];
    disp(['---->  ', MEX_str]);
    feval(@mex, '-v', 'CXXFLAGS="$CXXFLAGS -std=c++0x"', '-largeArrayDims', SRC, '-outdir', obj.MEXFile_Dir, '-output', OUT_FILE_STR);
else % (ispc) windows should automatically have c++0x (i.e. lambdas, etc...)
    MEX_str = ['mex', ' -v ', ' -largeArrayDims ', SRC, ' -outdir ', obj.MEXFile_Dir, ' -output ', OUT_FILE_STR];
    disp(['---->  ', MEX_str]);
    feval(@mex, '-v', '-largeArrayDims', SRC, '-outdir', obj.MEXFile_Dir, '-output', OUT_FILE_STR);
end
Path_To_Mex = fullfile(obj.MEXFile_Dir, mex_file_name);

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