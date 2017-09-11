function FUNC = Get_All_Components(obj)
%Get_All_Components
%
%   This returns a cell array of strings representing all of the function
%   components (both vector and tensor).
%
%   FUNC = obj.Get_All_Components;

% Copyright (c) 08-01-2011,  Shawn W. Walker

Num_Vec    = obj.Num_Vec;

if (Num_Vec==1)
    if (length(obj.Element.Tensor_Comp)==1)
        FUNC = cell(obj.Element.Tensor_Comp(1),1);
        for t_ind = 1:obj.Element.Tensor_Comp(1)
            F_str = [obj.Name, '_v', num2str(1), '_t', num2str(t_ind)];
            FUNC{t_ind,1} = F_str;
        end
    else
        FUNC = cell(obj.Element.Tensor_Comp);
        for t1_ind = 1:obj.Element.Tensor_Comp(1)
            for t2_ind = 1:obj.Element.Tensor_Comp(2)
                F_str = [obj.Name, '_v', num2str(1), '_t', num2str(t1_ind), num2str(t2_ind)];
                FUNC{t1_ind,t2_ind} = F_str;
            end
        end
    end
else
    if (length(obj.Element.Tensor_Comp)==1)
        FUNC = cell(Num_Vec,obj.Element.Tensor_Comp(1));
        for v_ind = 1:Num_Vec
            for t_ind = 1:obj.Element.Tensor_Comp(1)
                F_str = [obj.Name, '_v', num2str(v_ind), '_t', num2str(t_ind)];
                FUNC{v_ind,t_ind} = F_str;
            end
        end
    else
        FUNC = cell([Num_Vec, obj.Element.Tensor_Comp]);
        for v_ind = 1:Num_Vec
            for t1_ind = 1:obj.Element.Tensor_Comp(1)
                for t2_ind = 1:obj.Element.Tensor_Comp(2)
                    F_str = [obj.Name, '_v', num2str(v_ind), '_t', num2str(t1_ind), num2str(t2_ind)];
                    FUNC{v_ind,t1_ind,t2_ind} = F_str;
                end
            end
        end
    end
end

end