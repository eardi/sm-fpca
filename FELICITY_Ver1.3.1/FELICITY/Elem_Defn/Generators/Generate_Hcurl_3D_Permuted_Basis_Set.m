function Perm_Basis = Generate_Hcurl_3D_Permuted_Basis_Set(Elem,Permute_NV)
%Generate_Hcurl_3D_Permuted_Basis_Set
%
%   This generates 24 permutations of the H(curl) basis functions (in 3-D).
%   Thr output is an array of structs containing the set of basis functions
%   for each permutation.  It also contains the corresponding permutation
%   signature.
%
%   Note: this works with "Premap_Transformation_in_3D.m", in the
%         Hcurl_Trans class.

% Copyright (c) 11-02-2016,  Shawn W. Walker

% get basis functions on reference element
Ref_Elem      = ReferenceFiniteElement(Elem,1);
Quad_NOT_USED = Ref_Elem.Gen_Quadrature_Rule(1, 'tetrahedron'); % bogus! not really used
Eval_Basis    = Ref_Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,1);
clear Ref_Elem;

% define generic affine map (represented by a constant matrix and constant vector)
% the inputs are the vertex coordinates of the corners of the target
% tetrahedron
Generic_Perm_Map = @(X1,X2,X3,X4) {...
                [ (X2(1) - X1(1)), (X3(1) - X1(1)), (X4(1) - X1(1));
                  (X2(2) - X1(2)), (X3(2) - X1(2)), (X4(2) - X1(2));
                  (X2(3) - X1(3)), (X3(3) - X1(3)), (X4(3) - X1(3))],...
                [X1(1); X1(2); X1(3)]};
%
% standard reference tetrahedron vertex coordinates
XC_1 = [0, 0, 0];
XC_2 = [1, 0, 0];
XC_3 = [0, 1, 0];
XC_4 = [0, 0, 1];
Ref_XC = [XC_1; XC_2; XC_3; XC_4];

% max derivative order to compute
%Max_Deriv = Eval_Basis(1).Max_Deriv; % get this!
Num_Basis = length(Eval_Basis);

% need symbolic variables
std_vars   = {'x', 'y', 'z'};
tilde_vars = {'x_t', 'y_t', 'z_t'};
syms x y z;
vec_x = [x; y; z];

% rename variables in Eval_Basis (do it once!)
Eval_Basis_Rename = Eval_Basis;
Nodal_BC_Coord = zeros(Num_Basis,4);
for bi = 1:Num_Basis
    Eval_Basis_Rename(bi).Base_Func = Eval_Basis_Rename(bi).Base_Func.Rename_Independent_Vars(std_vars,tilde_vars);
    % note: we do NOT bother to rename the derivative functions (because they are not used)
    Nodal_BC_Coord(bi,:) = Elem.Nodal_Var(bi).Data{1};
end

% loop through all permutations
TEMP_PP = perms([1 2 3 4]);
Perm_List = TEMP_PP(end:-1:1,:);
Num_Perm = size(Perm_List,1);
Perm_Basis(Num_Perm).Signature  = [];
Perm_Basis(Num_Perm).Elem       = [];
for pp = 1:Num_Perm
    % store signature
    Perm_Signature = Perm_List(pp,:);
    disp(['Current permutation #', num2str(pp), ' / ', num2str(Num_Perm), '.   Signature: ', num2str(Perm_Signature)]);
    Perm_Tet = get_tetrahedral_entity_permutations(Perm_Signature');
    TP = Perm_Signature - 1; % C-style!
    Perm_Basis(pp).Signature = TP(1) * 1 +...
                               TP(2) * 10 +...
                               TP(3) * 100 +...
                               TP(4) * 1000;
    %
    
    % make the affine map
    Perm_Coord = Ref_XC(Perm_Signature,:);
    Perm_Map_Data = Generic_Perm_Map(Perm_Coord(1,:),Perm_Coord(2,:),Perm_Coord(3,:),Perm_Coord(4,:));
    Sym_Func_Temp = Perm_Map_Data{1} * vec_x + Perm_Map_Data{2};
    % need it symbolically (this is my F_{\tilde{T}} map from \hat{T} --> \tilde{T}
    Sym_Perm_Map = FELSymFunc(Sym_Func_Temp,std_vars);
    % and numerically
    Numerical_Perm_Map = @(X) Perm_Map_Data{1} * X + Perm_Map_Data{2} * ones(1,size(X,2));
    Jacobian_Matrix = Perm_Map_Data{1};
    
    % build DoF permutation map (from hat{T} to tilde{T})
    DoF_Perm = zeros(Num_Basis,1);
    % loop through all Topological Entity DoFs
    DoF_Perm = Build_DoF_Perm(DoF_Perm,Nodal_BC_Coord,Elem.Nodal_Top.V,Perm_Tet.Vtx,Numerical_Perm_Map);
    DoF_Perm = Build_DoF_Perm(DoF_Perm,Nodal_BC_Coord,Elem.Nodal_Top.E,Perm_Tet.Edge,Numerical_Perm_Map);
    DoF_Perm = Build_DoF_Perm(DoF_Perm,Nodal_BC_Coord,Elem.Nodal_Top.F,Perm_Tet.Face,Numerical_Perm_Map);
    DoF_Perm = Build_DoF_Perm(DoF_Perm,Nodal_BC_Coord,Elem.Nodal_Top.T,Perm_Tet.Tet,Numerical_Perm_Map);
    % error check
    if (length(unique(DoF_Perm))~=Num_Basis)
        error('DoF_Perm is not formed properly!');
    end
    if (min(DoF_Perm)==0)
        error('One of the DoFs was not found!');
    end
    
    % init basis set
    New_Basis = Elem.Basis;
    % loop through basis set
    for bi = 1:Num_Basis
        % get function on \tilde{T}
        Perm_bi = DoF_Perm(bi);
        Single_Basis_Func = Eval_Basis_Rename(Perm_bi).Base_Func; % a FELSymFunc
        
        % compute effective function on \hat{T}
        Mapped_Basis_Func = Single_Basis_Func.Compose_Function(Sym_Perm_Map);
        % multiply by jacobian transpose
        Single_Basis_Func_hat      = Mapped_Basis_Func; % init
        Single_Basis_Func_hat.Func = Jacobian_Matrix' * Mapped_Basis_Func.Func; % a "sym"
        
        % BEGIN: TEST CODE
        % create FELSymBasisCalc object
        BF_hat      = FELSymBasisCalc(Single_Basis_Func_hat,1);

        BF_hat_d_dx = BF_hat.Get_Derivative([1 0 0]);
        BF_hat_d_dy = BF_hat.Get_Derivative([0 1 0]);
        BF_hat_d_dz = BF_hat.Get_Derivative([0 0 1]);
        BF_hat_grad = [BF_hat_d_dx.Func, BF_hat_d_dy.Func, BF_hat_d_dz.Func];
        
        BF_d_dx = Eval_Basis(Perm_bi).Get_Derivative([1 0 0]);
        BF_d_dy = Eval_Basis(Perm_bi).Get_Derivative([0 1 0]);
        BF_d_dz = Eval_Basis(Perm_bi).Get_Derivative([0 0 1]);
        
        BF_d_dx = BF_d_dx.Rename_Independent_Vars(std_vars,tilde_vars);
        BF_d_dy = BF_d_dy.Rename_Independent_Vars(std_vars,tilde_vars);
        BF_d_dz = BF_d_dz.Rename_Independent_Vars(std_vars,tilde_vars);
        
        BF_d_dx = BF_d_dx.Compose_Function(Sym_Perm_Map);
        BF_d_dy = BF_d_dy.Compose_Function(Sym_Perm_Map);
        BF_d_dz = BF_d_dz.Compose_Function(Sym_Perm_Map);
        BF_grad = [BF_d_dx.Func, BF_d_dy.Func, BF_d_dz.Func];
        
        BF_grad_transform = Jacobian_Matrix' * BF_grad * Jacobian_Matrix;
        CHK1 = simplify(BF_hat_grad - BF_grad_transform);
        if (sum(abs(CHK1(:)))~=sym(0))
            error('Something does not match!');
        end
        % END: TEST CODE
        
        % store the basis function (defined on \hat{T}) as a string
        New_Basis(bi).Func = {char(Single_Basis_Func_hat.Func(1));
                              char(Single_Basis_Func_hat.Func(2));
                              char(Single_Basis_Func_hat.Func(3))};
    end
    % store the permuted basis!
    Perm_Basis(pp).Elem = Elem; % init
    Perm_Basis(pp).Elem.Basis = New_Basis;
    Perm_Basis(pp).Elem.Nodal_Var = Permute_NV(DoF_Perm,Perm_Tet,Sym_Perm_Map,Jacobian_Matrix);
end

end

function DoF_Perm = Build_DoF_Perm(DoF_Perm,Nodal_BC_Coord,...
                                   Topological_DoFs,Perm_Entity,Numerical_Perm_Map)
%
% DoF_Perm     : \hat{T} --> \tilde{T}

% note: the master DoFs (and master finite element) are defined on \tilde{T}

% loop through all DoFs of given topology
for si = 1:length(Topological_DoFs)
    DoF_Set = Topological_DoFs{si};
    for entity_hat = 1:size(DoF_Set,1)
        % get corresponding entity in \tilde{T}
        entity_tilde = Perm_Entity(entity_hat);
        
        % get topological entity DoFs (on \tilde{T})
        DoF_Indices_tilde = DoF_Set(entity_tilde,:);
        % get the corresponding DoF indices on \hat{T}
        % note: the DoF indices are arranged the same way on \hat{T}
        DoF_Indices_hat = DoF_Set(entity_hat,:);
        
        % get barycentric coordinates of DoFs
        BC_hat   = Nodal_BC_Coord(DoF_Indices_hat,:);
        BC_tilde = Nodal_BC_Coord(DoF_Indices_tilde,:);
        
        % make sure to get where the "hat" coordinates get mapped to
        Ref_Coord_hat = BC_hat(:,2:end);
        Mapped_Ref_Pt = Numerical_Perm_Map(Ref_Coord_hat')';
        Mapped_BC_hat = [1 - sum(Mapped_Ref_Pt,2), Mapped_Ref_Pt];
        
        % deduce mapping from the coordinates
        Map_hat_to_tilde = Get_Mapping_via_Coordinates(Mapped_BC_hat,BC_tilde);
        DoF_Perm(DoF_Indices_hat) = DoF_Indices_tilde(Map_hat_to_tilde);
    end
end

end

function Map_hat_to_tilde = Get_Mapping_via_Coordinates(BC_hat,BC_tilde)

Num_Coord = size(BC_hat,1);
Map_hat_to_tilde = zeros(Num_Coord,1); % init
Indices = (1:1:Num_Coord)';
for ii_hat = 1:Num_Coord
    Current_BC_hat = BC_hat(ii_hat,:);
    Diff_1 = BC_tilde - [Current_BC_hat(1)*ones(Num_Coord,1), Current_BC_hat(2)*ones(Num_Coord,1),...
                         Current_BC_hat(3)*ones(Num_Coord,1), Current_BC_hat(4)*ones(Num_Coord,1)];
    Diff_CHK = max(abs(Diff_1),[],2);
    Zero_Mask = (Diff_CHK < 1e-15);
    if (sum(Zero_Mask)~=1)
        error('Either no DoF was found, or too many!');
    end
    % record correspondance
    Map_hat_to_tilde(ii_hat) = Indices(Zero_Mask);
end

end