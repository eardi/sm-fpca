function status = Check_Element_Definition(Elem)
%Check_Element_Definition
%
%   This checks that the element is properly defined.

% Copyright (c) 01-11-2018,  Shawn W. Walker

if (length(Elem)~=1)
    disp('Elem must be a SINGLE element!');
    status = -1;
    return;
end

if ~ischar(Elem.Name)
    error('Elem.Name must be a string.');
end
if ~or(or(strcmp(Elem.Type,'CG'),strcmp(Elem.Type,'DG')),strcmp(Elem.Type,'constant_one'))
    error('Only Continuous-Galerkin and Discontinuous-Galerkin is implemented!');
end

if strcmp(Elem.Type,'constant_one')
    % nothing needs to be checked, because this is a special case!
    status = 0; % all good
    return;
end

Dim = Elem.Dim;
if Dim==1
    Vtx_Pos = [0;1];
    if ~strcmp(Elem.Domain,'interval')
        error('A 1-D domain must be an interval.');
    end
elseif Dim==2
    Vtx_Pos = [0,0;1,0;0,1];
    if ~strcmp(Elem.Domain,'triangle')
        error('A 2-D domain must be a triangle.');
    end
elseif Dim==3
    Vtx_Pos = [0,0,0;1,0,0;0,1,0;0,0,1];
    if ~strcmp(Elem.Domain,'tetrahedron')
        error('A 3-D domain must be a tetrahedron.');
    end
else
    error('Only dimensions 1, 2, and 3 are implemented.');
end

Num_Basis         = length(Elem.Basis);
Dim_of_Basis_Func = size(Elem.Basis(1).Func);
% if (Dim_of_Basis_Func(2)~=1)
%     disp('Matrix valued basis functions have not been implemented!');
%     error('Basis functions can only be column vectors (I will improve later...).');
% end
Num_Row = Dim_of_Basis_Func(1);
Num_Col = Dim_of_Basis_Func(2);
Num_Nodal_Basis = length(Elem.Nodal_Var);
if (Num_Basis~=Num_Nodal_Basis)
    error('Dimension of the basis functions and nodal variables must be the same!');
end
% check transformation type
if strcmp(Elem.Transformation,'H1_Trans')
    % OK
elseif strcmp(Elem.Transformation,'Hdiv_Trans')
    % OK
elseif strcmp(Elem.Transformation,'Hdivdiv_Trans')
    % OK
elseif strcmp(Elem.Transformation,'Hcurl_Trans')
    % OK
else
    error('Invalid transformation type.');
end

% % check if basis and nodal (dual) basis are "orthogonal"
% SWW: this needs to be rewritten!!!!
% N_phi = zeros(Num_Nodal_Basis,Num_Basis);
% for i1 = 1:Num_Nodal_Basis
%     for j1 = 1:Num_Basis
%         VAL = 0;
%         for c1 = 1:Num_Vector_Comp
%             Nodal_Var_str = Elem.Nodal_Var.Basis{i1,1}{c1};
%             phi = sym(Elem.Basis.Func{j1,c1});
%             phi_eval = eval(Nodal_Var_str); % use feval!
% 
%             BaryCenCoord = Elem.Nodal_Var.Basis{i1,2};
%             CoordEval = BaryCenCoord * Vtx_Pos;
%             
%             if Dim==1
%                 func_handle(c1).f = matlabFunction(phi_eval,'vars',{'x'});
%                 VAL = VAL + func_handle(c1).f(CoordEval(1));
%             elseif Dim==2
%                 func_handle(c1).f = matlabFunction(phi_eval,'vars',{'x','y'});
%                 VAL = VAL + func_handle(c1).f(CoordEval(1),CoordEval(2));
%             elseif Dim==3
%                 func_handle(c1).f = matlabFunction(phi_eval,'vars',{'x','y','z'});
%                 VAL = VAL + func_handle(c1).f(CoordEval(1),CoordEval(2),CoordEval(3));
%             else
%                 error('This should be caught earlier!');
%             end
% %             if Dim==1
% % %                 BaryCen = Elem.Nodal_Var.Basis{i1,2};
% % %                 Point   = 
% % %                 VAL = phi(c1).func();
% %             elseif Dim==2
% %             elseif Dim==3
% %             else
% %                 error('This should be caught earlier!');
% %             end
%         end
%         N_phi(i1,j1) = VAL;
%     end
% end
% 
% N_phi_ERR = abs(N_phi - eye(Num_Basis));
% N_phi_ERR = sum(N_phi_ERR(:));
% 
% if (N_phi_ERR > 1e-15)
%     warning('FELICITY:ElemDefn','Basis and Dual Basis are NOT orthogonal!');
% end

NODES = [];
nnt = length(Elem.Nodal_Top);
for i1 = 1:nnt
    for i2 = 1:length(Elem.Nodal_Top(i1).V)
        NODES = [NODES; Elem.Nodal_Top(i1).V{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).E)
        NODES = [NODES; Elem.Nodal_Top(i1).E{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).F)
        NODES = [NODES; Elem.Nodal_Top(i1).F{i2}(:)];
    end
    for i2 = 1:length(Elem.Nodal_Top(i1).T)
        NODES = [NODES; Elem.Nodal_Top(i1).T{i2}(:)];
    end
end

num_nodes = length(NODES);
UN = unique(NODES);
num_unique_nodes = length(UN);

if (num_nodes~=num_unique_nodes)
    error('Nodal Topology arrangment contains duplicated nodes.');
end

status = 0;

end