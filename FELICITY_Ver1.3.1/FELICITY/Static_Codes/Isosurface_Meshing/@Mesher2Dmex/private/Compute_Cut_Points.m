function cut_pts = Compute_Cut_Points(obj,Interp_Func,Edge_Tail_Point,Edge_Head_Point)
%Compute_Cut_Points
%
%    This computes a cut point for each cut edge.

% Copyright (c) 02-10-2018,  Shawn W. Walker

TOL = obj.Tolerance;

if obj.Use_Newton
    cut_pts = get_cut_point_newton(Interp_Func,Edge_Tail_Point,Edge_Head_Point,TOL);
else
    cut_pts = get_cut_point_bisection(Interp_Func,Edge_Tail_Point,Edge_Head_Point,TOL);
end

end

function pt = get_cut_point_bisection(Interp_Func,X0,X1,TOL)

t_win = [zeros(size(X0,1),1), ones(size(X0,1),1)]; % [a, b]
f_a = Interp_Func(X0); % f(a)
f_b = Interp_Func(X1); % f(b)
zero_mask_a = (f_a==0); % f(a)==0
zero_mask_b = (f_b==0); % f(b)==0
t_win(zero_mask_a,2) = t_win(zero_mask_a,1); % set b := a here
t_win(zero_mask_b,1) = t_win(zero_mask_b,2); % set a := b here

COUNT = 0;
while (max(t_win(:,2) - t_win(:,1)) > TOL) % tolerance is ``normalized''
    COUNT = COUNT + 1;
    if (COUNT > 50)
        error('Bisection is not converging!');
    end
    % compute mid point: c
    t = 0.5 * (t_win(:,1) + t_win(:,2)); % get the midpoint
    MID_PT(:,1) = X0(:,1).*(1-t) + X1(:,1).*t;
    MID_PT(:,2) = X0(:,2).*(1-t) + X1(:,2).*t;
    f_c = Interp_Func(MID_PT);
    % if we get lucky...
    zero_mask_c = (f_c==0); % f(c)==0
    % make window [c, c]
    t_win(zero_mask_c,1) = t(zero_mask_c);
    t_win(zero_mask_c,2) = t(zero_mask_c);
    
    % at this point, we don't need to consider cases where the sign is zero!
    
    % if sign(f(c)) = sign(f(a)) then a := c else b := c 
    DECISION = (sign(f_c) == sign(f_a));
    t_win(DECISION,1) = t(DECISION); % a := c
    t_win(~DECISION,2) = t(~DECISION); % b := c
    % update f(a)
    f_a(DECISION,1) = f_c(DECISION,1);
end

disp('Bisection Finished!');
pt = 0*X0;
t = 0.5 * (t_win(:,1) + t_win(:,2));
pt(:,1) = X0(:,1).*(1-t) + X1(:,1).*t;
pt(:,2) = X0(:,2).*(1-t) + X1(:,2).*t;

end

function pt = get_cut_point_newton(Interp_Func,X0,X1,TOL)

t = 0.5 * ones(size(X0,1),1);
f = ones(size(X0,1),1);
TEMP_PT = 0*X0;
COUNT = 0;
while (max(abs(f)) > TOL)
    COUNT = COUNT + 1;
    if (COUNT > 20)
        error('Newton Method is not converging!');
    end
    TOO_BIG = (t >= 1);
    TOO_SMALL = (t <= 0);
    t(TOO_BIG) = 1;
    t(TOO_SMALL) = 0;
    TEMP_PT(:,1) = X0(:,1).*(1-t) + X1(:,1).*t;
    TEMP_PT(:,2) = X0(:,2).*(1-t) + X1(:,2).*t;
    [f, grad_phi] = Interp_Func(TEMP_PT);
    f_deriv = dot(grad_phi,X1-X0,2);
    mf = min(abs(f_deriv));
    if (mf==0)
        error('Derivative is zero.  Not allowed!');
    end
    t = t - (f./f_deriv);
end

disp('Newton Method Finished!');
pt = 0*X0;
pt(:,1) = X0(:,1).*(1-t) + X1(:,1).*t;
pt(:,2) = X0(:,2).*(1-t) + X1(:,2).*t;

end