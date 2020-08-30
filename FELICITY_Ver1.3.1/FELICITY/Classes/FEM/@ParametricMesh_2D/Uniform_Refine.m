function [TRI_new, VTX_new, BdyEDGE_new, BdyChart_Ind_new, BdyChart_Var_new, BdyTRI_Ind_new] =...
               Uniform_Refine(obj,TRI,VTX,BdyEDGE,BdyChart_Ind,BdyChart_Var,BdyTRI_Ind)
%Uniform_Refine
%
%   This refines a given mesh so that it conforms to the curved boundary.
%
%   FH = obj.Uniform_Refine(XXXX);
%
%   Num_Bdy_Pts = number of points to use (approximately) in plotting the
%                 boundary.

% Copyright (c) 08-13-2019,  Shawn W. Walker

% compute iteration function for running Newton's method to move points to
% exact bdy
Num_Charts = length(obj.Chart_Funcs);
Iter_Func = cell(Num_Charts,1);
%Iter_Func_ALT = cell(Num_Charts,1);
syms t real;
for ch = 1:Num_Charts
    alpha = obj.Chart_Funcs{ch};
    alpha_sym = alpha(t);
    alpha_sym_deriv = diff(alpha_sym,t);
    alpha_sym_deriv_2 = diff(alpha_sym_deriv,t);
    alpha_prime = matlabFunction(alpha_sym_deriv,'Vars',{t});
    alpha_pp = matlabFunction(alpha_sym_deriv_2,'Vars',{t});
    
    % goal: minimize distance: d(\xi) = (1/2) * |\alpha_{i}(\xi) - X_0|^2,
    %       where X_0 is the current bdy vertex position, \alpha_{i} is the
    %       local chart function.
    % E-L eqn: d'(\xi) = (\alpha_{i}(\xi) - X_0) \cdot \alpha_{i}'(\xi) = 0
    % To solve with Newton's method, we want to find a zero of f(\xi) := d'(\xi)
    % Newton's method:  \xi_{k+1} = \Theta(\xi_{k}), where
    %          \Theta(\xi) := \xi - \gamma*[ f(\xi) / f'(\xi) ], where
    %          f'(\xi) = (\alpha_{i}(\xi) - X_0) \cdot \alpha_{i}''(\xi) ...
    %                    + |\alpha_{i}'(\xi)|^2
    %          where \gamma > 0 is a "damping" factor
    gamma = 1.0;
    DEN = @(xi,X0) dot( ( alpha(xi) - X0 ), alpha_pp(xi) ) + dot(alpha_prime(xi),alpha_prime(xi));
    Iter_Func{ch} = @(xi,X0) xi - gamma*( dot( ( alpha(xi) - X0 ), alpha_prime(xi) )...
                                  / DEN(xi,X0) );
    %
    
%     % another goal: find good parameterization variable, i.e.
%     %         find zero:  f(\xi) = (\alpha_{i}(\xi) - X_0) \cdot T0, where
%     %         T0 is the tangent vector of the given bdy edge.
%     % Newton's method:  \xi_{k+1} = \Theta(\xi_{k}), where
%     %          \Theta(\xi) := \xi - [ f(\xi) / f'(\xi) ], where
%     %          f'(\xi) = \alpha_{i}'(\xi) \cdot T0.
%     Iter_Func_ALT{ch} = @(xi,X0,T0) xi - ( dot( ( alpha(xi) - X0 ), T0 )...
%                                   / dot( alpha_prime(xi), T0 ) );
end

% ensure the current bdy vertices are on the exact bdy
BdyVTX_1_Moved = Move_Pts_to_Bdy(obj,VTX(BdyEDGE(:,1),:),BdyChart_Ind,BdyChart_Var(:,1),Iter_Func);
BdyVTX_2_Moved = Move_Pts_to_Bdy(obj,VTX(BdyEDGE(:,2),:),BdyChart_Ind,BdyChart_Var(:,2),Iter_Func);
VTX(BdyEDGE(:,1),:) = BdyVTX_1_Moved;
VTX(BdyEDGE(:,2),:) = BdyVTX_2_Moved;

% now, we can uniformly refine
All_TRI = (1:1:size(TRI,1))';
[VTX_new, TRI_new, BdyEDGE_new] = Refine_Entire_Mesh(VTX,TRI,BdyEDGE,All_TRI);

% update the other Bdy info

% compute midpts of old bdy edges
BdyMidPts_old = (1/2) * ( VTX(BdyEDGE(:,1),:) + VTX(BdyEDGE(:,2),:) );

% identify new Bdy pts that are old midpts
max_X = max(BdyMidPts_old(:,1));
min_X = min(BdyMidPts_old(:,1));
max_Y = max(BdyMidPts_old(:,2));
min_Y = min(BdyMidPts_old(:,2));
BB = [min_X - 1, max_X + 1, min_Y - 1, max_Y + 1];
QT = mexQuadtree(BdyMidPts_old,BB);
BdyEDGE_new_tail = BdyEDGE_new(:,1);
BdyEDGE_new_head = BdyEDGE_new(:,2);
BdyVTX_new_tail = VTX_new(BdyEDGE_new_tail,:);
BdyVTX_new_head = VTX_new(BdyEDGE_new_head,:);
[MP_old_Ind_tail, Dist_tail] = QT.kNN_Search(BdyVTX_new_tail,1);
New_tail_mask = Dist_tail < 1e-12;
[MP_old_Ind_head, Dist_head] = QT.kNN_Search(BdyVTX_new_head,1);
New_head_mask = Dist_head < 1e-12;

Num_BdyEDGE_new = size(BdyEDGE_new,1);
New_BE_to_Old_BE = zeros(Num_BdyEDGE_new,1);
New_BE_to_Old_BE(New_tail_mask,1) = MP_old_Ind_tail(New_tail_mask,1);
New_BE_to_Old_BE(New_head_mask,1) = MP_old_Ind_head(New_head_mask,1);
if min(New_BE_to_Old_BE)==0
    error('This should not happen!');
end

% update
BdyChart_Ind_new = BdyChart_Ind(New_BE_to_Old_BE,1);
BdyChart_Var_new = BdyChart_Var(New_BE_to_Old_BE,:);
BdyChart_Var_Init = (1/2) * sum(BdyChart_Var_new,2);
% the parameterization variable still needs to be updated

BdyTRI_Ind_new = identify_bdy_triangles(TRI_new, BdyEDGE_new);

% move new bdy vertices to the exact bdy 
BdyVTX_1_Moved_new = Move_Pts_to_Bdy(obj,VTX_new(BdyEDGE_new(:,1),:),BdyChart_Ind_new,BdyChart_Var_Init,Iter_Func);
BdyVTX_2_Moved_new = Move_Pts_to_Bdy(obj,VTX_new(BdyEDGE_new(:,2),:),BdyChart_Ind_new,BdyChart_Var_Init,Iter_Func);
VTX_new(BdyEDGE_new(:,1),:) = BdyVTX_1_Moved_new;
VTX_new(BdyEDGE_new(:,2),:) = BdyVTX_2_Moved_new;

% finally, update the parameterization variable
Num_BdyEDGE_new = size(BdyEDGE_new,1);
X_TEMP = zeros(2*Num_BdyEDGE_new,2);
X_TEMP(1:2:end-1,:) = VTX_new(BdyEDGE_new(:,1),:);
X_TEMP(2:2:end,:) = VTX_new(BdyEDGE_new(:,2),:);
XC = mat2cell(X_TEMP,2*ones(1,Num_BdyEDGE_new),[2]);
Chart_Var_XC = obj.Get_Chart_Var_Ortho_Edge(VTX_new(BdyEDGE_new(:,1),:),VTX_new(BdyEDGE_new(:,2),:),...
                                            BdyChart_Ind_new,BdyChart_Var_new,XC,false);
%
% parse it
BdyChart_Var_new = 0*BdyChart_Var_new; % init
V_TEMP = cell2mat(Chart_Var_XC);
BdyChart_Var_new(:,1) = V_TEMP(1:2:end-1,1);
BdyChart_Var_new(:,2) = V_TEMP(2:2:end,1);

end

% function [BdyVTX_Ind, BV_Chart_Ind, BV_Chart_Var] = Get_BdyVTX_Info(BdyEDGE,BdyChart_Ind,BdyChart_Var)
% 
% %[BdyEDGE, BdyChart_Ind, BdyChart_Var]
% 
% BdyVTX_Ind = unique(BdyEDGE(:));
% BV_Chart_Ind = 0*BdyVTX_Ind;
% BV_Chart_Var = 0*BdyVTX_Ind;
% [TF1, LOC1] = ismember(BdyVTX_Ind,BdyEDGE(:,1));
% [TF2, LOC2] = ismember(BdyVTX_Ind,BdyEDGE(:,2));
% BV_Chart_Ind(TF1,1) = BdyChart_Ind(LOC1(TF1),1);
% BV_Chart_Ind(TF2,1) = BdyChart_Ind(LOC2(TF2),1);
% BV_Chart_Var(TF1,1) = BdyChart_Var(LOC1(TF1),1);
% BV_Chart_Var(TF2,1) = BdyChart_Var(LOC2(TF2),1);
% 
% end

function BdyTRI_Ind = identify_bdy_triangles(TRI,BdyEDGE)

% find the triangle indices of triangles that have an edge on bdy
BdyTRI_TF = ismember(TRI,unique(BdyEDGE(:)));
BT_sum = sum(BdyTRI_TF,2);
if (max(BT_sum)==3)
    error('One of the triangles has all sides on bdy!');
end
TRI_Sorted = sort(TRI,2);
BdyEDGE_Sorted = sort(BdyEDGE,2);
[TF1, LOC1] = ismember(BdyEDGE_Sorted,TRI_Sorted(:,1:2),'rows');
[TF2, LOC2] = ismember(BdyEDGE_Sorted,TRI_Sorted(:,2:3),'rows');
[TF3, LOC3] = ismember(BdyEDGE_Sorted,TRI_Sorted(:,[1 3]),'rows');
BdyTRI_Ind = 0*BdyEDGE_Sorted(:,1);
BdyTRI_Ind(TF1,1) = LOC1(TF1,1);
BdyTRI_Ind(TF2,1) = LOC2(TF2,1);
BdyTRI_Ind(TF3,1) = LOC3(TF3,1);

end

function X = Move_Pts_to_Bdy(obj,X_old,Chart_Ind,Chart_Var,Iter_Func)

X = 0*X_old;

% run Newton's method
TOL = 1e-14;
for ii = 1:size(X_old,1)
    Ch_Ind = Chart_Ind(ii,1);
    xi = Chart_Var(ii,1);
    Theta = Iter_Func{Ch_Ind};
    %disp(['Current Point: [', num2str(X_old(ii,1),'%1.5G'), ', ', num2str(X_old(ii,2),'%1.5G'), ']']);
    for kk = 1:50
        %xi
        old_xi = xi;
        xi = Theta(xi,X_old(ii,:));
        ERR_xi = abs(xi - old_xi);
        %ERR_xi
        if ERR_xi < TOL
            alpha = obj.Chart_Funcs{Ch_Ind};
            X(ii,:) = alpha(xi);
            %alpha
            %disp('Chart interval:');
            %obj.Chart_Domains(Ch_Ind,:)
            %disp(['Final Position: [', num2str(X(ii,1),'%1.5G'), ', ', num2str(X(ii,2),'%1.5G'), ']']);
            break;
        end
    end
    if ERR_xi >= TOL
        error('Newton''s method did not converge!');
    end
end

end

% function Chart_Var_new = get_good_param_var(BdyEDGE,VTX,Chart_Ind,Chart_Var,Iter_Func)
% % Get_Chart_Var_Ortho_Edge
% 
% % init
% Chart_Var_new = Chart_Var;
% 
% % compute midpts
% %X0 = (1/2) * ( VTX(BdyEDGE(:,1),:) + VTX(BdyEDGE(:,2),:) );
% % compute tangents
% T0 = VTX(BdyEDGE(:,2),:) - VTX(BdyEDGE(:,1),:);
% T0 = Normalize_Vector_Field(T0);
% 
% % run Newton's method
% TOL = 1e-14;
% for ll = 1:2
% for ii = 1:size(BdyEDGE,1)
%     Ch_Ind = Chart_Ind(ii,1);
%     xi = Chart_Var(ii,ll);
%     Theta = Iter_Func{Ch_Ind};
%     for kk = 1:50
%         old_xi = xi;
%         xi = Theta(xi,VTX(BdyEDGE(ii,ll),:),T0(ii,:));
%         ERR_xi = abs(xi - old_xi);
%         %ERR_xi
%         if ERR_xi < TOL
%             Chart_Var_new(ii,ll) = xi;
%             break;
%         end
%     end
%     if ERR_xi >= TOL
%         error('Newton''s method did not converge!');
%     end
% end
% end
% 
% end