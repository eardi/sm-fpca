function display(obj)

disp(['             Elem: The Reference Finite Element:                 ','']);
disp(' ');
obj.Elem.display();
disp(' ');
disp(['        Func_Name: Name of Function                              ',' = ',obj.Func_Name]);
% disp(['              Opt: (Options) Struct of Quantities to Compute     ', '']);
% disp(obj.Opt);

if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['            DEBUG: Perform Debugging Checks                       =  ',DEBUG]);

end