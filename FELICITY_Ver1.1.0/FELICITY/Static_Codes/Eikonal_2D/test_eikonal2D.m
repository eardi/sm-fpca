function status = test_eikonal2D()
%test_eikonal2D
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_Eikonal2D_Solve;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Eikonal (2D) solver tests passed!');
end

end