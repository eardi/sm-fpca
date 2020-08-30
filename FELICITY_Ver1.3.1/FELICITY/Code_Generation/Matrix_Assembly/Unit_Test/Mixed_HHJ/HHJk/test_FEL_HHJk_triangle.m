function status = test_FEL_HHJk_triangle(recompile)
%test_FEL_HHJk_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 03-28-2018,  Shawn W. Walker

Path_To_Mex = fileparts(mfilename('fullpath'));

% set degrees
deg_geo = 1; % >= 1
deg_k   = 0; % >= 0

% define solution in reference domain
x = sym('x','real');
y = sym('y','real');
exact_u = (x*(1-x)*y*(1-y))^2 * sin(x) * cos(y);

if (nargin==0)
    recompile = true;
end

if (recompile)
    
    % remove the mex file
    ME = mexext;
    DEL_Path_To_Mex = fullfile(Path_To_Mex, ['*.', ME]);
    delete(DEL_Path_To_Mex);
    
    m_handle = @MatAssem_HHJk_triangle;
    MEX_File = 'UNIT_TEST_mex_Assemble_FEL_HHJk_triangle';
    
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_geo,deg_k,exact_u,[x;y]},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile DoF allocators
    Main_Dir = fileparts(mfilename('fullpath'));
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJ_G_Space_DoF_Allocator';
    P_k_geo = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_geo,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJ_Pk_Space_DoF_Allocator';
    P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_plus_1,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    MEX_File_DoF = 'UNIT_TEST_mex_HHJk_Space_DoF_Allocator';
    HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(HHJ_k,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile interpolation for HHJ
    Interp_Handle = @FEL_Interp_HHJk_triangle;
    MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_HHJk_triangle';
    [status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{deg_geo,deg_k},MEX_File_Interp);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile point search routine
    Search_Handle = @FEL_Pt_Search_HHJk_triangle;
    MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_HHJk_triangle';
    [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{deg_geo},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
end

status = FEL_Execute_HHJk_triangle(deg_geo,deg_k,exact_u);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end