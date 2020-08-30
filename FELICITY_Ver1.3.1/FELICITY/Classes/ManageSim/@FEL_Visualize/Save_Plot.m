function Full_FN = Save_Plot(obj, FileName, FigHandle, Cmd)
%Save_Plot
%
%   Save a figure to a file.
%
%   Full_FN   = obj.Save_Plot(FileName, FigHandle, Cmd);
%
%   FileName  = local filename to use when saving the figure.
%   FigHandle = handle to figure window.
%   Cmd       = any of the commands available to the MATLAB "print" command.
%               if empty, then default = '-depsc' (save as color eps file)
%
%   Full_FN   = the full filename that the figure was saved to.
%
%   Alternative Calling Format:
%
%   Full_FN   = obj.Save_Plot(FileName);
%
%   In this case, only the full filename is generated.  Nothing is saved.

% Copyright (c) 05-05-2014,  Shawn W. Walker

% file stuff
Full_FN = fullfile(obj.Main_Dir,FileName);

if nargin <= 2
    return;
end

isFigureHandle = ishandle(FigHandle) && strcmp(get(FigHandle,'type'),'figure');
if ~isFigureHandle
    error('The given handle is not a *figure* handle.');
end

if isempty(Cmd)
    Cmd = '-depsc'; % default to color eps plot
    % note: '-deps' is black and white eps
end

%export_fig(FN, '-pdf', '-eps', '-transparent');
%export_fig(FN, '-pdf', '-transparent');
%print(FigHandle,'-deps',FN); % black and white
print(FigHandle, Cmd, Full_FN); % color

end