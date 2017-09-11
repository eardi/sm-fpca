function status = test_SaveLoad_1()
%test_SaveLoad_1
%
%   Test code for FELICITY class.

% Copyright (c) 04-09-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% make a directory to store stuff in
SD = 'Data_Test_1';
success_flag = mkdir(Current_Dir,SD);
status = ~success_flag;
Data_Dir = fullfile(Current_Dir,SD);
clear SD;

% create the object
File_Prefix = 'SimData';
SL = FEL_SaveLoad(Data_Dir,File_Prefix);
clear Data_Dir File_Prefix;

% start saving some stuff
myData.matrix = rand(10,10);
myData.soln   = rand(10,1);
myData.string = 'Hey you!';

% save at index 0
SL.Save('dynamic',myData,0);

% save at index 1
myData.matrix = rand(10,10);
myData.soln   = rand(10,1);
myData.string = 'I''m talking to you!';
SL.Save('dynamic',myData,1);

Ind_To_Chk = 5;
refData = myData; % init
for ind = 2:10
    % save at index 1
    myData.matrix = rand(10,10);
    myData.soln   = rand(10,1);
    SL.Save('dynamic',myData,ind);
    if (ind==Ind_To_Chk)
        refData = myData;
    end
end

% check the max index
Max_Ind = SL.Get_Max_Index;
if (Max_Ind~=10)
    disp('Max file index is incorrect!');
    disp('Save/Load test failed!');
    status = 1;
end

% now load back one of the pieces of data and make sure it is the same!
chkData = SL.Load('dynamic',Ind_To_Chk);
if ~isequal(refData,chkData)
    disp('Data is not the same after loading!');
    disp('Save/Load test failed!');
    status = 1;
end

% now delete all of the data
SL.Delete_Data;

% make sure max index is -1 now (meaning no data)
Max_Ind = SL.Get_Max_Index;
if (Max_Ind~=-1)
    disp('Max file index should be -1!');
    disp('Save/Load test failed!');
    status = 1;
end

% remove the test sub-dir
rmdir(SL.Data_Dir);

end