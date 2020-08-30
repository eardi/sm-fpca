function status = test_FEL_HHJk_Surface_triangle(recompile)
%test_FEL_HHJk_Surface_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 03-30-2018,  Shawn W. Walker

Path_To_Mex = fileparts(mfilename('fullpath'));

% set degrees
deg_geo = 1; % >= 1
deg_k   = 0; % >= 0

% define surface height function
%surf_func = @(x,y) sin(pi*x).*sin(pi*y);
%surf_func = @(x,y) 0*x;
%surf_func = @(x,y) x + y;
surf_func = @(x,y) x.^2 + 0*y.^2;
%surf_func = @(x,y) 10*(((x-0.5)).^3 - 0.2*x) + 1 - 2*((y-0.5)).^2;
%surf_func = @(x,y) x.^2 + y.^2;
u = sym('u','real'); % u = x
v = sym('v','real'); % v = y

% define solution in reference domain
%soln_tilde = (sin(pi*u) .* sin(pi*v)).^2;
%soln_tilde = (1/2)*(u^2 + 2*u*v + v^2);
%soln_tilde = (1/2)*(u^2 + 2*u*v + v^2)*(u*(1-u)*v*(1-v))^2;
soln_tilde = (u*(1-u)*v*(1-v))^2 * sin(u) * cos(v);
%soln_tilde = sin(6*u) + 0.01*v;

if (nargin==0)
    recompile = true;
end

if (recompile)
    
    % remove the mex file
    ME = mexext;
    DEL_Path_To_Mex = fullfile(Path_To_Mex, ['*.', ME]);
    delete(DEL_Path_To_Mex);
    
    m_handle = @MatAssem_HHJk_Surface_triangle;
    MEX_File = 'UNIT_TEST_mex_Assemble_FEL_HHJk_Surface_triangle';
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_geo,deg_k,surf_func,soln_tilde,[u,v]},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile DoF allocators
    Main_Dir = fileparts(mfilename('fullpath'));
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJ_Surface_G_Space_DoF_Allocator';
    P_k_geo = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_geo,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJ_Surface_Pk_Space_DoF_Allocator';
    P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_plus_1,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJk_Surface_Space_DoF_Allocator';
    HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(HHJ_k,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile interpolation for HHJ
    Interp_Handle = @FEL_Interp_HHJk_Surface_triangle;
    MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_HHJk_Surface_triangle';
    [status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{deg_geo,deg_k},MEX_File_Interp);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile point search routine
    Search_Handle = @FEL_Pt_Search_HHJk_Surface_triangle;
    MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_HHJk_Surface_triangle';
    [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{deg_geo},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end 
end

status = FEL_Execute_HHJk_Surface_triangle(deg_geo,deg_k,surf_func,soln_tilde);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end