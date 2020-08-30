function [TV, NV] = Evaluate_Tangent_Normal_Funcs(obj,Chart_Set,Chart_Var)
%Evaluate_Tangent_Normal_Funcs
%
%   This evaluates the tangent and normal functions of the parameterized
%   domain, given the local parameterization variable \xi for each chart.
%
%   [TV, NV] = obj.Evaluate_Tangent_Normal_Funcs(Chart_Set,Chart_Var);
%
%   Chart_Set = Kx1 cell array that indicates which chart to use for each
%               set of points.
%   Chart_Var = Kx1 cell array, with a column vector of \xi points in each
%               entry.  Each column vector is Qx1.
%
%   TV, NV = Kx1 cell arrays, where each entry is a Qx2 matrix containing
%            the evaluations of the tangent (TV) and normal (NV) vectors,
%            i.e. row i is the vector value at the ith \xi value.

% Copyright (c) 08-27-2019,  Shawn W. Walker

Num_Sets = length(Chart_Set);
if (Num_Sets~=length(Chart_Var))
    error('Chart_Set and Chart_Var must have the same number of entries.');
end
if ~and(iscell(Chart_Set),iscell(Chart_Var))
    error('Chart_Set and Chart_Var must be cell arrays.');
end

% get the tangent and normal vector
[Tangent_Func, Normal_Func] = obj.Get_Tangent_Normal_Funcs();

% init
TV = cell(Num_Sets,1);
NV = cell(Num_Sets,1);

for ii = 1:Num_Sets
    ch_ind = Chart_Set{ii};
    xi = Chart_Var{ii};
    
    % get the correct tangent and normal vector for the current chart
    TV_func = Tangent_Func{ch_ind};
    NV_func = Normal_Func{ch_ind};
    
    % evaluate the tangent and normal vector (extend by a constant)
    TV{ii} = TV_func(xi);
    NV{ii} = NV_func(xi);
end

end