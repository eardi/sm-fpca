function Integrand_sym_NEW = Make_Integrand_Use_1st_Tensor_Components(TestF,TrialF,Integrand_sym)
%Make_Integrand_Use_1st_Tensor_Components
%
%   This sets the symbolic variable in the integrand to use the first tensor
%   component.
%   for tensor components, we can change the integrand to only use the first
%   tensor component, e.g. if
%                     Integrand_sym = 'u_v1_t2*v_v1_t2',
%   then we can replace it with
%                     Integrand_sym = 'u_v1_t1*v_v1_t1',
%   because the row and column indices are already set!
%   Remark: for tensor finite elements, a basis function for a specific tensor
%   component is EXACTLY THE SAME as the corresponding basis function for any
%   other tensor component.

% Copyright (c) 08-01-2011,  Shawn W. Walker

% init
Integrand_sym_NEW = Integrand_sym;

if ~isempty(TestF)
    Integrand_sym_NEW = Replace_By_1st_Tensor_Component(TestF,Integrand_sym_NEW);
end
if ~isempty(TrialF)
    Integrand_sym_NEW = Replace_By_1st_Tensor_Component(TrialF,Integrand_sym_NEW);
end

end