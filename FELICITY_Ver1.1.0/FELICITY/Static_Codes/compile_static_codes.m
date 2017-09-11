function status = compile_static_codes()
%compile_static_codes
%
%    MEX compile all of the static C++ files.

% Copyright (c) 09-06-2011,  Shawn W. Walker

Make_Files(1).FH = @compile_lepp_2D;
Make_Files(2).FH = @compile_eikonal2D_solver;
Make_Files(3).FH = @compile_mex_2D_mesh_tiger_code;
Make_Files(4).FH = @compile_mex_3D_mesh_tiger_code;
Make_Files(5).FH = @compile_mesh_smooth;
Make_Files(6).FH = @compile_bitree_code;
Make_Files(7).FH = @compile_quadtree_code;
Make_Files(8).FH = @compile_octree_code;

for ind = 1:length(Make_Files)
    status = Make_Files(ind).FH();
    if (status~=0)
        disp('Compile failed!');
        disp(['See ----> ', func2str(Make_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Static C++ codes successfully compiled...');
end

end