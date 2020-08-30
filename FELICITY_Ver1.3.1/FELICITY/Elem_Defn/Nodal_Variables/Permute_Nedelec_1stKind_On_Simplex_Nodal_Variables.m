function Permute_Nodal_Var = Permute_Nedelec_1stKind_On_Simplex_Nodal_Variables(Cell,DoF_Perm,Perm_Tet,...
                                     Sym_Perm_Map,Jacobian_Matrix,Nodal_Var)
%Permute_Nedelec_1stKind_On_Simplex_Nodal_Variables
%
%   This permutes the Nodal Variable Data.

% Copyright (c) 11-02-2016,  Shawn W. Walker

% % need it symbolically (this is my F_{\tilde{T}} map from \hat{T} --> \tilde{T}
%     Sym_Perm_Map = FELSymFunc(Sym_Func_Temp,std_vars);

Permute_Nodal_Var = Nodal_Var; % init
J_inv = inv(Jacobian_Matrix);
det_J = det(Jacobian_Matrix);

% DoF_Perm : \hat{T} --> \tilde{T}
Num_DoFs = length(DoF_Perm);

% map and permute nodal-var data
for hat_ind = 1:Num_DoFs
    tilde_ind = DoF_Perm(hat_ind);
    NV_tilde_Data = Nodal_Var(tilde_ind).Data;
    NV_hat_Data   = Nodal_Var(hat_ind).Data; % init!
    
    NV_Type = NV_tilde_Data{3};
    % error check
    if ~strcmpi(NV_hat_Data{3},NV_Type)
        error('Nodal types are different!');
    end
    
    % BEGIN: modify Nodal Variable data on \tilde{T} to be defined on \hat{T}
    
    % convert dual function string to useable format
    func_handle_str = ['@(x,y,z) ', NV_tilde_Data{2}];
    func_handle     = str2func(func_handle_str);
    sym_dual_func   = sym(func_handle);
    Dual_Func_tilde = FELSymFunc(sym_dual_func);
    % modify dual function
    Dual_Func_tilde  = Dual_Func_tilde.Rename_Independent_Vars({'x', 'y', 'z'},{'x_t', 'y_t', 'z_t'});
    Mapped_Dual_Func = Dual_Func_tilde.Compose_Function(Sym_Perm_Map);
    
    Entity_tilde = NV_tilde_Data{4};
    % Note: the barycentric coordinates are already correct; accounted for by DoF_Perm
    if strcmpi(NV_Type,'int_edge')
        % get corresponding entity on \hat{T}
        Entity_hat = inverse_entity_map(Perm_Tet.Edge,Entity_tilde);
        if (Entity_hat~=NV_hat_Data{4})
            error('Permutation data not correct!');
        end
        
        % get ratio of edge lengths
        edge_ratio = Cell.Edge(Entity_tilde).Measure / Cell.Edge(Entity_hat).Measure;
        % multiply by jacobian stuff
        Dual_Func_hat_sym = edge_ratio * J_inv * Mapped_Dual_Func.Func;
        % remake into a string
        NV_hat_Data{2} = make_sym_vec_func_str(Dual_Func_hat_sym);
        
    elseif strcmpi(NV_Type,'int_facet')
        % get corresponding entity on \hat{T}
        Entity_hat = inverse_entity_map(Perm_Tet.Face,Entity_tilde);
        if (Entity_hat~=NV_hat_Data{4})
            error('Permutation data not correct!');
        end
        
        % multiply by jacobian stuff
        Dual_Func_hat_sym = J_inv * Mapped_Dual_Func.Func;
        % remake into a string
        NV_hat_Data{2} = make_sym_vec_func_str(Dual_Func_hat_sym);
        
    elseif strcmpi(NV_Type,'int_cell')
        % get corresponding entity on \hat{T}
        Entity_hat = inverse_entity_map(Perm_Tet.Tet,Entity_tilde);
        if (Entity_hat~=NV_hat_Data{4})
            error('Permutation data not correct!');
        end
        
        % multiply by jacobian stuff
        Dual_Func_hat_sym = det_J * J_inv * Mapped_Dual_Func.Func;
        % remake into a string
        NV_hat_Data{2} = make_sym_vec_func_str(Dual_Func_hat_sym);
        
    else
        error('Invalid!');
    end
    
    % END: modify Nodal Variable data on \tilde{T} to be defined on \hat{T}
    
    Permute_Nodal_Var(hat_ind).Data = NV_hat_Data;
end

end

function Entity_inverse_index = inverse_entity_map(Perm_Entity,Entity_index)

[TF,LOC] = ismember(Entity_index,Perm_Entity);
Entity_inverse_index = LOC(TF);
if (Perm_Entity(Entity_inverse_index)~=Entity_index)
    error('Entity permutation not correct!');
end

end

function Func_Str = make_sym_vec_func_str(Sym_Func)

Num_Comp = length(Sym_Func);
if (Num_Comp==1)
    Func_Str = ['[', char(Sym_Func), ']'];
elseif (Num_Comp==2)
    Func_Str = ['[', char(Sym_Func(1)), '; ', char(Sym_Func(2)), ']'];
elseif (Num_Comp==3)
    Func_Str = ['[', char(Sym_Func(1)), '; ', char(Sym_Func(2)), '; ', char(Sym_Func(3)), ']'];
elseif (Num_Comp==4)
    Func_Str = ['[', char(Sym_Func(1)), '; ', char(Sym_Func(2)), '; ', char(Sym_Func(3)), '; ', char(Sym_Func(4)), ']'];
elseif (Num_Comp==5)
    Func_Str = ['[', char(Sym_Func(1)), '; ', char(Sym_Func(2)), '; ', char(Sym_Func(3)), '; ', char(Sym_Func(4)), '; ', char(Sym_Func(5)), ']'];
else
    error('Not implemented!');
end

end