function CPP_Name = Output_CPP_Var_Name(obj,FIELD_str)
%Output_CPP_Var_Name
%
%   This outputs a string representing the C++ variable name.

% Copyright (c) 10-17-2016,  Shawn W. Walker

SYM_Var = obj.vv.(FIELD_str);

if strcmp(FIELD_str,'Orientation')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Val')
    Var_str = char(SYM_Var(1)); % only need first component!
    Var_str = Var_str(1:end-2); % subtract 2 because of vector component
elseif strcmp(FIELD_str,'Curl')
    TD = obj.GeoMap.TopDim;
    GD = obj.GeoMap.GeoDim;
    if (TD==2)
        if (GD==2)
            % curl is a scalar in 2-D
            Var_str = char(SYM_Var);
            Var_str = Var_str(1:end);
        else
            error('Not implemented!');
        end
    elseif (TD==3)
        % curl is a vector in 3-D
        Var_str = char(SYM_Var(1)); % only need first component!
        Var_str = Var_str(1:end-2); % subtract 2 because of vector component
    else
        error('Not implemented or not valid!');
    end
% elseif strcmp(FIELD_str,'Grad')
%     Var_str = char(SYM_Var(1??));
%     Var_str = Var_str(1:end-2);
% elseif strcmp(FIELD_str,'Hess')
%     Var_str = char(SYM_Var(1,1??));
%     Var_str = Var_str(1:end-3);
else
    error('Not valid!');
end

CPP_Name = Get_Func_CPP_Var_Name(Var_str);

end