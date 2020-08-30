function Verify_Multilinearity_Of_Form(obj,Int_Obj)
%Verify_Multilinearity_Of_Form
%
%   This checks the symbolic expression that defines the integrand of Int_Obj, and
%   verifies that it has the proper "form", i.e. the expression should define a proper
%   bilinear or linear form (as the case may be).
%
%   obj.Verify_Multilinearity_Of_Form(Int_Obj);
%
%   Int_Obj = a Level 1 Integral object.

% Copyright (c) 08-08-2013,  Shawn W. Walker

% store for later
Integrand_String = char(Int_Obj.Integrand);

Vars         = symvar(Int_Obj.Integrand);
VALID_TESTF  = check_linearity(Int_Obj.Integrand,Vars,Int_Obj.TestF);
VALID_TRIALF = check_linearity(Int_Obj.Integrand,Vars,Int_Obj.TrialF);

% both variables must be linear!
VALID = and(VALID_TESTF,VALID_TRIALF);

BILIN = isa(obj,'Bilinear');
LIN   = isa(obj,'Linear');
if (BILIN)
    
    if ~VALID
        err = FELerror;
        err = err.Add_Comment(['Cannot include the following integrand into the current Bilinear form.']);
        err = err.Add_Comment(['Integrand:  ', Integrand_String]);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['The integrand must have the following format:']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['   term #1  +  term #2  +  term #3  + ...']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['where each "term" includes a *product* of a single Test function with a single Trial function.']);
        err = err.Add_Comment(['Otherwise, the integrand is *not* a BILINEAR form!']);
        err.Error;
        error('stop!');
    end
    
elseif (LIN)
    
    if ~VALID
        err = FELerror;
        err = err.Add_Comment(['Cannot include the following integrand into the current Linear form.']);
        err = err.Add_Comment(['Integrand:  ', Integrand_String]);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['The integrand must have the following format:']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['   term #1  +  term #2  +  term #3  + ...']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['where each "term" includes a single occurrence of a Test function.']);
        err = err.Add_Comment(['Otherwise, the integrand is *not* a LINEAR form!']);
        err.Error;
        error('stop!');
    end
    
end

end

function VALID = check_linearity(Integrand,Vars,FUNC)

% store these
%Sym_Zero = sym('0');
Sym_One  = sym('1');
Sym_Two  = sym('2');

subs_H = FEL_subs_handle();

% replace FUNC function with the constant 1 and 2 to check linear scaling
if ~isempty(FUNC)
    
    % initialize
    Sym_Integrand_One = Integrand;
    Sym_Integrand_Two = Integrand;
    
    for vi = 1:length(Vars)
        MATCH = Var_Name_Matches_SymVar(FUNC,Vars(vi));
        if MATCH
            Sym_Integrand_One = subs_H(Sym_Integrand_One,Vars(vi),Sym_One);
            Sym_Integrand_Two = subs_H(Sym_Integrand_Two,Vars(vi),Sym_Two);
        end
    end
    
    % make sure it scales linearly
    DIFF = simplify(2*Sym_Integrand_One - Sym_Integrand_Two,10);
    
    % Note: if it is linear, then DIFF should be 0 (i.e. contains no symbolic variables).
    SV   = symvar(DIFF);
    if isempty(SV)
        VALID = (double(DIFF)==0); % should be zero if it is linear!
    else
        VALID = false; % DIFF must still contain some symbolic variables...
    end
else
    VALID = true;
end

end