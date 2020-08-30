function display(obj)

oi=1;
disp(['      Skeleton_Dir: Directory Location of Repository Code        ','']);
disp(['                +-----> ',obj(oi).Skeleton_Dir,'']);
disp(['        Output_Dir: Directory Location of Generated Code         ','']);
disp(['                +-----> ',obj(oi).Output_Dir,'']);
disp(['           Sub_Dir: Sub-Directories For Generated Code           ','']);
disp(['                +-----> ',obj(oi).Sub_Dir,'']);
disp(['             Param: Various Parameters                           ','Num-Fields: ',num2str(length(fieldnames(obj(oi).Param)))]);

disp(['    BEGIN_Auto_Gen: string   =   ',obj(oi).BEGIN_Auto_Gen]);
disp(['      END_Auto_Gen: string   =   ',obj(oi).END_Auto_Gen]);

if obj(oi).DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['             DEBUG: Perform Debugging Checks                 =  ',DEBUG]);

end