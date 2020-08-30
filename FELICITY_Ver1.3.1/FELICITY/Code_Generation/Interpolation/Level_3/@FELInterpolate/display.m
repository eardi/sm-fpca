function display(obj)

% get number of objects
Num_Obj = length(obj);

if Num_Obj > 1
    disp('Please specify a specific FELInterpolate.');
    return;
end

disp('------------------------------------------');
disp(['FELInterpolate:']);
disp('  ');
disp(['               Name: Name of Interpolation                         ',' = ',obj.Name]);
disp(['             Domain: Domain of Interpolation Expression            ','']);
disp(obj.Domain);
disp(['         Expression: Symbolic Expression                           ','']);
disp(obj.Expression);
disp(['      NumRow_SubINT: Number of Rows of Sub-Interpolation           ',' = ',num2str(obj.NumRow_SubINT)]);
disp(['      NumCol_SubINT: Number of Cols of Sub-Interpolation           ',' = ',num2str(obj.NumCol_SubINT)]);
disp(['             SubINT: Sub-struct With Info On Sub-Interpolations:   ','',]);

disp(' ');
disp(obj.SubINT);
disp(' ');

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