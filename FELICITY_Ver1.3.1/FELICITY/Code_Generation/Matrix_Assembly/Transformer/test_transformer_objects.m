function status = test_transformer_objects()
%test_transformer_objects
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_Geometric_Trans;
Test_Files(2).FH = @test_H1_Trans;
Test_Files(3).FH = @test_Hdiv_Trans;
Test_Files(4).FH = @test_Hcurl_Trans;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Transformer Object tests passed!');
end

end