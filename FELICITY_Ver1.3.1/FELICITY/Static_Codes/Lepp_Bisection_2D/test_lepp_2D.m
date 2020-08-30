function status = test_lepp_2D()
%test_lepp_2D
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_LEPP_Bisection_2D;
Test_Files(2).FH = @test_LEPP_Bisection_2D_with_Subdomains;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***LEPP 2D Bisection tests passed!');
end

end