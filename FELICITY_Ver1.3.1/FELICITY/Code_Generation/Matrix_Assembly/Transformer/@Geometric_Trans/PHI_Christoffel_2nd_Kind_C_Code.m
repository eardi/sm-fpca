function CODE = PHI_Christoffel_2nd_Kind_C_Code(obj)
%PHI_Christoffel_2nd_Kind_C_Code
%
%   Generate C-code for direct evaluation of
%                   PHI.Christoffel_2nd_Kind = \Gamma^k_{i,j}
%   PHI_Christoffel_2nd_Kind_k_ij(qp) = (1/2) ( [PHI_Metric]^{-1} )_{kr} * 
%                    {  \partial_i [PHI_Metric]_{rj}
%                     + \partial_j [PHI_Metric]_{ir}
%                     - \partial_r [PHI_Metric]_{ij} },
%
%   where we sum over r = 1, ..., TopDim, and 1 <= k, i, j <= TopDim,
%         and qp are the coordinates of a quadrature point.
%   Note:  PHI.Metric must be a square matrix.

% Copyright (c) 04-03-2018,  Shawn W. Walker

if ~isempty(obj.PHI.Christoffel_2nd_Kind) % if this concept exists!
    
    if (obj.TopDim~=2)
        error('Christoffel 2nd-Kind only needed for 2-D surfaces in 3-D!');
    end
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Christoffel_2nd_Kind');
    
    % make a reference for the data evaluated at a quad point
    CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    % evaluate at the given matrix entry index
    PHI_Christoffel_2nd_Kind_str = [CPP_REF_Var_str];
    
    % need the grad(metric) tensor
    Map_PHI_Grad_Metric_str = obj.Output_CPP_Var_Name('Grad_Metric');
    Map_PHI_Grad_Metric_Eval_str = [Map_PHI_Grad_Metric_str, '[qp_i]'];
    % need the inverse metric
    Map_PHI_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
    Map_PHI_Inv_Metric_Eval_str = [Map_PHI_Inv_Metric_str, '[qp_i]'];
    
    CONST_Metric = obj.Lin_PHI_TF;
    if ~CONST_Metric % metric is not constant
        
        TAB = '    ';
        EVAL_STR(11).line = []; % init
        EVAL_STR( 1).line = '// compute each component of \\Gamma^k_{i,j} individually';
        TD_str = num2str(obj.TopDim);
        EVAL_STR( 2).line = ['for (int kk = 0; (kk < ', TD_str, '); kk++)'];
        EVAL_STR( 3).line = ['for (int ii = 0; (ii < ', TD_str, '); ii++)'];
        EVAL_STR( 4).line = ['for (int jj = 0; (jj < ', TD_str, '); jj++)'];
        EVAL_STR( 5).line = [TAB, '{'];
        EVAL_STR( 6).line = [TAB, 'const double Deriv_Metric_Term_0 = ',...
                                  Map_PHI_Grad_Metric_Eval_str, '.m', '[ii]', '[0]', '[jj]', ' + ', ...
                                  Map_PHI_Grad_Metric_Eval_str, '.m', '[jj]', '[ii]', '[0]', ' - ', ...
                                  Map_PHI_Grad_Metric_Eval_str, '.m', '[0]', '[ii]', '[jj]', ';'];
        %
        EVAL_STR( 7).line = [TAB, 'const double Deriv_Metric_Term_1 = ',...
                                  Map_PHI_Grad_Metric_Eval_str, '.m', '[ii]',  '[1]', '[jj]', ' + ', ...
                                  Map_PHI_Grad_Metric_Eval_str, '.m', '[jj]', '[ii]',  '[1]', ' - ', ...
                                  Map_PHI_Grad_Metric_Eval_str, '.m',  '[1]', '[ii]', '[jj]', ';'];
        %
        EVAL_STR( 8).line = [TAB, PHI_Christoffel_2nd_Kind_str, '.m', '[kk]', '[ii]', '[jj]', ' = (1.0/2.0) *'];
        EVAL_STR( 9).line = [TAB, TAB, ' ( ', Map_PHI_Inv_Metric_Eval_str,  '.m', '[kk]', '[0]', ' * Deriv_Metric_Term_0'];
        EVAL_STR(10).line = [TAB, TAB, '+  ', Map_PHI_Inv_Metric_Eval_str,  '.m', '[kk]', '[1]', ' * Deriv_Metric_Term_1 );'];
        EVAL_STR(11).line = [TAB, '}'];
    else
        % map is linear, so metric is constant
        EVAL_STR(1).line = [PHI_Christoffel_2nd_Kind_str, '.Set_To_Zero(); // metric is constant, so Christoffel 2nd-Kind is zero'];
    end
    
    % define the data type
    TYPE_str = obj.Get_CPP_Tensor_Data_Type_Name(obj.TopDim,obj.TopDim,obj.TopDim);
    Defn_Hdr = '// Christoffel symbols of the 2nd kind \\Gamma^k_{i,j} (in local coordinates)';
    Loop_Hdr = '// compute Christoffel symbols of the 2nd kind \\Gamma^k_{i,j}';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end