function [Frames, Full_FN, FigHandle] = Make_Movie(obj, FileName, SL, Plot_Func, Start_Index, End_Index, Step, FigHandle)
%Make_Movie
%
%   Make a movie.  Note: this does *not* save the movie.  You still need to
%   do that afterward, say, by using the MATLAB VideoWriter class.
%
%   [Frames, Full_FN, FigHandle] = obj.Make_Movie(FileName, SL, Plot_Func,
%                                  Start_Index, End_Index, Step, FigHandle);
%
%   FileName  = local filename to use when saving the figure.
%   SL        = a FEL_SaveLoad object for loading the simulation data to plot.
%   Plot_Func = function handle to a plot routine for plotting the simulation at a
%               particular "time" index.
%   Start_Index, End_Index = make movie of simulation from Start_Index to End_Index.
%               If Start_Index empty, then default = 0.
%               If End_Index   empty, then default = last index of simulation.
%   Step      = increment of simulation index (i.e. the difference between two movie
%               frame simulation indices = Step).  If empty, then default = 1;
%   FigHandle = handle to figure window to use for movie.  This is an
%               *optional*, i.e. it can be omitted or set to [].  If
%               omitted, then a default figure window is created.
%
%   Frames    = the movie frames to be saved.
%   Full_FN   = the full filename that the movie should be saved to.
%   FigHandle = handle to figure window.

% Copyright (c) 10-28-2015,  Shawn W. Walker

if isempty(Start_Index)
    Start_Index = 0;
end
if isempty(End_Index)
    End_Index = SL.Get_Max_Index;
end
if isempty(Step)
    Step = 1;
end
Step = round(Step);

if (Start_Index < 0)
    error('Invalid Start_Index!');
end
if (End_Index > SL.Get_Max_Index)
    error('Invalid End_Index!');
end
if (Step < 1)
    error('Invalid Step size!');
end

% create figure if necessary
if nargin == 8
    if isempty(FigHandle)
        % Create an animation
        FigHandle = figure('Renderer','zbuffer');
    else
        if ~ishandle(FigHandle)
            error('Given figure handle is not valid!');
        end
    end
end
if nargin <= 7
    % then no figure window given, so create one!
    % Create an animation
    FigHandle = figure('Renderer','zbuffer');
end

% load start iteration
SS = SL.Load('static');
DS = SL.Load('dynamic',Start_Index);
Plot_Func(SS,DS);

Frame_Indices = (Start_Index:Step:End_Index)';
Num_Frames = length(Frame_Indices);
Frames(Num_Frames) = getframe(gcf);

%set(gca,'nextplot','replacechildren');
for ii = 1:Num_Frames
    
    clf;
    % plot at the current simulation index
    sim_index = Frame_Indices(ii);
    DS = SL.Load('dynamic',sim_index);
    Plot_Func(SS,DS);
    
    % store each frame to the file
    Frames(ii) = getframe(gcf);
end

% output filename for saving movie
Full_FN = fullfile(obj.Main_Dir,FileName);

end