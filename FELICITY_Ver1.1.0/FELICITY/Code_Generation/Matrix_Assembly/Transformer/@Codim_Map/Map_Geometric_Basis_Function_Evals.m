function Eval_Basis = Map_Geometric_Basis_Function_Evals(obj,Eval_Basis,Codim_Map)
%Map_Geometric_Basis_Function_Evals
%
%   This maps the geometric basis function evaluations onto a local mesh entity.
%   This is for building a new geometric map for a subdomain, then restricting
%   that map to a Domain of Integration (or Expression).
%
%   Note: this is only for geometric maps (GeometricElementFunction(s)).

% Copyright (c) 06-21-2012,  Shawn W. Walker

% The input Eval_Basis is defined over the reference element that the GLOBAL
% Mesh is defined on.

% The Codim_Map comes from the routine:
%     'obj.Generate_Local_Maps_For_Geometric_Basis_Functions'
% and is linked to specific topological entities in the reference element.
% Note that Codim_Map contains two distinct maps.

% Summary:
%
% This routine allows for computing the geometry of a Subdomain manifold, and to
% restrict that information to a lower dimensional Domain of Integration (DoI).
%
% Suppose the topological dimension of Subdomain is strictly less than that
% of Global.  Then we must use a different set of geometry basis functions, one
% that corresponds to the Subdomain manifold.  This is done by mapping the
% Global geometry basis functions to a new set of functions that can describe
% the Subdomain manifold.  This is what this subroutine does!  It creates a new
% Eval_Basis that corresponds to this new set of basis functions.  The reason
% this is done is b/c derivative operations must be mapped appropriately to the
% geometric manifold.

% Then there is the DoI.  This is where we wish to *evaluate* the geometric map.
% In other words, the domain of the symbolic expression for Eval_Basis is the
% DoI.  For example, if Global is a set of triangles, and Subdomain is a subset
% of triangles, and the integration domain is a set of edges referenced to the
% Subdomain triangles, then Eval_Basis will be restricted to a local mesh edge
% entity.


% maximum order of derivatives desired for basis functions
Max_Deriv_Order = Eval_Basis(1).Max_Deriv;

% initialize the array with a blank function
TEMP = FELSymFunc(sym('0'));
New_Eval_Basis = FELSymBasisCalc(TEMP,Max_Deriv_Order);

% loop through all basis functions
Num_Basis_Func = length(Eval_Basis);
for jj=1:Num_Basis_Func
    % get the basis function (without derivative) that is defined on the Global cell
    BF = Eval_Basis(jj).Base_Func;
    
    % compose basis function with local map from Subdomain cell ---> Global cell
    BF_Mapped = BF.Compose_Function(Codim_Map.Sub);
    % this is a new *intrinsic* map from Subdomain cell ---> Global cell
    
    % create an object that computes all the desired derivatives for this new
    % composed function
    New_Eval_Basis(jj) = FELSymBasisCalc(BF_Mapped,Max_Deriv_Order);
    
    % now compose the new basis function (and all its derivatives) with the
    % local map from DoI cell ---> Subdomain cell
    New_Eval_Basis(jj) = New_Eval_Basis(jj).Compose_With_Function(Codim_Map.DoI);
    
    % this gives a new *restricted* map from DoI cell ---> Global cell
end

Eval_Basis = New_Eval_Basis;

end