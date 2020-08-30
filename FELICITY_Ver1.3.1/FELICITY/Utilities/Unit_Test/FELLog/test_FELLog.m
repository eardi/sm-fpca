function status = test_FELLog()
%test_FELLog
%
%   Test code for FELICITY class.

% Copyright (c) 12-10-2010,  Shawn W. Walker

current_file = mfilename('fullpath');
DIR1 = fileparts(current_file);
FN1     = 'test_FELLog.dat';
ref_FN1 = 'ref_FELLog.dat';
test_LOG = FELLog(DIR1,FN1,'UNIT-TEST OF LOG FILE',true);

% add some comments
test_LOG = test_LOG.Add_Comment(1,'This is just a test...');
test_LOG = test_LOG.Add_Comment(2,'Is it still working...');
test_LOG = test_LOG.Add_Comment(3,'Here is a really long comment.\n  Make sure the files diff to 0!');
% print to screen
%test_LOG.Print([]);
% write to file
test_LOG.Write([],[]);

% compare with reference file
File_Main = fullfile(DIR1,FN1);
File_REF  = fullfile(DIR1,ref_FN1);
IDENTICAL = CompareFiles(File_Main,File_REF);
if ~IDENTICAL
    status = 1;
    visdiff(File1,File2);
else
    % everything is ok!
    status = 0;
    delete(File_Main);
end

end