function status = Write_Basis_Function_Orientation_snippet(obj,fid,FuncTrans)
%Write_Basis_Function_Orientation_snippet
%
%   This writes several lines of code that determine the local orientation of
%   the basis functions.  Only useful for H(div), etc...

% Copyright (c) 09-12-2016,  Shawn W. Walker

status = 0; % init
ENDL = '\n';
TAB = '    ';

%class_str = class(FuncTrans);
if isa(FuncTrans,'Hdiv_Trans')
    Orient_CODE = FuncTrans.FUNC_Orientation_C_Code;
    VarName = Orient_CODE.Var_Name(1).line;
    
    fprintf(fid, [TAB, '// get local orientation of (vector) basis functions', ENDL]);
    TD = obj.Elem.Top_Dim;
    if (TD==2) % simplex is a triangle
        % must apply orientation to edges
        DoFs_on_Facets = obj.Elem.Get_Local_DoFs_On_Topological_Entity(TD-1);
        for ff = 1:(TD+1) % number of facets
            % eval string
            DoF_list = DoFs_on_Facets(ff,:);
            for dd = 1:length(DoF_list)
                % set the particular basis function
                bb = DoF_list(dd);
                Var_Basis_str = [VarName, '[', num2str(bb-1), ']', '[0]', '.a']; % only 1 ``quad point''
                % get mesh orientation variable name
                Mesh_Orient_str = ['Mesh', '->', 'Orientation[', num2str(ff-1), ']'];
                status = fprintf(fid, [TAB, Var_Basis_str, ' = ', Mesh_Orient_str, ';', ENDL]);
            end
            % SWW: need to set the "orientation" of basis functions *not*
            %      associated with a facet (i.e. the interior DoFs).  In
            %      this case, the orientation is always positive!
        end
    elseif (TD==3) % simplex is a tetrahedron
        error('Not implemented!');
    else
        error('Not implemented!');
    end
end

end