function display(obj)

% get number
Num_Obj = length(obj);

for oi=1:Num_Obj
    
    disp('------------------------------------------');
    disp(['FELSymBasisCalc(',num2str(oi),')']);
    disp('');
    
    disp(['    Base_Func: Symbolic Function (no derivatives applied):       ','']);
    disp(obj(oi).Base_Func);
    disp(['   Deriv_Func: (Map container) Derivatives of Symbolic Function: ','']);
    disp(obj(oi).Deriv_Func);

    disp(['    Max_Deriv: Maximum Order of Derivative Computed  =  ',num2str(obj(oi).Max_Deriv)]);
    
    disp(['           Pt: Set of Points to Evaluate the Function    ','']);
    disp(['   Base_Value: Function Evaluations (no derivatives applied):       ','']);
    disp(obj(oi).Base_Value);
    disp(['  Deriv_Value: (Map container) Evaluations of Derivatives of Function: ','']);
    disp(obj(oi).Deriv_Value);
    if isempty(obj(oi).Orig_Vars)
        disp(['    Orig_Vars: Original Independent Variables of the Function: ','']);
        disp(obj(oi).Orig_Vars);
    end
    
end

end