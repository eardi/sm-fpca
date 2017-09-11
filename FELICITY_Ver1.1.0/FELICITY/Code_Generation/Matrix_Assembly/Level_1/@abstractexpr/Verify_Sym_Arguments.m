function status = Verify_Sym_Arguments(obj,Sym_Expression)
%Verify_Sym_Arguments
%
%   This verifies that the terms in the symbolic expression are either Test, Trial, Coef,
%   or recognized geometric functions (GeoFunc).
%
%   status = obj.Verify_Sym_Arguments(Sym_Expression);
%
%   status = 0, if routine completes successfully.

% Copyright (c) 01-23-2014,  Shawn W. Walker

vars = symvar(Sym_Expression);
num_vars = length(vars);
for ind = 1:num_vars
    var_str = char(vars(ind));
    VALID = obj.Check_Var_Name(var_str);
    if ~VALID
        err = FELerror;
        err = err.Add_Comment(['var_name := "', var_str , '" is not recognized!']);
        if isa(obj,'Integral')
            err = err.Add_Comment(['The given var_name does *not* match the following VALID Test, Trial,']);
            err = err.Add_Comment(['    Coef, or GeoFunc functions:']);
        elseif isa(obj,'Interpolate')
            err = err.Add_Comment(['The given var_name does *not* match the following VALID Coef,']);
            err = err.Add_Comment(['    or GeoFunc functions:']);
        else
            error('This should not happen!');
        end
        err = err.Add_Comment(' ');
        if ~isempty(obj.TestF)
            err = err.Add_Comment(['Test    Function:  ', obj.TestF.Name]);
        end
        if ~isempty(obj.TrialF)
            err = err.Add_Comment(['Trial   Function:  ', obj.TrialF.Name]);
        end
        for kk = 1:length(obj.CoefF)
            err = err.Add_Comment(['Coef    Function:  ', obj.CoefF(kk).Name]);
        end
        % display possible geometry functions that could be used
        GF1 = ['geom', obj.Domain.Name];
        err = err.Add_Comment(['GeoFunc Function:  ', GF1]);
        for kk = 1:length(obj.GeoF)
            err = err.Add_Comment(['GeoFunc Function:  ', obj.GeoF(kk).Name]);
        end
        err = err.Add_Comment(' ');
        if isa(obj,'Integral')
            err = err.Add_Comment(['Make sure you include a *valid* Test, Trial, Coef,']);
            err = err.Add_Comment(['     and/or GeoFunc function when defining this Integral!']);
        elseif isa(obj,'Interpolate')
            err = err.Add_Comment(['Make sure you include a *valid* Coef and/or GeoFunc function']);
            err = err.Add_Comment(['     when defining this Interpolate object!']);
        else
            error('This should not happen!');
        end
        err.Error;
        error('stop!');
    end
end

status = 0;

end