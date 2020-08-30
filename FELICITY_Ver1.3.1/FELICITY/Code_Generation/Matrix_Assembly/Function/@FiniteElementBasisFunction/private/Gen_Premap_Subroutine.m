function status = Gen_Premap_Subroutine(obj,fid,Premap_CODE)
%Gen_Premap_Subroutine
%
%   This creates a special pre-map code for pre-mapping H(div) and H(curl)
%   functions.

% Copyright (c) 10-29-2016,  Shawn W. Walker

status = 0;
if isempty(Premap_CODE)
    return;
end

ENDL = '\n';
%TAB = '    ';

if isa(obj.FuncTrans,'H1_Trans')
    % do nothing!
elseif isa(obj.FuncTrans,'Hdiv_Trans')
    
    % insert code snippet
    fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
    fprintf(fid, ['/***************************************************************************************/', ENDL]);
    fprintf(fid, ['/* get sign changes to apply to basis functions to account for changes in orientation', ENDL]);
    fprintf(fid, ['  (with respect to the "standard" reference orientation) on the current mesh element.  */', ENDL]);
    fprintf(fid, ['void SpecificFUNC::', Premap_CODE.CPP_Name, '(', Premap_CODE.Arg_List_Defn, ') const', ENDL]);
    fprintf(fid, ['{', ENDL]);
    fprintf(fid, ['', Premap_CODE.Main_Subroutine]);
    fprintf(fid, ['}', ENDL]);
    fprintf(fid, ['/***************************************************************************************/', ENDL]);
    status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);
    fprintf(fid, ['', ENDL]);
    
elseif isa(obj.FuncTrans,'Hcurl_Trans')
    
    TD = obj.FuncTrans.GeoMap.TopDim;
    GD = obj.FuncTrans.GeoMap.GeoDim;
    if (TD~=GD)
        error('Not implemented!');
    end
    
    if (TD==2)
        % insert code snippet
        fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
        fprintf(fid, ['/***************************************************************************************/', ENDL]);
        fprintf(fid, ['/* get sign changes to apply to basis functions to account for changes in orientation', ENDL]);
        fprintf(fid, ['  (with respect to the "standard" reference orientation) on the current mesh element.  */', ENDL]);
        fprintf(fid, ['void SpecificFUNC::', Premap_CODE.CPP_Name, '(', Premap_CODE.Arg_List_Defn, ') const', ENDL]);
        fprintf(fid, ['{', ENDL]);
        fprintf(fid, ['', Premap_CODE.Main_Subroutine]);
        fprintf(fid, ['}', ENDL]);
        fprintf(fid, ['/***************************************************************************************/', ENDL]);
        status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);
        fprintf(fid, ['', ENDL]);
    elseif (TD==3)
        % the type of pre-map is different in 3-D (than in 2-D)
        
        % insert code snippet
        fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
        fprintf(fid, ['/***************************************************************************************/', ENDL]);
        fprintf(fid, ['/* determine ordering of the current mesh element, so we can choose the correct', ENDL]);
        fprintf(fid, ['   reference element (and associated basis functions).', ENDL]);
        fprintf(fid, ['   Let [V_1, V_2, V_3, V_4] be the global vertex indices of the current mesh element.', ENDL]);
        fprintf(fid, ['        Only two orderings are allowed:', ENDL]);
        fprintf(fid, ['        V_1 < V_2 < V_3 < V_4, (ascending order);', ENDL]);
        fprintf(fid, ['        V_1 < V_3 < V_2 < V_4, (mirror reflection ascending order).', ENDL]);
        fprintf(fid, ['        Any other order outputs an error message.', ENDL]);
        fprintf(fid, ['', ENDL]);
        fprintf(fid, ['        This is done because we use the "Paul Wesson Trick" to choose the orientation', ENDL]);
        fprintf(fid, ['        of tetrahedral edges, as well as the tangent basis of each tetrahedral face.', ENDL]);
        fprintf(fid, ['        For more information, see pages 142-143 in', ENDL]);
        fprintf(fid, ['                "Finite Element Methods for Maxwell''s Equations", by Peter Monk.  */', ENDL]);
        fprintf(fid, ['void SpecificFUNC::', Premap_CODE.CPP_Name, '(', Premap_CODE.Arg_List_Defn, ') const', ENDL]);
        fprintf(fid, ['{', ENDL]);
        fprintf(fid, ['', Premap_CODE.Main_Subroutine]);
        fprintf(fid, ['}', ENDL]);
        fprintf(fid, ['/***************************************************************************************/', ENDL]);
        status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);
        fprintf(fid, ['', ENDL]);
    else
        error('Invalid!');
    end
    
else
    error('Not implemented!');
end

end