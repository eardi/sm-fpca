function FUNC = Get_All_Components(obj)
%Get_All_Components
%
%   This returns a cell array of strings representing all of the function
%   components (both vector and tuple).
%
%   FUNC = obj.Get_All_Components;

% Copyright (c) 03-24-2018,  Shawn W. Walker

[NR, NC] = obj.Num_Vec;
[TC_1, TC_2] = obj.Num_Tensor;

if (NC==1)
    % vector case
    if (NR==1)
        % actually, a scalar
        FUNC = cell(TC_1,TC_2);
        if (TC_2==1)
            for t_ind = 1:TC_1
                F_str = [obj.Name, '_v', num2str(1), '_t', num2str(t_ind)];
                FUNC{t_ind} = F_str;
            end
        else
            for t1_ind = 1:TC_1
                for t2_ind = 1:TC_2
                    F_str = [obj.Name, '_v', num2str(1), '_t', num2str(t1_ind), num2str(t2_ind)];
                    FUNC{t1_ind,t2_ind} = F_str;
                end
            end
        end
    else
        % actually, a vector
        if (TC_2==1)
            FUNC = cell(NR,TC_1);
            for v_ind = 1:NR
                for t_ind = 1:TC_1
                    F_str = [obj.Name, '_v', num2str(v_ind), '_t', num2str(t_ind)];
                    FUNC{v_ind,t_ind} = F_str;
                end
            end
        else
            FUNC = cell([NR, TC_1, TC_2]);
            for v_ind = 1:NR
                for t1_ind = 1:TC_1
                    for t2_ind = 1:TC_2
                        F_str = [obj.Name, '_v', num2str(v_ind), '_t', num2str(t1_ind), num2str(t2_ind)];
                        FUNC{v_ind,t1_ind,t2_ind} = F_str;
                    end
                end
            end
        end
   end 
else
    % matrix case
    if (NR==1)
        % actually, a row vector
        if (TC_2==1)
            FUNC = cell([TC_1, NC]);
            for c_ind = 1:NC
                for t_ind = 1:TC_1
                    F_str = [obj.Name, '_v', num2str(1), num2str(c_ind), '_t', num2str(t_ind)];
                    FUNC{t_ind, c_ind} = F_str;
                end
            end
        else
            FUNC = cell([TC_1, NC, TC_2]);
            for c_ind = 1:NC
                for t1_ind = 1:TC_1
                    for t2_ind = 1:TC_2
                        F_str = [obj.Name, '_v', num2str(1), num2str(c_ind), '_t', num2str(t1_ind), num2str(t2_ind)];
                        FUNC{t1_ind, c_ind, t2_ind} = F_str;
                    end
                end
            end
        end
    else
        % actually, a matrix
        if (TC_2==1)
            FUNC = cell([NR, NC, TC_1]);
            for r_ind = 1:NR
                for c_ind = 1:NC
                    for t_ind = 1:TC_1
                        F_str = [obj.Name, '_v', num2str(r_ind), num2str(c_ind), '_t', num2str(t_ind)];
                        FUNC{r_ind, c_ind, t_ind} = F_str;
                    end
                end
            end
        else
            FUNC = cell([NR, NC, TC_1, TC_2]);
            for r_ind = 1:NR
                for c_ind = 1:NC
                    for t1_ind = 1:TC_1
                        for t2_ind = 1:TC_2
                            F_str = [obj.Name, '_v', num2str(r_ind), num2str(c_ind), '_t', num2str(t1_ind), num2str(t2_ind)];
                            FUNC{r_ind, c_ind, t1_ind, t2_ind} = F_str;
                        end
                    end
                end
            end
        end
    end
end

end