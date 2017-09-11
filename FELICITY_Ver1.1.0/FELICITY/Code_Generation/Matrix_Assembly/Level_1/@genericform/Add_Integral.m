function obj = Add_Integral(obj,Int_Obj)
%Add_Integral
%
%   This adds an Integral object to the genericform object.
%
%   obj = obj.Add_Integral(Int_Obj);
%
%   Int_Obj = a Level 1 Integral object.

% Copyright (c) 05-25-2012,  Shawn W. Walker

if or(size(obj,1) > 1,size(obj,2) > 1)
    disp('This object is an array!');
    error('You must index the object you want!');
end
if ~isa(Int_Obj,'Integral')
    error('Input must be an Integral object!');
end

% check that the Test, and/or Trial functions match the Test and Trial spaces.
check_test_trial_space(obj.Test_Space,Int_Obj.TestF,'Test',Int_Obj.Integrand);
check_test_trial_space(obj.Trial_Space,Int_Obj.TrialF,'Trial',Int_Obj.Integrand);

obj.Verify_Multilinearity_Of_Form(Int_Obj);

[obj, SUCCESS] = obj.Try_To_Combine_Integrals(Int_Obj);

if ~SUCCESS
    % add in the integral
    Num_Int = length(obj.Integral);
    if (Num_Int==0)
        obj.Integral = Int_Obj;
    else
        obj.Integral(Num_Int+1) = Int_Obj;
    end
end

end

function check_test_trial_space(Space,FUNC,FUNC_str,Integrand)

err = FELerror;
if isempty(Space)
    if ~isempty(FUNC)
        err = err.Add_Comment(['Form does not have a ', FUNC_str, ' space defined.']);
        err = err.Add_Comment(['The problem is with this function: ', FUNC.Name]);
        err = err.Add_Comment(['There should be *no* ', FUNC_str, ' function in the Integral''s integrand:']);
        err = err.Add_Comment(['      ', char(Integrand)]);
        err.Error;
        error('stop!');
    end
else
    if isempty(FUNC)
        err = err.Add_Comment(['Form has a ', FUNC_str, ' space defined: ', Space.Name]);
        err = err.Add_Comment(['There is *no* ', FUNC_str, ' function in the Integral''s integrand:']);
        err = err.Add_Comment(['      ', char(Integrand)]);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['The integrand *must* have a ', FUNC_str, ' function in it!']);
        err.Error;
        error('stop!');
    else
        if ~isequal(Space,FUNC.Element)
            err = err.Add_Comment(['The form''s ', FUNC_str, ' space does not match the ', FUNC_str, ' function''s space.']);
            err = err.Add_Comment(['The problem is either with this function: ', FUNC.Name]);
            err = err.Add_Comment(['                   OR with this space: ', Space.Name]);
            err = err.Add_Comment(['Check that you have the correct ', FUNC_str, ' function and/or space!']);
            err.Error;
            error('stop!');
        end
    end
end

end