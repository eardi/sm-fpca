function status = Verify_Consistent_Function_Domains(obj)
%Verify_Consistent_Function_Domains
%
%   This checks that all functions (Test, Trial, and Coef(s)) stored in this object are
%   suitably defined on the domain of evaluation.
%
%   status = obj.Verify_Consistent_Function_Domains;
%
%   status = 0, if routine completes successfully.

% Copyright (c) 05-25-2012,  Shawn W. Walker

status = 0;

verify_func_domain(obj.TestF, obj.Domain);
verify_func_domain(obj.TrialF,obj.Domain);
verify_func_domain(obj.CoefF, obj.Domain);

end

function verify_func_domain(FUNC, Eval_Domain)

% make sure that one of two possible states is true:
% (1) the function is from a finite element space that is defined on the
%     domain of evaluation.
% OR
% (2) the function is from a finite element space AND is *restricted* to the
%     domain of evaluation.

Int_Domain_Name = Eval_Domain.Name;
for ind = 1:length(FUNC)
    
    FUNC_Domain_of_Defn = FUNC(ind).Get_Domain_Of_Definition;
    if ~strcmp(Int_Domain_Name,FUNC_Domain_of_Defn.Name)
        err = FELerror;
        err = err.Add_Comment(['The function ', FUNC(ind).Name, ' is defined on the domain: ', FUNC_Domain_of_Defn.Name]);
        err = err.Add_Comment(['The domain of evaluation is: ', Int_Domain_Name]);
        err = err.Add_Comment('Suggestion: when defining the function, specify the subdomain you want to evaluate it on.');
        err = err.Add_Comment(['   example: ', FUNC(ind).Name, ' = ', class(FUNC(ind)),...
                               '(', FUNC(ind).Element.Name, ',', Int_Domain_Name, ');']);
        err = err.Add_Comment('All functions in the *expression* must be defined on the domain of evaluation!');
        err.Error;
        error('stop!');
    end
    
end

end