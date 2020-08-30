function status = test_elem_defn()
%test_elem_defn
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2016,  Shawn W. Walker

Test_Files( 1).FH = @test_Lagrange_Element_Print_Basis_Func;
Test_Files( 2).FH = @test_BDM_Element_Print_Basis_Func;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Element Definition tests passed!');
end

end