function FUNC = Get_Tensor_Components(obj)
%Get_Tensor_Components
%
%   This returns a cell array of strings representing all of the function's
%   tensor components, i.e. we ignore any vector components.
%
%   FUNC = obj.Get_Tensor_Components;

% Copyright (c) 03-26-2012,  Shawn W. Walker

if (length(obj.Element.Tensor_Comp)==1)
    FUNC = cell(obj.Element.Tensor_Comp(1),1);
    for t_ind = 1:obj.Element.Tensor_Comp(1)
        F_str = [obj.Name, '_t', num2str(t_ind)];
        FUNC{t_ind,1} = F_str;
    end
else
    FUNC = cell(obj.Element.Tensor_Comp);
    for t1_ind = 1:obj.Element.Tensor_Comp(1)
        for t2_ind = 1:obj.Element.Tensor_Comp(2)
            F_str = [obj.Name, num2str(t1_ind), num2str(t2_ind)];
            FUNC{t1_ind,t2_ind} = F_str;
        end
    end
end

end