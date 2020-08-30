function status = test_Hdiv_Trans()
%test_Hdiv_Trans
%
%   Test code for FELICITY class.

% Copyright (c) 05-19-2016,  Shawn W. Walker

status = 0;

GM_test = Geometric_Trans('test',2,2,true);
FUNC1_test = Hdiv_Trans('test',GM_test);
% make sure all the fields are there!
if (min(isfield(FUNC1_test.vv,{'Orientation','Val','Div'}))==0)
    status = 1;
end

% check all cases!
% (GeoDim,TopDim)
for gg=2:3
    for tt=2:gg
        if ~valid_vv_struct(gg,tt,false)
            status = 1;
        end
        if ~valid_vv_struct(gg,tt,true)
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

function TF = valid_vv_struct(GeoDim,TopDim,LIN_MAP_TF)

TF = true; % init test result to passed

% define a map!
myMAP = Geometric_Trans('test',GeoDim,TopDim,LIN_MAP_TF);
myFUNC = Hdiv_Trans('test',myMAP);

% ensure that the symbolic variables have the correct size!
if ~(min(abs(size(myFUNC.vv.Orientation) - [1 1]))==0)
    TF = false;
end
if ~isempty(myFUNC.vv.Val)
    if ~(min(abs(size(myFUNC.vv.Val) - [GeoDim 1]))==0)
        TF = false;
    end
end
if ~isempty(myFUNC.vv.Div)
    if ~(min(abs(size(myFUNC.vv.Div) - [1 1]))==0)
        TF = false;
    end
end

% verify code generation!
%Func_vv( 1).Code = myFUNC.FUNC_Orientation_C_Code;
Func_vv( 1).Code = myFUNC.FUNC_Val_C_Code;
Func_vv( 2).Code = myFUNC.FUNC_Div_C_Code;
Func_vv( 3).Code = myFUNC.COEF_FUNC_Val_C_Code;
Func_vv( 4).Code = myFUNC.COEF_FUNC_Div_C_Code;
% load up reference data
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
DIR = fileparts(mfilename('fullpath'));
FN_str = ['Func_vv_Hdiv_Codes_', num2str(GeoDim), num2str(TopDim), '_', LM_str, '.mat'];
FullFile_string = fullfile(DIR, FN_str);
RefData = load(FullFile_string,'Func_vv');
%save(FullFile_string,'Func_vv');

% for ind = 1:4
%     Num_Lines = length(Func_vv(ind).Code);
%     for k = 1:Num_Lines
%         Func_vv(ind).Code(k).Var_Name
%         Func_vv(ind).Code(k).Constant
%         for jj = 1:length(Func_vv(ind).Code(k).Defn)
%             Func_vv(ind).Code(k).Defn(jj)
%         end
%         for jj = 1:length(Func_vv(ind).Code(k).Eval_Snip)
%             Func_vv(ind).Code(k).Eval_Snip(jj)
%         end
%     end
% end

% check against reference data
for ind=1:length(Func_vv(:))
    STRUCTS_MATCH = isequal(RefData.Func_vv(ind),Func_vv(ind));
    if ~STRUCTS_MATCH
        TF = false; % test failed!
        break;
    end
end

end