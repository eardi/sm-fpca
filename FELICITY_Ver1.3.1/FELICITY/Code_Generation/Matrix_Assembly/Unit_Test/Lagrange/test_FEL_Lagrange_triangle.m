function status = test_FEL_Lagrange_triangle(recompile)
%test_FEL_Lagrange_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 04-05-2018,  Shawn W. Walker

Path_To_Mex = fileparts(mfilename('fullpath'));

% set parameters
DIM = 2; % 1,2,3
deg_k = 2; % >= 1
% NOTE: the AGMG solver does not like DIM=3, deg_k=5

% define exact soln
if (DIM==1)
    % domain is interval: [0,1]
    x = sym('x','real');
    exact_soln = sin(x) * (x * (1-x));
    vars = x;
elseif (DIM==2)
    % domain is square: [0,1]^2
    x = sym('x','real');
    y = sym('y','real');
    exact_soln = sin(x) * cos(y) * (x * (1-x)) * (y * (1-y));
    vars = [x;y];
elseif (DIM==3)
    % domain is cube: [0,1]^3
    x = sym('x','real');
    y = sym('y','real');
    z = sym('z','real');
    exact_soln = sin(x) * cos(y) * sin(z) * (x * (1-x)) * (y * (1-y)) * (z * (1-z));
    vars = [x;y;z];
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
    
    m_handle = @MatAssem_Lagrange_triangle;
    MEX_File = 'UNIT_TEST_mex_Assemble_FEL_Lagrange_triangle';
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{DIM,deg_k,exact_soln,vars},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile DoF allocators
    Main_Dir = fileparts(mfilename('fullpath'));
    
    MEX_File_DoF = 'UNIT_TEST_mex_Lagrange_triangle_DoF_Allocator';
    P_k = eval(['lagrange_deg', num2str(deg_k), '_dim', num2str(DIM), '();']);
    [status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k,MEX_File_DoF,Main_Dir);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile interpolation for Lagrange
    Interp_Handle = @FEL_Interp_Lagrange_triangle;
    MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_Lagrange_triangle';
    [status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{DIM,deg_k},MEX_File_Interp);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
    
    % compile point search routine
    Search_Handle = @FEL_Pt_Search_Lagrange_triangle;
    MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_Lagrange_triangle';
    [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{DIM},MEX_File);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end 
end

status = FEL_Execute_Lagrange_triangle(DIM,deg_k);

if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end