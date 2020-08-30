function TF = Verify_Nodal_Kronecker_Delta_Property(obj)
%Verify_Nodal_Kronecker_Delta_Property
%
%   This verifies that the basis functions and nodal variables satisfy the
%   Kronecker Delta property, i.e.
%
%         \delta_{ij} = N_{i} (\phi_j),
%
%   where \phi_j is the jth basis function.  N_{i} is the nodal variable.
%
%   TF = obj.Verify_Nodal_Kronecker_Delta_Property();
%
%   TF = true/false: indicates if Kronecker Delta property is satisfied.

% Copyright (c) 11-03-2016,  Shawn W. Walker

TF = true; % init

% get parameterizations of the reference simplex
if strcmpi(obj.Simplex_Type,'interval')
    % get params of the reference interval
    Cell = interval_parameterizations();
elseif strcmpi(obj.Simplex_Type,'triangle')
    % get params of the reference triangle
    Cell = triangle_parameterizations();
elseif strcmpi(obj.Simplex_Type,'tetrahedron')
    % get params of the reference tetrahedron
    Cell = tetrahedron_parameterizations();
else
    error('Not implemented!');
end
Indep_Vars = Cell.Param_Inv; % col. vector list of independent variables

% depending on element type, choose correct nodal variable definition
if strncmpi(obj.Element_Name,'lagrange_deg2_dim3',12)
    % Lagrange element
    NV_Data = @(BC,Dual_Func,Type_str,entity_index,dof_set_index) {BC, Type_str, entity_index};
    Get_Nodal_Variable = @(Nodal_Var_Data) Lagrange_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars);
elseif strncmpi(obj.Element_Name,'raviart_thomas_deg2_dim3',18)
    % Raviart-Thomas element
    NV_Data = @(BC,Dual_Func,Type_str,entity_index,dof_set_index) {BC, Dual_Func, Type_str, entity_index, 'dof_set', dof_set_index};
    Get_Nodal_Variable = @(Nodal_Var_Data) RaviartThomas_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars);
elseif strncmpi(obj.Element_Name,'brezzi_douglas_marini_deg1_dim2',25)
    % BDM element
    error('Not implemented!');
elseif strncmpi(obj.Element_Name,'nedelec_1stkind_deg2_dim3',19)
    % Nedelec 1st-kind element
    NV_Data = @(BC,Dual_Func,Type_str,entity_index,dof_set_index) {BC, Dual_Func, Type_str, entity_index, 'dof_set', dof_set_index};
    Get_Nodal_Variable = @(Nodal_Var_Data) Nedelec_1stKind_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars);
else
    % ???
    error('Not implemented!');
end

% loop over nodal variables
N = obj.Num_Basis;
for ii = 1:N
    disp(['Checking Nodal Variable #', num2str(ii), ' of ', num2str(N)]);
    
    % get nodal variable data
    NV_i = NV_Data(obj.Nodal_Data.BC_Coord(ii,:), obj.Nodal_Data.Dual(ii).Func,...
                   obj.Nodal_Data.Type{ii}, obj.Nodal_Data.Entity_Index(ii), obj.Nodal_Data.DoF_Set(ii));
    % get function to evaluate nodal variable
    Nodal_Var_i = Get_Nodal_Variable(NV_i);
    
    % loop over nodal basis functions
    
    for jj = 1:ii-1
        % evaluate nodal variable ii at basis function jj (should be 0)
        delta_ij = Nodal_Var_i(obj.Basis(jj).phi);
        if ( abs(delta_ij) > 1e-15)
            delta_ij
            disp('Should be zero!');
            TF = false;
        end
    end
    % evaluate nodal variable ii at basis function ii (should be 1)
    delta_ij = Nodal_Var_i(obj.Basis(ii).phi);
    if ( abs(1 - delta_ij) > 1e-15)
        delta_ij
        disp('Should be one!');
        TF = false;
    end
    
    for jj = ii+1:N
        % evaluate nodal variable ii at basis function jj (should be 0)
        delta_ij = Nodal_Var_i(obj.Basis(jj).phi);
        if ( abs(delta_ij) > 1e-15)
            delta_ij
            disp('Should be zero!');
            TF = false;
        end
    end
end

end