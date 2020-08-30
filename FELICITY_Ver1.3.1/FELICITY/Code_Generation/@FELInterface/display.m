function display(obj)

% get number of objects
Num_OBJ = length(obj);

for oi=1:Num_OBJ

disp('------------------------------------------');
disp(['FELInterface(',num2str(oi),')']);
disp('');

disp(['        Main_Dir: main directory to look for stuff =  ''',obj(oi).Main_Dir,'''']);

disp('------------------------------------------');
disp('');

end

end