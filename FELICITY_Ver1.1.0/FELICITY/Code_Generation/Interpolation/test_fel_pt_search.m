function status = test_fel_pt_search()
%test_fel_pt_search
%
%   Test code for FELICITY class.

% Copyright (c) 07-24-2014,  Shawn W. Walker

Test_Files( 1).FH = @test_FEL_Pt_Search_1D;
Test_Files( 2).FH = @test_FEL_Pt_Search_Curve_In_2D;
Test_Files( 3).FH = @test_FEL_Pt_Search_Curve_In_3D;
Test_Files( 4).FH = @test_FEL_Pt_Search_2D;
Test_Files( 5).FH = @test_FEL_Pt_Search_Surface_In_3D;
Test_Files( 6).FH = @test_FEL_Pt_Search_3D;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Point Search tests passed!');
end

end