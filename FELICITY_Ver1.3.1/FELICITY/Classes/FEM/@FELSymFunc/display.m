function display(obj)

% get number
Num_Obj = length(obj);

for oi=1:Num_Obj
    
    disp('------------------------------------------');
    disp(['FELSymFunc(',num2str(oi),')']);
    disp('');
    
    disp(['         Func: Symbolic Function:     ','']);
    disp(obj(oi).Func);
    disp(['         Vars: Independent Variables:   ','']);
    disp(obj(oi).Vars);
    
end

end