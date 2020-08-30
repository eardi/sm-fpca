function status = test_FEL_Bending_Plate_2D(recompile)
%test_FEL_Bending_Plate_2D
%
%   Test code for FELICITY class.

% Copyright (c) 03-30-2018,  Shawn W. Walker

Path_To_Mex = fileparts(mfilename('fullpath'));

% set degrees
deg_geo = 2; % >= 1
deg_k   = 1; % >= 0

%Domain_type = 'square';
%Domain_type = 'pacman';
Domain_type = 'disk';
%Mesh_type = 'square';
%Mesh_type = 'pacman';
Mesh_type = 'refined_disk';
%Mesh_type = 'refined_disk_alt';
%Mesh_type = 'disk_n_gon';
%Mesh_type = 'circle_alt';

%BC_type = 'clamped';
%BC_type = 'simply_supported';
BC_type = 'free';
%BC_type = 'alternate';

% get singularity function
PD = pwd;
cd('C:\FILES\FELICITY\Demo\CiarletRaviart');
Sing_Func = @Biharmonic_Singularity;
cd(PD);

% define atan2 better
my_atan2 = @(Y,X) 2 * atan( Y ./ ( sqrt(X.^2 + Y.^2 + 1e-15) + X ) );

syms x y real;

% set exact solution
if strcmpi(Domain_type,'square')
    
    omega = 1;
    
    if strcmpi(BC_type,'clamped')
        exact_u = sin(pi*x).^2 .* sin(pi*y).^2;
    elseif strcmpi(BC_type,'simply_supported')
        %exact_u = 1e3*(x.*(1-x) .* y.*(1-y)).^3 .* sin(3*x + 2*y);
        exact_u = sin(pi*x) .* sin(pi*y);
        %(sin(pi*x)^2 * sin(pi*y)^2)^2;
    else
        error('Invalid!');
    end
    
    % compute formulas
    exact_u_grad = [diff(exact_u,'x'); diff(exact_u,'y')];
    exact_u_hess = [diff(exact_u,'x','x'), diff(exact_u,'x','y');
                    diff(exact_u,'y','x'), diff(exact_u,'y','y')];
    exact_u_hess = simplify(exact_u_hess);
    exact_u_lap = trace(exact_u_hess);
    exact_u_lap_lap = diff(exact_u_lap,'x','x') + diff(exact_u_lap,'y','y');
    exact_f = exact_u_lap_lap;
    exact_b = 0*exact_u_lap_lap;

elseif strcmpi(Domain_type,'pacman')
    
    % singular exact solution
    syms r theta real;
    pi_sym = sym(pi);
    omega  = 3*pi_sym/2;
    % lambda = 0.54448373678;
    % omega = 4;
    % lambda = 0.6556046408;
    TOL = 1e-14;
    [lambda, e_vec, psi] = Sing_Func(BC_type,omega,TOL);
    omega = double(omega);
    lambda
    lambda = double(lambda);
    e_vec
    e_vec = double(e_vec);
    
    % form angular part of exact solution
    exact_psi = sym(0);
    for kk=1:length(e_vec)
        exact_psi = exact_psi + e_vec(kk) * psi(kk).func(lambda,theta);
    end
    exact_psi
    
    % form exact solution
    if strcmpi(BC_type,'clamped')
        exact_rho = r.^(lambda+1) + (lambda - 5)*r.^5 - (lambda - 4)*r.^6;
    elseif strcmpi(BC_type,'simply_supported')
        a0 = 8;
        b0 = 6;
        alpha = (b0*(b0-1) - (lambda+1)*lambda) / (a0*(a0-1) - b0*(b0-1));
        beta = -(alpha+1);
        exact_rho = r.^(lambda+1) + alpha*(r.^a0) + beta*(r.^b0);
%         cubic_p = 2*r.^3 - 3 * r.^2 + 1;
%         chi = cubic_p.^2;
%         exact_rho = chi .* r.^(lambda+1);
    else
        error('Invalid!');
    end
    %exact_2 = cos((lambda-1)*omega/2) * cos((lambda+1)*theta) - cos((lambda+1)*omega/2) * cos((lambda-1)*theta);
    exact_rho
    
    exact_u_polar = simplify( exact_rho * exact_psi );
    exact_u_polar
    r_cart = sqrt(x^2 + y^2);
    theta_cart = my_atan2(y,x);
    exact_u = subs(exact_u_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u
    
    % compute formulas
    eps0 = 0;
    exact_u_grad_r     = simplify( diff(exact_u_polar,'r') );
    exact_u_grad_theta = simplify( (1/(r + eps0)) * diff(exact_u_polar,'theta') );
    exact_u_grad_r_cart = subs(exact_u_grad_r,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_grad_theta_cart = subs(exact_u_grad_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    e_r = [x;y] / (r_cart + eps0);
    e_theta = [-y;x] / (r_cart + eps0);
    exact_u_grad = [exact_u_grad_r_cart * e_r(1) + exact_u_grad_theta_cart * e_theta(1);
        exact_u_grad_r_cart * e_r(2) + exact_u_grad_theta_cart * e_theta(2)];
    %
    
    % compute the hessian
    exact_u_hess_rr          = simplify( diff(exact_u_polar,'r','r') );
    exact_u_hess_rr_cart     = subs(exact_u_hess_rr,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess_theta_theta = simplify( (1/(r + eps0)^2) * (diff(exact_u_polar,'theta','theta') + r * exact_u_grad_r) );
    exact_u_hess_theta_theta_cart = subs(exact_u_hess_theta_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess_r_theta     = (1/(r + eps0)) * (diff(exact_u_polar,'r','theta') - exact_u_grad_theta);
    exact_u_hess_r_theta_cart = subs(exact_u_hess_r_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess = exact_u_hess_rr_cart          * (e_r * (e_r')) + ...
        exact_u_hess_theta_theta_cart * (e_theta * (e_theta')) + ...
        exact_u_hess_r_theta_cart     * (e_theta * (e_r') + e_r * (e_theta'));
    %
    exact_u_hess
    
    exact_u_lap_polar = simplify( (r^-1) * diff((r * diff(exact_u_polar,'r')),'r') + (r^-2) * diff(exact_u_polar,'theta','theta') );
    exact_u_lap_polar
    
    exact_u_lap = subs(exact_u_lap_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_lap_lap_polar = simplify( (1/(r + eps0)) * diff((r * diff(exact_u_lap_polar,'r')),'r') ...
                                    + (1/(r + eps0)^2) * diff(exact_u_lap_polar,'theta','theta') );
    exact_u_lap_lap = subs(exact_u_lap_lap_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_f = exact_u_lap_lap;
    exact_u_lap_lap_polar
    exact_b = 0*exact_u_lap_lap;
    
    % check boundary conditions
    disp('eval \psi at \theta = +/- \omega/2:');
    double(subs(exact_psi,'theta',omega/2))
    double(subs(exact_psi,'theta',-omega/2))
    disp('eval \rho at r = 1:');
    subs(exact_rho,'r',1)
    
    disp('eval \psi'' at \theta = +/- \omega/2:');
    double(subs(diff(exact_psi,'theta'),'theta',omega/2))
    double(subs(diff(exact_psi,'theta'),'theta',-omega/2))
    disp('eval \rho'' at r = 1:');
    subs(diff(exact_rho,'r'),'r',1)
    
    disp('eval \Delta u at \theta = +/- \omega/2:');
    simplify( subs(exact_u_lap_polar,'theta',omega/2) )
    simplify( subs(exact_u_lap_polar,'theta',-omega/2) )
    disp('eval \Delta u at r = 1:');
    simplify( subs(exact_u_lap_polar,'r',1) )
    
elseif strcmpi(Domain_type,'disk')
    
    omega = 1;
    
    % exact solution
    syms r theta real;
    
    % angular part of exact solution is 1
    exact_psi = sym(1);
    
    poisson = 0; % \nu (less than 1 in abs value!)
    % NOTE: if you want to use a different value of \nu, then the rest of
    % the code has to change!  need to compute the inverse elasticity tensor
    a0 = 10/64; % this sets the amplitude
    b0 = []; % set below
    c0 = []; % set below
    
    % form exact solution
    if strcmpi(BC_type,'clamped')
        % a0 + b0 + c0 = 0
        % 4 * a0 + 2 * b0 = 0
        b0 = -2 * a0;
        c0 = -(a0 + b0);
        %exact_rho = a0 * r.^4 + b0 * r.^2 + c0;
        
        exact_rho = (sin(pi*r))^2;
        %exact_rho = cos((pi/2)*r) + (pi/4)*r.^2 - (pi/4); % NOT checked
    elseif strcmpi(BC_type,'simply_supported')
        % a0 + b0 + c0 = 0
        % (12 + 4 \nu) * a0 + (2 + 2 \nu) * b0 = 0
        b0 = - ( (12 + 4 * poisson) / (2 + 2 * poisson) ) * a0;
        c0 = -(a0 + b0);
        exact_rho = a0 * r.^4 + b0 * r.^2 + c0;
        
        %exact_rho = cos((pi/2)*r); % BAD!
        %exact_rho = cos(3*(pi/2)*r);
    elseif strcmpi(BC_type,'free')
        %exact_rho = sin(3*(pi/2)*r) - ( (3*pi/2)^2 ) * (1/2) * r.^2;
        %exact_rho = ( (3*pi/2)^-2 ) * (cos(3*(pi/2)*r) + ( (3*pi/2)^3 )*(1/6)*(r - 1).^3);
        exact_rho = cos(3*(pi/2)*r);
    elseif strcmpi(BC_type,'alternate')
        exact_rho = sin(3*(pi/2)*r);
    else
        error('Invalid!');
    end
    %exact_2 = cos((lambda-1)*omega/2) * cos((lambda+1)*theta) - cos((lambda+1)*omega/2) * cos((lambda-1)*theta);
    exact_rho
    
    exact_u_polar = simplify( exact_rho * exact_psi );
    exact_u_polar
    r_cart = sqrt(x^2 + y^2);
    theta_cart = my_atan2(y,x);
    exact_u = subs(exact_u_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u
    
    % compute formulas
    eps0 = 0;
    exact_u_grad_r     = simplify( diff(exact_u_polar,'r') );
    exact_u_grad_theta = simplify( (1/(r + eps0)) * diff(exact_u_polar,'theta') );
    exact_u_grad_r_cart = subs(exact_u_grad_r,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_grad_theta_cart = subs(exact_u_grad_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    e_r = [x;y] / (r_cart + eps0);
    e_theta = [-y;x] / (r_cart + eps0);
    exact_u_grad = [exact_u_grad_r_cart * e_r(1) + exact_u_grad_theta_cart * e_theta(1);
        exact_u_grad_r_cart * e_r(2) + exact_u_grad_theta_cart * e_theta(2)];
    %
    
    % compute the hessian
    exact_u_hess_rr          = simplify( diff(exact_u_polar,'r','r') );
    exact_u_hess_rr_cart     = subs(exact_u_hess_rr,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess_theta_theta = simplify( (1/(r + eps0)^2) * (diff(exact_u_polar,'theta','theta') + r * exact_u_grad_r) );
    exact_u_hess_theta_theta_cart = subs(exact_u_hess_theta_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess_r_theta     = (1/(r + eps0)) * (diff(exact_u_polar,'r','theta') - exact_u_grad_theta);
    exact_u_hess_r_theta_cart = subs(exact_u_hess_r_theta,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_hess = exact_u_hess_rr_cart          * (e_r * (e_r')) + ...
        exact_u_hess_theta_theta_cart * (e_theta * (e_theta')) + ...
        exact_u_hess_r_theta_cart     * (e_theta * (e_r') + e_r * (e_theta'));
    exact_u_hess = simplify(exact_u_hess);
    %
    exact_u_hess_rr
    exact_u_hess_theta_theta
    exact_u_hess_r_theta
    disp('Hessian (1,1)');
    exact_u_hess(1,1)
    disp('Hessian (1,2)');
    exact_u_hess(1,2)
    disp('Hessian (2,2)');
    exact_u_hess(2,2)
    
    % compute the normal-tangential part of the hessian
    exact_u_hess_normal_tangent = exact_u_hess_r_theta;
    exact_u_hess_normal_tangent_ds = simplify( (1/(r + eps0)) * diff(exact_u_hess_normal_tangent,'theta') );
        
    exact_u_d2dx2_ERR = simplify(diff(exact_u,'x','x') - exact_u_hess(1,1));
    exact_u_d2dx2_ERR
    exact_u_dxdy_ERR = simplify(diff(exact_u,'x','y') - exact_u_hess(1,2));
    exact_u_dxdy_ERR
    exact_u_d2dy2_ERR = simplify(diff(exact_u,'y','y') - exact_u_hess(2,2));
    exact_u_d2dy2_ERR
    
    exact_u_lap_polar = simplify( (1/(r + eps0)) * diff((r * diff(exact_u_polar,'r')),'r') ...
                                + (1/(r + eps0)^2) * diff(exact_u_polar,'theta','theta') );
    exact_u_lap_polar
    
    % compute the radial derivative of the laplacian
    exact_u_lap_polar_dr = simplify( diff(exact_u_lap_polar,'r') );
    
    % weird 3rd order BC
    BC_third_order = - simplify(exact_u_lap_polar_dr + exact_u_hess_normal_tangent_ds);
    
    exact_u_lap = subs(exact_u_lap_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_u_lap_lap_polar = simplify( (1/(r + eps0)) * diff((r * diff(exact_u_lap_polar,'r')),'r') ...
                                    + (1/(r + eps0)^2) * diff(exact_u_lap_polar,'theta','theta') );
    exact_u_lap_lap_polar = simplify(exact_u_lap_lap_polar);
    exact_u_lap_lap = subs(exact_u_lap_lap_polar,{r, theta},{r_cart, theta_cart}); % cartesian
    exact_f = exact_u_lap_lap;
    exact_u_lap_lap_polar
    exact_b = subs(BC_third_order,{r, theta},{r_cart, theta_cart}); % cartesian
    
    % check boundary conditions
    disp('eval \rho at r = 1:');
    subs(exact_rho,'r',1)
    
    disp('eval \rho'' at r = 1:');
    subs(diff(exact_rho,'r'),'r',1)
    
    disp('eval \rho'''' at r = 1:');
    subs(diff(exact_rho,'r','r'),'r',1)
    
    disp('eval \Delta u at r = 1:');
    simplify( subs(exact_u_lap_polar,'r',1) )
    
    disp('eval \Delta^2 u at r = 1:');
    simplify( subs(exact_u_lap_lap_polar,'r',1) )
else
    error('Invalid!');
end

if (nargin==0)
    recompile = true;
end

if (recompile)
    
    % remove the mex file
    ME = mexext;
    DEL_Path_To_Mex = fullfile(Path_To_Mex, ['*.', ME]);
    delete(DEL_Path_To_Mex);
    
    m_handle = @MatAssem_Bending_Plate_2D;
    MEX_File = 'UNIT_TEST_mex_Assemble_Bending_Plate_2D';
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_geo,deg_k,exact_u,exact_u_grad,exact_u_hess,exact_f,exact_b},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    m_handle = @MatAssem_HHJ_Interp_2D;
    MEX_File = 'UNIT_TEST_mex_Assemble_HHJ_Interp_2D';
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_geo,deg_k,exact_u_hess},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile DoF allocators
    Main_Dir = fileparts(mfilename('fullpath'));
    
    MEX_File_DoF = 'UNIT_TEST_mex_Bending_Plate_2D_G_Space_DoF_Allocator';
    P_k_geo = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_geo,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_Bending_Plate_2D_W_Space_DoF_Allocator';
    P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_plus_1,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_Bending_Plate_2D_V_Space_DoF_Allocator';
    HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(HHJ_k,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile interpolation for HHJ
    Interp_Handle = @FEL_Interp_Bending_Plate_2D;
    MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_Bending_Plate_2D';
    [status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{deg_geo,deg_k},MEX_File_Interp);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile point search routine
    Search_Handle = @FEL_Pt_Search_Bending_Plate_2D;
    MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_Bending_Plate_2D';
    [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{deg_geo},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
end

status = FEL_Execute_Bending_Plate_2D(deg_geo,deg_k,omega,exact_u,exact_u_hess,Mesh_type,BC_type);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end