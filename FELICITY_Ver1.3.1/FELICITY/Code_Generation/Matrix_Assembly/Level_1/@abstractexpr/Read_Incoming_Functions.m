function obj = Read_Incoming_Functions(obj,FUNC)
%Read_Incoming_Functions
%
%   This puts the symbolic functions (input) into the format of this object.  Note: this
%   does not deal with geometric functions.
%
%   obj = obj.Read_Incoming_Functions(FUNC);
%
%   FUNC = cell array of Level 1 Test, Trial, and Coef(s).

% Copyright (c) 01-23-2014,  Shawn W. Walker

% init
obj.TestF  = [];
obj.TrialF = [];
obj.CoefF  = [];

for ind = 1:length(FUNC)
    
    temp_func = FUNC{ind};
    
    if isa(temp_func,'Test')
        if isempty(obj.TestF)
            obj.TestF = temp_func;
        else
            error('Cannot have more than 1 Test function!');
        end
    elseif isa(temp_func,'Trial')
        if isempty(obj.TrialF)
            obj.TrialF = temp_func;
        else
            error('Cannot have more than 1 Trial function!');
        end
    elseif isa(temp_func,'Coef')
        if isempty(obj.CoefF)
            obj.CoefF = temp_func;
        else
            Current_Num_Coef = length(obj.CoefF);
            obj.CoefF(Current_Num_Coef+1,1) = temp_func; % you can have several Coef functions...
            % make it a column vector!
        end
    else
        error('Invalid!');
    end
    
end

end