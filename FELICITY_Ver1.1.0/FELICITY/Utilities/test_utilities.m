function status = test_utilities()
%test_utilities
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_FELLog;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Utility tests passed!');
end

end