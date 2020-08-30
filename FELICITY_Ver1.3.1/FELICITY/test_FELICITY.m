function status = test_FELICITY()
%test_FELICITY
%
%   Run the test suite for FELICITY.

% Copyright (c) 06-25-2020,  Shawn W. Walker

VER_NUMBER = '1.3.1';

Test_Files( 1).FH = @compile_static_codes;
Test_Files( 2).FH = @test_utilities;
Test_Files( 3).FH = @test_static_codes;
Test_Files( 4).FH = @test_mesh_classes;
Test_Files( 5).FH = @test_elem_defn;
Test_Files( 6).FH = @test_fem_classes;
Test_Files( 7).FH = @test_managesim_classes;
Test_Files( 8).FH = @test_dof_numbering;
Test_Files( 9).FH = @test_matrix_assembly;
Test_Files(10).FH = @test_fel_pt_search;
Test_Files(11).FH = @test_fel_interpolation;
Test_Files(12).FH = @test_felicity_demos;

output_FELICITY();

FELICITY_user_help();

status = 1;
VALID = and(check_path_length(),check_dir_path_for_spaces());
if VALID
    for ind = 1:length(Test_Files)
        status = Test_Files(ind).FH();
        if (status~=0)
            disp('Test failed!');
            disp(['See ----> ', func2str(Test_Files(ind).FH)]);
            break;
        end
    end
else
    status = -1;
end

if (status==0)
    disp('<<<< All FELICITY tests passed >>>>');
    disp('   ');
    disp('*** Your FELICITY installation is fully functional ***');
    output_FELICITY();
    disp(['Version Number:  ', VER_NUMBER]);
else
    disp('<<<< ERROR >>>>');
    disp('   ');
    disp('*** Your FELICITY installation is NOT working... ***');
    disp('   ');
end

end

function VALID = check_path_length()
% make sure root path length is not longer than 60 characters

PATH = [fileparts(mfilename('fullpath')), '\'];
LEN = length(PATH);
if LEN > 60
    choice = questdlg({'It seems you installed FELICITY here:';
                       ['''', PATH, '''.'];
                       ['The length of this path is too long ', '(', num2str(LEN), ' chars long)', '.'];
                       'It is recommended that you install FELICITY closer to your root.';
                       '(Ideally, the path char length should be less than 60.)'
                       'Otherwise, the unit tests may fail!';
                       '';
                       'Do you wish to continue with unit testing?'}, ...
	                   'FELICITY Root Directory', 'Abort','Continue','Continue');
    if strcmp(choice,'Abort')
        VALID = false;
    else
        VALID = true;
    end
else
    VALID = true;
end

end

function VALID = check_dir_path_for_spaces()
% make sure root path does not contain space characters

PATH = [fileparts(mfilename('fullpath')), '\'];
NO_space = isempty(regexp(PATH, '\s', 'once'));
if (~NO_space) % if there is a space...
    choice = questdlg({'It seems you installed FELICITY here:';
                       ['''', PATH, '''.'];
                       'Some of the folder names in the root contain a "space" character.';
                       'For example, you may have installed under the directory:';
                       '             ''C:\Program Files\...''';
                       'This is *not* recommended!';
                       'You should install FELICITY under a directory *without* spaces.';
                       'Otherwise, the unit tests may fail!';
                       '';
                       'Do you wish to continue with unit testing?'}, ...
	                   'FELICITY Root Directory', 'Abort','Continue','Continue');
    if strcmp(choice,'Abort')
        VALID = false;
    else
        VALID = true;
    end
else
    VALID = true;
end

end

function output_FELICITY()

disp(' ');
disp(' ______ ______ _      _____ _____ _____ _________     __');
disp('|  ____|  ____| |    |_   _/ ____|_   _|__   __\ \   / /');
disp('| |__  | |__  | |      | || |      | |    | |   \ \_/ / ');
disp('|  __| |  __| | |      | || |      | |    | |    \   /  ');
disp('| |    | |____| |____ _| || |____ _| |_   | |     | |   ');
disp('|_|    |______|______|_____\_____|_____|  |_|     |_|   ');
disp(' ');

end