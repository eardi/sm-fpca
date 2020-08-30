function obj = Get_Cut_Info(obj,Interp_Func)
%Get_Cut_Info
%
%    This finds all cut edges and cut points that are cut by the zero level set of a given
%    level set function.  Note: any vertex with level set value of EXACTLY zero is counted
%    as positive (i.e. the interior).
%
%    obj = obj.Get_Cut_Info(Interp_Func);
%
%    Interp_Func = function handle to interpolation routine.
%           The format of "Interp_Func" should be:
%                  [phi, grad_phi] = Interp_Func(point);
%                  where
%                  phi      = the level set function value
%                  grad_phi = the gradient of the level set function
%                  point    = array of point coordinate to evaluate at

% Copyright (c) 02-10-2018,  Shawn W. Walker

T0 = clock;
% evaluate the level set function at all vertices
obj.LS.value = Interp_Func(obj.bcc_mesh.V);

% evaluate SHORT edge end points by the level set function
Short_Edge_List_LS_Eval = 0*obj.bcc_mesh.edge.short;
Short_Edge_List_LS_Eval(:) = obj.LS.value(obj.bcc_mesh.edge.short(:),1);
Short_Edge_List_LS_Eval_SIGN = sign(Short_Edge_List_LS_Eval);
Zero_Mask = (Short_Edge_List_LS_Eval_SIGN==0);
Short_Edge_List_LS_Eval_SIGN(Zero_Mask) = 1; % make sign of 0 actually 1

% evaluate LONG edge end points by the level set function
Long_Edge_List_LS_Eval = 0*obj.bcc_mesh.edge.long;
Long_Edge_List_LS_Eval(:) = obj.LS.value(obj.bcc_mesh.edge.long(:),1);
Long_Edge_List_LS_Eval_SIGN = sign(Long_Edge_List_LS_Eval);
Zero_Mask = (Long_Edge_List_LS_Eval_SIGN==0);
Long_Edge_List_LS_Eval_SIGN(Zero_Mask) = 1; % make sign of 0 actually 1

% find cut edges
CUT_SHORT_MASK = (Short_Edge_List_LS_Eval_SIGN(:,1)~=Short_Edge_List_LS_Eval_SIGN(:,2));
CUT_LONG_MASK  = (Long_Edge_List_LS_Eval_SIGN(:,1)~=Long_Edge_List_LS_Eval_SIGN(:,2));

% find the subset of edges that are cut
obj.cut_info.short.edge_indices = find(CUT_SHORT_MASK);
obj.cut_info.long.edge_indices  = find(CUT_LONG_MASK);
se = obj.bcc_mesh.edge.short(obj.cut_info.short.edge_indices,:);
obj.cut_info.short.points = obj.Compute_Cut_Points(Interp_Func, obj.bcc_mesh.V(se(:,1),:), obj.bcc_mesh.V(se(:,2),:));
le = obj.bcc_mesh.edge.long(obj.cut_info.long.edge_indices,:);
obj.cut_info.long.points  = obj.Compute_Cut_Points(Interp_Func, obj.bcc_mesh.V(le(:,1),:), obj.bcc_mesh.V(le(:,2),:));
%%%%%%
T1 = clock;
disp(['Step (1) Timing: ', num2str(etime(T1,T0),'%2.5G'), ' sec']);

T0 = clock;
% get vertex-to-(cut)edge data struct
Num_Vtx = size(obj.bcc_mesh.V,1);
si = obj.cut_info.short.edge_indices;
si_local = (1:1:length(si))';
Short_Vtx_to_Cut_Edge = sparse(obj.bcc_mesh.edge.short(si,1), obj.bcc_mesh.edge.short(si,2), si_local, Num_Vtx, Num_Vtx);
Short_Vtx_to_Cut_Edge_TR = Short_Vtx_to_Cut_Edge';
obj.cut_info.short.V2E = Short_Vtx_to_Cut_Edge + Short_Vtx_to_Cut_Edge_TR; % do NOT save the sign of edge orientation!

li = obj.cut_info.long.edge_indices;
li_local = (1:1:length(li))';
Long_Vtx_to_Cut_Edge = sparse(obj.bcc_mesh.edge.long(li,1), obj.bcc_mesh.edge.long(li,2), li_local, Num_Vtx, Num_Vtx);
Long_Vtx_to_Cut_Edge_TR = Long_Vtx_to_Cut_Edge';
obj.cut_info.long.V2E = Long_Vtx_to_Cut_Edge + Long_Vtx_to_Cut_Edge_TR; % do NOT save the sign of edge orientation!
T1 = clock;
disp(['Step (2) Timing: ', num2str(etime(T1,T0),'%2.5G'), ' sec']);

end