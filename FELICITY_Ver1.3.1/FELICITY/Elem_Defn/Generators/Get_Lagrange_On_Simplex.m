function [Nodal_Basis, Nodal_Var] = Get_Lagrange_On_Simplex(dim,deg_k)
%Get_Lagrange_On_Simplex
%
%   This computes the Lagrange basis functions on a simplex.

% Copyright (c) 09-24-2016,  Shawn W. Walker

disp(['Solve for Lagrange degree ', num2str(deg_k), ' basis functions (on ', num2str(dim), '-D reference simplex):']);

if (deg_k < 0)
    % invalid degree, so return *nothing*
    Nodal_Basis = [];
    Nodal_Var   = [];
    return;
end

% get parameterizations of the reference simplex
if (dim==1)
    % get params of the reference interval
    Cell = interval_parameterizations();
elseif (dim==2)
    % get params of the reference triangle
    Cell = triangle_parameterizations();
elseif (dim==3)
    % get params of the reference tetrahedron
    Cell = tetrahedron_parameterizations();
else
    error('Not implemented!');
end
indep_vars = Cell.Param_Inv; % col. vector list of independent variables

% define a set of basis functions (indep. variables are x,y,z, depending on dimension)
Basis = basis_polys_deg_k(indep_vars,deg_k);

% error check
Num_Basis = nchoosek(dim + deg_k,deg_k);
if (Num_Basis~=length(Basis))
    error('Number of basis functions is invalid!');
end

% define nodal variable data
if (dim==1)
    Nodal_Var = lagrange_nodal_points_1D(deg_k);
elseif (dim==2)
    Nodal_Var = lagrange_nodal_points_2D(deg_k);
elseif (dim==3)
    Nodal_Var = lagrange_nodal_points_3D(deg_k);
else
    error('Not implemented!');
end

% generate matrix entries
N = length(Nodal_Var);
if (N~=Num_Basis) % error check
    error('Number of nodal variables is not correct!');
end
% init Vandermonde matrix
A = sym(zeros(N,N));

% fill in the "Vandermonde" matrix
disp('Fill Vandermonde matrix A:');
for ii=1:N
    % get the current nodal variable (DoF)
    Nodal_Var_Data = Nodal_Var(ii).Data;
    Eval_Nodal_Variable = Lagrange_Nodal_Variable(Cell,Nodal_Var_Data,indep_vars);
    
    % loop through all of the (primal) basis functions
    for jj=1:N
        phi = Basis(jj).func; % get basis function
        % insert into matrix
        A(ii,jj) = Eval_Nodal_Variable(phi); % eval nodal variable
    end
    disp(['Compute A(', num2str(ii), ', 1:', num2str(N), ').']);
end
disp('Finished forming Vandermonde matrix...');

% lambda = abs(eig(double(A)));
% COND = max(lambda) / min(lambda);
% COND

% solve for coefficients
EYE_SYM = sym(eye(N));
disp('Solve for coefficients:');
COEF = A \ EYE_SYM;

% compute the nodal basis functions
Nodal_Basis(N).Func = [];
for ind=1:N
    TEMP = 0; % reset!
    for jj=1:N
        TEMP = TEMP + COEF(jj,ind) * Basis(jj).func;
    end
    Nodal_Basis(ind).Func = simplify(TEMP);
end

% display
for ind=1:N
    disp(['Nodal Basis Function #', num2str(ind), ':']);
    pretty(Nodal_Basis(ind).Func)
end

end

function Nodal_Var = lagrange_nodal_points_1D(deg_k)

% lay out the points on the reference interval, starting with the end
% points (for degree k >= 1).  For degree k = 0, just the midpoint.

NV = deg_k+1;
Nodal_Var(NV).Data = [];

% define nodal variable data (in order of the DoF index)
% these specify what the Degrees-of-Freedom (DoFs) are
% Note: these involve point evaluations (reference coordinates are given)
if (deg_k==0)
    Nodal_Var(1).Data = {sym([0.5]), 'eval_cell', 1}; % point eval on cell
else
    Nodal_Var(1).Data = {sym([0]), 'eval_vertex', 1}; % point eval on vertex #1
    Nodal_Var(2).Data = {sym([1]), 'eval_vertex', 2}; % point eval on vertex #2
    % now allocate the rest on the cell
    if NV >= 3
        pts = linspace(0,1,NV)';
        pts = pts(2:end-1,1); % remove end points
        for jj = 1:length(pts)
            Nodal_Var(jj+2).Data = {sym(pts(jj)), 'eval_cell', 1}; % point eval on edge #1
        end
    end
end

end

function Nodal_Var = lagrange_nodal_points_2D(deg_k)

% lay out the points on the reference triangle, starting with the vertices
% (for degree k >= 1).  For degree k = 0, just the barycenter.

NV = nchoosek(2 + deg_k,deg_k);
Nodal_Var(NV).Data = [];

% define nodal variable data (in order of the DoF index)
% these specify what the Degrees-of-Freedom (DoFs) are
% Note: these involve point evaluations (reference coordinates are given)
if (deg_k==0)
    Nodal_Var(1).Data = {sym([(1/3); (1/3)]), 'eval_cell', 1}; % point eval on cell
else
    Nodal_Var(1).Data = {sym([0; 0]), 'eval_vertex', 1}; % point eval on vertex #1
    Nodal_Var(2).Data = {sym([1; 0]), 'eval_vertex', 2}; % point eval on vertex #2
    Nodal_Var(3).Data = {sym([0; 1]), 'eval_vertex', 3}; % point eval on vertex #3
    % now allocate the rest on the facets and the cell
    if NV >= 4
        if (deg_k==2)
            Nodal_Var(4).Data = {sym([(1/2); (1/2)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var(5).Data = {sym([0; (1/2)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(6).Data = {sym([(1/2); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
        elseif (deg_k==3)
            Nodal_Var( 4).Data = {sym([(2/3); (1/3)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 5).Data = {sym([(1/3); (2/3)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            
            Nodal_Var( 6).Data = {sym([0; (2/3)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var( 7).Data = {sym([0; (1/3)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            
            Nodal_Var( 8).Data = {sym([(1/3); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var( 9).Data = {sym([(2/3); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            
            Nodal_Var(10).Data = {sym([(1/3); (1/3)]), 'eval_cell', 1}; % point eval on cell
        elseif (deg_k==4)
            Nodal_Var( 4).Data = {sym([(3/4); (1/4)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 5).Data = {sym([(1/2); (1/2)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 6).Data = {sym([(1/4); (3/4)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            
            Nodal_Var( 7).Data = {sym([0; (3/4)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var( 8).Data = {sym([0; (1/2)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var( 9).Data = {sym([0; (1/4)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            
            Nodal_Var(10).Data = {sym([(1/4); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(11).Data = {sym([(1/2); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(12).Data = {sym([(3/4); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            
            Nodal_Var(13).Data = {sym([(1/4); (1/4)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(14).Data = {sym([(1/2); (1/4)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(15).Data = {sym([(1/4); (1/2)]), 'eval_cell', 1}; % point eval on cell
        elseif (deg_k==5)
            Nodal_Var( 4).Data = {sym([(4/5); (1/5)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 5).Data = {sym([(3/5); (2/5)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 6).Data = {sym([(2/5); (3/5)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 7).Data = {sym([(1/5); (4/5)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            
            Nodal_Var( 8).Data = {sym([0; (4/5)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var( 9).Data = {sym([0; (3/5)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(10).Data = {sym([0; (2/5)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(11).Data = {sym([0; (1/5)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            
            Nodal_Var(12).Data = {sym([(1/5); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(13).Data = {sym([(2/5); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(14).Data = {sym([(3/5); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(15).Data = {sym([(4/5); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            
            Nodal_Var(16).Data = {sym([(2/5); (2/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(17).Data = {sym([(1/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            
            Nodal_Var(18).Data = {sym([(1/5); (2/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(19).Data = {sym([(3/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            
            Nodal_Var(20).Data = {sym([(2/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(21).Data = {sym([(1/5); (3/5)]), 'eval_cell', 1}; % point eval on cell
        elseif (deg_k==6)
            Nodal_Var( 4).Data = {sym([(5/6); (1/6)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 5).Data = {sym([(4/6); (2/6)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 6).Data = {sym([(3/6); (3/6)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 7).Data = {sym([(2/6); (4/6)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            Nodal_Var( 8).Data = {sym([(1/6); (5/6)]), 'eval_facet', 1}; % point eval on facet (edge) #1
            
            Nodal_Var( 9).Data = {sym([0; (5/6)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(10).Data = {sym([0; (4/6)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(11).Data = {sym([0; (3/6)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(12).Data = {sym([0; (2/6)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            Nodal_Var(13).Data = {sym([0; (1/6)]), 'eval_facet', 2}; % point eval on facet (edge) #2
            
            Nodal_Var(14).Data = {sym([(1/6); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(15).Data = {sym([(2/6); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(16).Data = {sym([(3/6); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(17).Data = {sym([(4/6); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            Nodal_Var(18).Data = {sym([(5/6); 0]), 'eval_facet', 3}; % point eval on facet (edge) #3
            
            Nodal_Var(19).Data = {sym([(3/6); (2/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(20).Data = {sym([(2/6); (3/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(21).Data = {sym([(1/6); (1/6)]), 'eval_cell', 1}; % point eval on cell
            
            Nodal_Var(22).Data = {sym([(1/6); (3/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(23).Data = {sym([(1/6); (2/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(24).Data = {sym([(4/6); (1/6)]), 'eval_cell', 1}; % point eval on cell
            
            Nodal_Var(25).Data = {sym([(2/6); (1/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(26).Data = {sym([(3/6); (1/6)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(27).Data = {sym([(1/6); (4/6)]), 'eval_cell', 1}; % point eval on cell
            
            Nodal_Var(28).Data = {sym([(1/3); (1/3)]), 'eval_cell', 1}; % point eval on cell
        else
            error('Not implemented!');
        end
    end
end

end

function Nodal_Var = lagrange_nodal_points_3D(deg_k)

% lay out the points on the reference tetrahedron, starting with the vertices
% (for degree k >= 1).  For degree k = 0, just the barycenter.

NV = nchoosek(3 + deg_k,deg_k);
Nodal_Var(NV).Data = [];

% define nodal variable data (in order of the DoF index)
% these specify what the Degrees-of-Freedom (DoFs) are
% Note: these involve point evaluations (reference coordinates are given)
if (deg_k==0)
    Nodal_Var(1).Data = {sym([(1/4); (1/4); (1/4)]), 'eval_cell', 1}; % point eval on cell
else
    Nodal_Var(1).Data = {sym([0; 0; 0]), 'eval_vertex', 1}; % point eval on vertex #1
    Nodal_Var(2).Data = {sym([1; 0; 0]), 'eval_vertex', 2}; % point eval on vertex #2
    Nodal_Var(3).Data = {sym([0; 1; 0]), 'eval_vertex', 3}; % point eval on vertex #3
    Nodal_Var(4).Data = {sym([0; 0; 1]), 'eval_vertex', 4}; % point eval on vertex #4
    % now allocate the rest on the facets and the cell
    if NV >= 5
        if (deg_k==2)
            Nodal_Var( 5).Data = {sym([(1/2); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 6).Data = {sym([0; (1/2); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var( 7).Data = {sym([0; 0; (1/2)]), 'eval_edge', 3}; % point eval on edge #3
            
            Nodal_Var( 8).Data = {sym([(1/2); (1/2); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var( 9).Data = {sym([0; (1/2); (1/2)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(10).Data = {sym([(1/2); 0; (1/2)]), 'eval_edge', 6}; % point eval on edge #6
        elseif (deg_k==3)
            Nodal_Var( 5).Data = {sym([(1/3); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 6).Data = {sym([(2/3); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            
            Nodal_Var( 7).Data = {sym([0; (1/3); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var( 8).Data = {sym([0; (2/3); 0]), 'eval_edge', 2}; % point eval on edge #2
            
            Nodal_Var( 9).Data = {sym([0; 0; (1/3)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(10).Data = {sym([0; 0; (2/3)]), 'eval_edge', 3}; % point eval on edge #3
            
            Nodal_Var(11).Data = {sym([(2/3); (1/3); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(12).Data = {sym([(1/3); (2/3); 0]), 'eval_edge', 4}; % point eval on edge #4
            
            Nodal_Var(13).Data = {sym([0; (2/3); (1/3)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(14).Data = {sym([0; (1/3); (2/3)]), 'eval_edge', 5}; % point eval on edge #5
            
            Nodal_Var(15).Data = {sym([(1/3); 0; (2/3)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(16).Data = {sym([(2/3); 0; (1/3)]), 'eval_edge', 6}; % point eval on edge #6
            
            Nodal_Var(17).Data = {sym([(1/3); (1/3); (1/3)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(18).Data = {sym([    0; (1/3); (1/3)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(19).Data = {sym([(1/3);     0; (1/3)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(20).Data = {sym([(1/3); (1/3);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
        elseif (deg_k==4)
            Nodal_Var( 5).Data = {sym([(1/4); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 6).Data = {sym([(1/2); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 7).Data = {sym([(3/4); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            
            Nodal_Var( 8).Data = {sym([0; (1/4); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var( 9).Data = {sym([0; (1/2); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var(10).Data = {sym([0; (3/4); 0]), 'eval_edge', 2}; % point eval on edge #2
            
            Nodal_Var(11).Data = {sym([0; 0; (1/4)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(12).Data = {sym([0; 0; (1/2)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(13).Data = {sym([0; 0; (3/4)]), 'eval_edge', 3}; % point eval on edge #3
            
            Nodal_Var(14).Data = {sym([(3/4); (1/4); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(15).Data = {sym([(1/2); (1/2); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(16).Data = {sym([(1/4); (3/4); 0]), 'eval_edge', 4}; % point eval on edge #4
            
            Nodal_Var(17).Data = {sym([0; (3/4); (1/4)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(18).Data = {sym([0; (1/2); (1/2)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(19).Data = {sym([0; (1/4); (3/4)]), 'eval_edge', 5}; % point eval on edge #5
            
            Nodal_Var(20).Data = {sym([(1/4); 0; (3/4)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(21).Data = {sym([(1/2); 0; (1/2)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(22).Data = {sym([(3/4); 0; (1/4)]), 'eval_edge', 6}; % point eval on edge #6
            
            Nodal_Var(23).Data = {sym([(1/2); (1/4); (1/4)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(24).Data = {sym([(1/4); (1/2); (1/4)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(25).Data = {sym([(1/4); (1/4); (1/2)]), 'eval_facet', 1}; % point eval on facet (face) #1
            
            Nodal_Var(26).Data = {sym([    0; (1/4); (1/4)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(27).Data = {sym([    0; (1/4); (1/2)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(28).Data = {sym([    0; (1/2); (1/4)]), 'eval_facet', 2}; % point eval on facet (face) #2
            
            Nodal_Var(29).Data = {sym([(1/4);     0; (1/4)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(30).Data = {sym([(1/2);     0; (1/4)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(31).Data = {sym([(1/4);     0; (1/2)]), 'eval_facet', 3}; % point eval on facet (face) #3
            
            Nodal_Var(32).Data = {sym([(1/4); (1/4);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            Nodal_Var(33).Data = {sym([(1/4); (1/2);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            Nodal_Var(34).Data = {sym([(1/2); (1/4);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            
            Nodal_Var(35).Data = {sym([(1/4); (1/4); (1/4)]), 'eval_cell', 1}; % point eval on cell
        elseif (deg_k==5)
            Nodal_Var( 5).Data = {sym([(1/5); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 6).Data = {sym([(2/5); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 7).Data = {sym([(3/5); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            Nodal_Var( 8).Data = {sym([(4/5); 0; 0]), 'eval_edge', 1}; % point eval on edge #1
            
            Nodal_Var( 9).Data = {sym([0; (1/5); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var(10).Data = {sym([0; (2/5); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var(11).Data = {sym([0; (3/5); 0]), 'eval_edge', 2}; % point eval on edge #2
            Nodal_Var(12).Data = {sym([0; (4/5); 0]), 'eval_edge', 2}; % point eval on edge #2
            
            Nodal_Var(13).Data = {sym([0; 0; (1/5)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(14).Data = {sym([0; 0; (2/5)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(15).Data = {sym([0; 0; (3/5)]), 'eval_edge', 3}; % point eval on edge #3
            Nodal_Var(16).Data = {sym([0; 0; (4/5)]), 'eval_edge', 3}; % point eval on edge #3
            
            Nodal_Var(17).Data = {sym([(4/5); (1/5); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(18).Data = {sym([(3/5); (2/5); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(19).Data = {sym([(2/5); (3/5); 0]), 'eval_edge', 4}; % point eval on edge #4
            Nodal_Var(20).Data = {sym([(1/5); (4/5); 0]), 'eval_edge', 4}; % point eval on edge #4
            
            Nodal_Var(21).Data = {sym([0; (4/5); (1/5)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(22).Data = {sym([0; (3/5); (2/5)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(23).Data = {sym([0; (2/5); (3/5)]), 'eval_edge', 5}; % point eval on edge #5
            Nodal_Var(24).Data = {sym([0; (1/5); (4/5)]), 'eval_edge', 5}; % point eval on edge #5
            
            Nodal_Var(25).Data = {sym([(1/5); 0; (4/5)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(26).Data = {sym([(2/5); 0; (3/5)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(27).Data = {sym([(3/5); 0; (2/5)]), 'eval_edge', 6}; % point eval on edge #6
            Nodal_Var(28).Data = {sym([(4/5); 0; (1/5)]), 'eval_edge', 6}; % point eval on edge #6
            
            %%%%%%%%%%%
            Nodal_Var(29).Data = {sym([(1/5); (2/5); (2/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(30).Data = {sym([(3/5); (1/5); (1/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            
            Nodal_Var(31).Data = {sym([(2/5); (1/5); (2/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(32).Data = {sym([(1/5); (3/5); (1/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            
            Nodal_Var(33).Data = {sym([(2/5); (2/5); (1/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            Nodal_Var(34).Data = {sym([(1/5); (1/5); (3/5)]), 'eval_facet', 1}; % point eval on facet (face) #1
            
            %%%%%%%%%%%
            Nodal_Var(35).Data = {sym([    0; (2/5); (2/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(36).Data = {sym([    0; (1/5); (1/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            
            Nodal_Var(37).Data = {sym([    0; (2/5); (1/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(38).Data = {sym([    0; (1/5); (3/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            
            Nodal_Var(39).Data = {sym([    0; (1/5); (2/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            Nodal_Var(40).Data = {sym([    0; (3/5); (1/5)]), 'eval_facet', 2}; % point eval on facet (face) #2
            
            %%%%%%%%%%%
            Nodal_Var(41).Data = {sym([(2/5);     0; (2/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(42).Data = {sym([(1/5);     0; (1/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            
            Nodal_Var(43).Data = {sym([(1/5);     0; (2/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(44).Data = {sym([(3/5);     0; (1/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            
            Nodal_Var(45).Data = {sym([(2/5);     0; (1/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            Nodal_Var(46).Data = {sym([(1/5);     0; (3/5)]), 'eval_facet', 3}; % point eval on facet (face) #3
            
            %%%%%%%%%%%
            Nodal_Var(47).Data = {sym([(2/5); (2/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            Nodal_Var(48).Data = {sym([(1/5); (1/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            
            Nodal_Var(49).Data = {sym([(2/5); (1/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            Nodal_Var(50).Data = {sym([(1/5); (3/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            
            Nodal_Var(51).Data = {sym([(1/5); (2/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            Nodal_Var(52).Data = {sym([(3/5); (1/5);     0]), 'eval_facet', 4}; % point eval on facet (face) #4
            
            %%%%%
            Nodal_Var(53).Data = {sym([(1/5); (1/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(54).Data = {sym([(2/5); (1/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(55).Data = {sym([(1/5); (2/5); (1/5)]), 'eval_cell', 1}; % point eval on cell
            Nodal_Var(56).Data = {sym([(1/5); (1/5); (2/5)]), 'eval_cell', 1}; % point eval on cell
        else
            error('Not implemented!');
        end
    end
end

end