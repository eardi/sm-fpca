function FUNC = Get_Tensor_Components(obj)
%Get_Tensor_Components
%
%   This returns a cell array of strings representing all of the function's
%   tensor components, i.e. we ignore any vector components.
%
%   FUNC = obj.Get_Tensor_Components;

% Copyright (c) 03-24-2018,  Shawn W. Walker

[TC_1, TC_2] = obj.Num_Tensor;

if (TC_2==1)
    % only 1 column
    FUNC = cell(TC_1,1);
    for t_ind = 1:TC_1
        F_str = [obj.Name, '_t', num2str(t_ind)];
        FUNC{t_ind,1} = F_str;
    end
else
    % actual matrix
    FUNC = cell([TC_1, TC_2]);
    for t1_ind = 1:TC_1
        for t2_ind = 1:TC_2
            F_str = [obj.Name, '_t', num2str(t1_ind), num2str(t2_ind)];
            FUNC{t1_ind,t2_ind} = F_str;
        end
    end
end

end