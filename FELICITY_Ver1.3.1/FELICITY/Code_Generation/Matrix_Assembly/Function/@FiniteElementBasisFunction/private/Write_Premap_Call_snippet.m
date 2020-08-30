function status = Write_Premap_Call_snippet(obj,fid,Premap_CODE)
%Write_Premap_Call_snippet
%
%   This writes C++ code to call the "pre-map" routine for H(div), H(curl),
%   etc...
%
%   All this does is determines the correct set of basis functions to use,
%   by either flipping signs, or choosing different sets of reference
%   functions.

% Copyright (c) 10-27-2016,  Shawn W. Walker

status = 0; % init
ENDL = '\n';
TAB = '    ';

DO_NOTHING = or(isa(obj.FuncTrans,'Hdivdiv_Trans'),or(isa(obj.FuncTrans,'H1_Trans'),isa(obj.FuncTrans,'Constant_Trans')));
if DO_NOTHING
    % do nothing!
elseif isa(obj.FuncTrans,'Hdiv_Trans')
    
    fprintf(fid, ['', ENDL]);
    fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
    fprintf(fid, [TAB, '/* call sub-routine to determine sign flips for H(div) basis functions */', ENDL]);
    fprintf(fid, [TAB, Premap_CODE.Init_Snippet, ENDL]);
    
    % get the variable that access the mesh orientation
    Mesh_Orient_str = ['Mesh', '->', 'Orientation'];
    fprintf(fid, [TAB, Premap_CODE.CPP_Name, '(', Mesh_Orient_str, ', ',...
                       Premap_CODE.Basis_Sign_CPP, ');', ENDL]);
    fprintf(fid, [obj.END_Auto_Gen, ENDL]);
    
elseif isa(obj.FuncTrans,'Hcurl_Trans')
    
    TD = obj.FuncTrans.GeoMap.TopDim;
    GD = obj.FuncTrans.GeoMap.GeoDim;
    if (TD~=GD)
        error('Not implemented!');
    end
    
    if (TD==2)
        
        fprintf(fid, ['', ENDL]);
        fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
        fprintf(fid, [TAB, '/* call sub-routine to determine sign flips for 2-D H(curl) basis functions */', ENDL]);
        fprintf(fid, [TAB, Premap_CODE.Init_Snippet, ENDL]);
        
        % get the vertex indices of the current mesh element
        fprintf(fid, [TAB, '// retrieve global vertex indices on the current cell', ENDL]);
        fprintf(fid, [TAB, 'int Vtx_Ind[SUB_TD+1];', ENDL]);
        fprintf(fid, [TAB, 'Mesh->Get_Current_Cell_Vertex_Indices(Vtx_Ind);', ENDL]);
        fprintf(fid, [TAB, Premap_CODE.CPP_Name, '(Vtx_Ind, ',...
                           Premap_CODE.Basis_Sign_CPP, ');', ENDL]);
        fprintf(fid, [obj.END_Auto_Gen, ENDL]);
        
    elseif (TD==3)

        fprintf(fid, ['', ENDL]);
        fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
        fprintf(fid, [TAB, '/* call sub-routine to determine current mesh element ordering */', ENDL]);
        fprintf(fid, [TAB, '/*      (This is related to the Paul Wesson trick!)  */', ENDL]);
        fprintf(fid, [TAB, 'bool ', Premap_CODE.Std_Elem_Order_CPP_Name, ';', ENDL]);
        
        % get the vertex indices of the current mesh element
        fprintf(fid, [TAB, '// retrieve global vertex indices on the current cell', ENDL]);
        fprintf(fid, [TAB, 'int Vtx_Ind[SUB_TD+1];', ENDL]);
        fprintf(fid, [TAB, 'Mesh->Get_Current_Cell_Vertex_Indices(Vtx_Ind);', ENDL]);
        fprintf(fid, [TAB, Premap_CODE.CPP_Name, '(Vtx_Ind, ',...
                           Premap_CODE.Std_Elem_Order_CPP_Name, ');', ENDL]);
        fprintf(fid, [obj.END_Auto_Gen, ENDL]);
        
    else
        error('Invalid!');
    end
else
    error('Not implemented!');
end

end