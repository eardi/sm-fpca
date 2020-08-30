function status = test_H1_Trans()
%test_H1_Trans
%
%   Test code for FELICITY class.

% Copyright (c) 05-19-2016,  Shawn W. Walker

status = 0;

GM_test = Geometric_Trans('test',1,1,true);
FUNC1_test = H1_Trans('test',GM_test);
% make sure all the fields are there!
if (min(isfield(FUNC1_test.f,{'Val','Grad','d_ds','Hess','d2_ds2'}))==0)
    status = 1;
end

% check all cases!
% (GeoDim,TopDim)
for gg=1:3
    for tt=1:gg
        if ~valid_f_struct(gg,tt,false)
            status = 1;
        end
        if ~valid_f_struct(gg,tt,true)
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

function TF = valid_f_struct(GeoDim,TopDim,LIN_MAP_TF)

TF = true; % init test result to passed

% define a map!
myMAP = Geometric_Trans('test',GeoDim,TopDim,LIN_MAP_TF);
myFUNC = H1_Trans('test',myMAP);

% ensure that the symbolic variables have the correct size!
if ~(min(abs(size(myFUNC.f.Val) - [1 1]))==0)
    TF = false;
end
if ~(min(abs(size(myFUNC.f.Grad) - [1 GeoDim]))==0)
    TF = false;
end
if ~isempty(myFUNC.f.d_ds)
    if ~(min(abs(size(myFUNC.f.d_ds) - [1 1]))==0)
        TF = false;
    end
end
if ~(min(abs(size(myFUNC.f.Hess) - [GeoDim GeoDim]))==0)
    TF = false;
end
if ~isempty(myFUNC.f.d2_ds2)
    if ~(min(abs(size(myFUNC.f.d2_ds2) - [1 1]))==0)
        TF = false;
    end
end

% verify code generation!
Func_f( 1).Code = myFUNC.FUNC_Val_C_Code;
Func_f( 2).Code = myFUNC.FUNC_Val_special_C_Code;
Func_f( 3).Code = myFUNC.FUNC_d2_ds2_C_Code;
Func_f( 4).Code = myFUNC.FUNC_d_ds_C_Code;
Func_f( 5).Code = myFUNC.FUNC_Grad_C_Code;
Func_f( 6).Code = myFUNC.FUNC_Hess_C_Code;
Func_f( 7).Code = myFUNC.COEF_FUNC_Val_C_Code;
Func_f( 8).Code = myFUNC.COEF_FUNC_d2_ds2_C_Code;
Func_f( 9).Code = myFUNC.COEF_FUNC_d_ds_C_Code;
Func_f(10).Code = myFUNC.COEF_FUNC_Grad_C_Code;
Func_f(11).Code = myFUNC.COEF_FUNC_Hess_C_Code;

% load up reference data
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
DIR = fileparts(mfilename('fullpath'));
FN_str = ['Func_f_Codes_', num2str(GeoDim), num2str(TopDim), '_', LM_str, '.mat'];
FullFile_string = fullfile(DIR, FN_str);
RefData = load(FullFile_string,'Func_f');
%save(FullFile_string,'Func_f');

% check against reference data
for ind=1:length(Func_f(:))
    STRUCTS_MATCH = isequal(RefData.Func_f(ind),Func_f(ind));
    if ~STRUCTS_MATCH
        TF = false; % test failed!
        
        disp('RefData:');
        LIN_MAP_TF
        display_code_snippet(RefData.Func_f(ind).Code);
        disp('Actual:');
        LIN_MAP_TF
        display_code_snippet(Func_f(ind).Code);
        
        break;
    end
end

end

function display_code_snippet(Code)

Code.Var_Name(1)
Code.Constant
for ii = 1:length(Code.Defn)
    disp(Code.Defn(ii).line);
end
for ii = 1:length(Code.Eval_Snip)
    disp(Code.Eval_Snip(ii).line);
end

end