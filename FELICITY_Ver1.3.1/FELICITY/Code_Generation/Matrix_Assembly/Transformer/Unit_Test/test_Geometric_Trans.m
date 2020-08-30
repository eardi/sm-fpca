function status = test_Geometric_Trans()
%test_Geometric_Trans
%
%   Test code for FELICITY class.

% Copyright (c) 05-19-2016,  Shawn W. Walker

status = 0;

MAP1_test = Geometric_Trans('test',3,3,true);
% make sure all the fields are there!
if (min(isfield(MAP1_test.PHI,{'Mesh_Size','Val','Grad','Metric','Det_Metric','Inv_Det_Metric','Inv_Metric',...
                     'Det_Jacobian','Det_Jacobian_with_quad_weight','Inv_Det_Jacobian','Inv_Grad',...
                     'Tangent_Vector','Normal_Vector','Tangent_Space_Projection',...
                     'Hess','Hess_Inv_Map','Grad_Metric','Grad_Inv_Metric',...
                     'Second_Fund_Form','Det_Second_Fund_Form','Inv_Det_Second_Fund_Form',...
                     'Total_Curvature_Vector','Total_Curvature','Gauss_Curvature','Shape_Operator'}))==0)
    status = 1;
end

% check all cases!
% (GeoDim,TopDim)
for gg=1:3
    for tt=1:gg
        if ~valid_PHI_struct(gg,tt,false);
            status = 1;
        end
        if ~valid_PHI_struct(gg,tt,true);
            status = 1;
        end
    end
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end

function TF = valid_PHI_struct(GeoDim,TopDim,LIN_MAP_TF)

TF = true; % init test result to passed

% define a map!
myMAP = Geometric_Trans('test',GeoDim,TopDim,LIN_MAP_TF);

% ensure that the symbolic variables have the correct size!
if ~(min(abs(size(myMAP.PHI.Mesh_Size) - [1 1]))==0)
    TF = false;
end
if ~(min(abs(size(myMAP.PHI.Val) - [GeoDim 1]))==0)
    TF = false;
end
if ~(min(abs(size(myMAP.PHI.Grad) - [GeoDim TopDim]))==0)
    TF = false;
end
if ~isempty(myMAP.PHI.Metric)
    if ~(min(abs(size(myMAP.PHI.Metric) - [TopDim TopDim]))==0)
        TF = false;
    end
    if ~(min(abs(size(myMAP.PHI.Det_Metric) - [1 1]))==0)
        TF = false;
    end
    if ~(min(abs(size(myMAP.PHI.Inv_Det_Metric) - [1 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Inv_Metric)
    if ~(min(abs(size(myMAP.PHI.Inv_Metric) - [TopDim TopDim]))==0)
        TF = false;
    end
end
if ~(min(abs(size(myMAP.PHI.Det_Jacobian) - [1 1]))==0)
    TF = false;
end
if ~(min(abs(size(myMAP.PHI.Det_Jacobian_with_quad_weight) - [1 1]))==0)
    TF = false;
end
if ~(min(abs(size(myMAP.PHI.Inv_Det_Jacobian) - [1 1]))==0)
    TF = false;
end
if ~isempty(myMAP.PHI.Inv_Grad)
    if ~(min(abs(size(myMAP.PHI.Inv_Grad) - [TopDim TopDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Tangent_Vector)
    if ~(min(abs(size(myMAP.PHI.Tangent_Vector) - [GeoDim 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Normal_Vector)
    if ~(min(abs(size(myMAP.PHI.Normal_Vector) - [GeoDim 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Tangent_Space_Projection)
    if ~(min(abs(size(myMAP.PHI.Tangent_Space_Projection) - [GeoDim GeoDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Hess)
    [T1, T2, GD] = size(myMAP.PHI.Hess);
    SizeHess = [T1, T2, GD];
    if ~(min(abs(SizeHess - [TopDim TopDim GeoDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Hess_Inv_Map)
    [T1, T2, GD] = size(myMAP.PHI.Hess_Inv_Map);
    SizeHessInv = [T1, T2, GD];
    if ~(min(abs(SizeHessInv - [TopDim TopDim GeoDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Grad_Metric)
    [T1, T2, GD] = size(myMAP.PHI.Grad_Metric);
    SizeGradMet = [T1, T2, GD];
    if ~(min(abs(SizeGradMet - [TopDim TopDim GeoDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Grad_Inv_Metric)
    [T1, T2, GD] = size(myMAP.PHI.Grad_Inv_Metric);
    SizeGradInvMet = [T1, T2, GD];
    if ~(min(abs(SizeGradInvMet - [TopDim TopDim GeoDim]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Second_Fund_Form)
    if ~(min(abs(size(myMAP.PHI.Second_Fund_Form) - [TopDim TopDim]))==0)
        TF = false;
    end
    if ~(min(abs(size(myMAP.PHI.Det_Second_Fund_Form) - [1 1]))==0)
        TF = false;
    end
    if ~(min(abs(size(myMAP.PHI.Inv_Det_Second_Fund_Form) - [1 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Total_Curvature_Vector)
    if ~(min(abs(size(myMAP.PHI.Total_Curvature_Vector) - [GeoDim 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Total_Curvature)
    if ~(min(abs(size(myMAP.PHI.Total_Curvature) - [1 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Gauss_Curvature)
    if ~(min(abs(size(myMAP.PHI.Gauss_Curvature) - [1 1]))==0)
        TF = false;
    end
end
if ~isempty(myMAP.PHI.Shape_Operator)
    if ~(min(abs(size(myMAP.PHI.Shape_Operator) - [GeoDim GeoDim]))==0)
        TF = false;
    end
end

% verify code generation!
NB = 3; % check against the use of 3 basis functions!
Map_PHI( 1).Code = myMAP.PHI_Mesh_Size_C_Code(NB);
Map_PHI( 2).Code = myMAP.PHI_Val_C_Code(NB);
Map_PHI( 3).Code = myMAP.PHI_Grad_C_Code(NB);
Map_PHI( 4).Code = myMAP.PHI_Metric_C_Code;
Map_PHI( 5).Code = myMAP.PHI_Det_Metric_C_Code;
Map_PHI( 6).Code = myMAP.PHI_Inv_Det_Metric_C_Code;
Map_PHI( 7).Code = myMAP.PHI_Inv_Metric_C_Code;
Map_PHI( 8).Code = myMAP.PHI_Det_Jac_C_Code;
Map_PHI( 9).Code = myMAP.PHI_Det_Jac_w_Weight_C_Code;
Map_PHI(10).Code = myMAP.PHI_Inv_Det_Jac_C_Code;
Map_PHI(11).Code = myMAP.PHI_Inv_Grad_C_Code;
Map_PHI(12).Code = myMAP.PHI_Tangent_Vector_C_Code;
Map_PHI(13).Code = myMAP.PHI_Normal_Vector_C_Code;
Map_PHI(14).Code = myMAP.PHI_Tan_Space_Proj_C_Code;
Map_PHI(15).Code = myMAP.PHI_Hess_C_Code(NB);
Map_PHI(16).Code = myMAP.PHI_Hess_Inv_Map_C_Code;
Map_PHI(17).Code = myMAP.PHI_Grad_Metric_C_Code;
Map_PHI(18).Code = myMAP.PHI_Grad_Inv_Metric_C_Code;
Map_PHI(19).Code = myMAP.PHI_2nd_Fund_Form_C_Code;
Map_PHI(20).Code = myMAP.PHI_Det_2nd_Fund_Form_C_Code;
Map_PHI(21).Code = myMAP.PHI_Inv_Det_2nd_Fund_Form_C_Code;
Map_PHI(22).Code = myMAP.PHI_Total_Curvature_Vector_C_Code;
Map_PHI(23).Code = myMAP.PHI_Total_Curvature_C_Code;
Map_PHI(24).Code = myMAP.PHI_Gauss_Curvature_C_Code;
Map_PHI(25).Code = myMAP.PHI_Shape_Operator_C_Code;

% disp('-----------------------------------------------');
% GeoDim
% TopDim
% LIN_MAP_TF
% Code1 = myMAP.PHI_Grad_Inv_Metric_C_Code;
% if ~isempty(Code1)
%     display_code_snippet(Code1);
% end

% load up reference data
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
DIR = fileparts(mfilename('fullpath'));
FN_str = ['Map_PHI_Codes_', num2str(GeoDim), num2str(TopDim), '_', LM_str, '_NumBasis_', num2str(NB), '.mat'];
FullFile_string = fullfile(DIR, FN_str);
RefData = load(FullFile_string,'Map_PHI');

% check against reference data
for ind=1:length(Map_PHI(:))
    STRUCTS_MATCH = isequal(RefData.Map_PHI(ind),Map_PHI(ind));
    if ~STRUCTS_MATCH
        TF = false; % test failed!
        
        disp('RefData:');
        display_code_snippet(RefData.Map_PHI(ind).Code);
        disp('Actual:');
        display_code_snippet(Map_PHI(ind).Code);
        
        break;
    end
end

end

function display_code_snippet(Code)

Code.Var_Name(1)
Code.Constant
disp('Definition:');
for ii = 1:length(Code.Defn)
    disp(Code.Defn(ii).line);
end
disp(' ');
disp('Evaluation:');
for ii = 1:length(Code.Eval_Snip)
    disp(Code.Eval_Snip(ii).line);
end

end