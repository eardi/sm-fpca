function status = test_FEL_Visualize_1()
%test_FEL_Visualize_1
%
%   Test code for FELICITY class.

% Copyright (c) 01-31-2017,  Shawn W. Walker

% SWW: this test needs to be run manually by a user b/c MATLAB is lame!

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% make a directory to store stuff in
Data_Dir = fullfile(Current_Dir,'Data_Dir_1');

% create the object
File_Prefix = 'SimData';
SL = FEL_SaveLoad(Data_Dir,File_Prefix);
clear Data_Dir File_Prefix;

% start saving some stuff
myData.matrix = rand(10,10);
myData.soln   = rand(10,1);
myData.string = 'Hey you!';

% save static data
Param.a0 = 0.1;
Param.b0 = 0.55;
SL.Save('static',Param);

% save at index 0
SL.Save('dynamic',myData,0);

% save at index 1
myData.matrix = rand(10,10);
myData.soln   = rand(10,1);
myData.string = 'I''m talking to you!';
SL.Save('dynamic',myData,1);

for ind = 2:10
    % save at other indices
    myData.matrix = rand(10,10);
    myData.soln   = rand(10,1);
    SL.Save('dynamic',myData,ind);
end

% make a directory to store stuff in
Plot_Dir = fullfile(Current_Dir,'Data_Vis_1');
VIZ = FEL_Visualize(Plot_Dir);
clear Plot_Dir;

FH = figure;
imagesc(myData.matrix);
Full_FN = VIZ.Save_Plot('First_Plot', FH, []);
close_success = close(FH);
status = ~close_success;

PF = @(SS,DS) my_movie_plot(SS,DS);
[Frames, Full_FN, FigHan] = VIZ.Make_Movie('First_Movie', SL, PF, [], [], []);
close(FigHan);

% create video object
vidObj = VideoWriter(Full_FN);
% write the video
open(vidObj);
writeVideo(vidObj,Frames);
close(vidObj);

% now delete all of the data
SL.Delete_Data;
% delete all of the plots/movies
VIZ.Delete_Plots;

% remove the Main_Dir's
SL  = SL.Remove_Main_Dir();
VIZ = VIZ.Remove_Main_Dir();

end

function my_movie_plot(SS,DS)

imagesc(DS.matrix);

end