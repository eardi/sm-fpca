function status = test_Quad_Rules()
%test_Quad_Rules
%
%    This tests the quadrature rules to make sure they deliver the correct
%    degree of precision!

% Copyright (c) 09-28-2015,  Shawn W. Walker

status = 0; % everything ok so far!

% check 1-D quad rules
NQ_Vec = (1:10)';
Degree_Precision = 2 * NQ_Vec - 1;
for ii = 1:length(NQ_Vec)
    nq = NQ_Vec(ii);
    [pt, wt] = Quad_On_Interval(nq);
    dp = Degree_Precision(ii);
    % create a polynomial of that degree
    syms x;
    % loop through all possible terms
    for p_x = 0:dp
        
        f = x^p_x;
        % integrate exactly
        exact = int(f,0,1);
        % compute integral with quad rule
        g = matlabFunction(f,'vars',[x]);
        numerical = sum(g(pt).*wt);
        
        % compute the error
        err = abs(exact - numerical);
        if err > 1e-16;
            disp('1-D quadrature rule does not satisfy expected degree of precision!');
            dp
            err
            status = 1;
            break;
        end
        
    end
end
clear x;

% check 2-D quad rules
NQ_Vec = [1,3,4,6,7,9,12,13,19,28,37]';
Degree_Precision = [1, 2, 3, 4, 5, 5, 6, 7, 9, 11, 13]';
for ii = 1:length(NQ_Vec)
    nq = NQ_Vec(ii);
    [pt, wt] = Quad_On_Triangle(nq);
    dp = Degree_Precision(ii);
    % create a polynomial of that degree
    syms x;
    syms y;
    % loop through all possible terms
    for p_x = 0:dp
    for q_y = 0:dp
        
        f = x^p_x * y^q_y;
        if ((p_x + q_y) <= dp)
            
            % integrate exactly
            n1 = vpa(factorial(p_x),60);
            n2 = vpa(factorial(q_y),60);
            d1 = vpa(factorial(p_x + q_y + 2),60);
            exact = double(n1*n2/d1);
            %exact = factorial(p_x)*factorial(q_y)/factorial(p_x + q_y + 2);
            % compute integral with quad rule
            g = matlabFunction(f,'vars',[x y]);
            numerical = sum(g(pt(:,1),pt(:,2)).*wt);
            
            % compute the error
            err = abs(exact - numerical);
            if err > 1e-15;
                disp('2-D quadrature rule does not satisfy expected degree of precision!');
                dp
                err
                status = 1;
                break;
            end
        end
        
    end
    end
end
clear x y;

% check 3-D quad rules
NQ_Vec = [1,4,5,10,11,14,15,24,31,45]';
Degree_Precision = [1, 1, 2, 3, 4, 4, 5, 6, 7, 8]';
for ii = 1:length(NQ_Vec)
    nq = NQ_Vec(ii);
    [pt, wt] = Quad_On_Tetra(nq);
    dp = Degree_Precision(ii);
    % create a polynomial of that degree
    syms x;
    syms y;
    syms z;
    % loop through all possible terms
    for p_x = 0:dp
    for q_y = 0:dp
    for r_z = 0:dp
        
        f = x^p_x * y^q_y * z^r_z;
        if ((p_x + q_y + r_z) <= dp)
            
            % integrate exactly
            %exact = 3*(factorial(dp)/factorial(dp+3));
            exact = factorial(p_x)*factorial(q_y)*factorial(r_z)/factorial(p_x + q_y + r_z + 3);
            % compute integral with quad rule
            g = matlabFunction(f,'vars',[x y z]);
            numerical = sum(g(pt(:,1),pt(:,2),pt(:,3)).*wt);
            
            % compute the error
            err = abs(exact - numerical);
            if err > 2e-16;
                disp('3-D quadrature rule does not satisfy expected degree of precision!');
                dp
                err
                status = 1;
                break;
            end
        end
        
    end
    end
    end
end
clear x y z;

if status == 0
    disp('All quadrature rules are valid!');
end

end