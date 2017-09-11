function display(obj)

% get number of objects
Num_Obj = length(obj);

if Num_Obj > 1
    disp('Please specify a specific FELMatrix.');
    return;
end

disp('------------------------------------------');
disp(['FELMatrix:']);
disp('  ');
disp(['               Name: Name of Matrix                                ',' = ',obj.Name]);
disp(['       Integral_str: String Describing Integral                    ',' = ',obj.Integral_str]);
disp(['         Num_SubMAT: Number of Sub-Matrices                        ',' = ',num2str(obj.Num_SubMAT)]);
disp(['             SubMAT: Sub-struct With Info On Sub-Matrices:          ','',]);

disp(' ');
disp(obj.SubMAT);
disp(' ');

disp(['           row_func: ROW FiniteElementFunction                     ','']);
disp(['           col_func: COL FiniteElementFunction                     ','']);
disp([' row_constant_space: ROW FiniteElementFunction                     ','']);
disp([' col_constant_space: COL FiniteElementFunction                     ','']);
disp(['        Snippet_Dir: Directory To Store Code Snippets              ',' = ',obj.Snippet_Dir]);

if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['              DEBUG: Perform Debugging Checks                        =  ',DEBUG]);

disp(' ');
disp('------------------------------------------');
disp(' ');

end