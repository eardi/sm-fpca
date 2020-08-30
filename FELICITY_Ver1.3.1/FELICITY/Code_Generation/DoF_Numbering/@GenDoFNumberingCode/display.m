function display(obj)

% get number of objects
Num_Obj = length(obj);

for oi=1:Num_Obj

disp('------------------------------------------');
disp(['GenDoFNumberingCode(',num2str(oi),')']);
disp('');

disp(['        Output_Dir: Directory Location of Generated Code           ','']);
disp(['                +-----> ',obj(oi).Output_Dir,'']);
disp(['          Main_Dir: Directory Location of THIS Class''s Code        ','']);
disp(['                +-----> ',obj(oi).Main_Dir,'']);
disp(['      Skeleton_Dir: Directory Location of Important Code Snippets  ','']);
disp(['                +-----> ',obj(oi).Skeleton_Dir,'']);
disp(['              Elem: Finite Element Information                   ','Num-Fields: ',num2str(length(fieldnames(obj(oi).Elem)))]);
disp(['            String: Struct of Generic Text Strings               ','Num-Fields: ',num2str(length(fieldnames(obj(oi).String)))]);
disp(obj(oi).String);

% disp(['    BEGIN_Auto_Gen: string   =   ',obj(oi).BEGIN_Auto_Gen]);
% disp(['      END_Auto_Gen: string   =   ',obj(oi).END_Auto_Gen]);
% disp(['              ENDL: carriage return string = ',obj(oi).ENDL]);

if obj(oi).DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['             DEBUG: Perform Debugging Checks                 =  ',DEBUG]);

disp('');
disp('------------------------------------------');
disp('');

end

end