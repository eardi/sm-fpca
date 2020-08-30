function display(obj)

% get number of parametric domains
Num_GE_Spaces = length(obj);

for oi=1:Num_GE_Spaces

disp('------------------------------------------');
disp(['ParametricMesh_2D(',num2str(oi),')']);
disp(' ');
disp(['            Name: Identifier                                =  ''',obj(oi).Name,'''']);
disp(['   Chart_Domains: Domains (intervals) of each chart            ','']);
disp(['     Chart_Funcs: cell array of chart function handles         ','']);
disp(['                  All the Charts:                              ','']);
Num_Charts = length(obj(oi).Chart_Funcs);
for jj = 1:Num_Charts
    Dom_STR = ['[', num2str(obj(oi).Chart_Domains(jj,1)), ', ', num2str(obj(oi).Chart_Domains(jj,2)), ']'];
    Func_STR = func2str(obj(oi).Chart_Funcs{jj});
    disp(['                  ', '( ', Dom_STR, ', ', Func_STR, ' )']);
end
disp([' ']);
disp(['         Corners: coordinates of corner vertices:           ','']);
for jj = 1:size(obj(oi).Corners,1)
    Cx_STR = num2str(obj(oi).Corners(jj,1));
    Cy_STR = num2str(obj(oi).Corners(jj,2));
    disp(['                  ', '( ', Cx_STR, ', ', Cy_STR, ' )']);
end
disp('------------------------------------------');
disp(' ');

end

end