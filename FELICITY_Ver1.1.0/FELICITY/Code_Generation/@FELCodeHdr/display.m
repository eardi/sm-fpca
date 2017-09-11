function display(obj)

Num_OBJ = length(obj);

for oi=1:Num_OBJ

disp('------------------------------------------');
disp(['FELCodeHdr(',num2str(oi),')']);
disp(obj(oi));
disp('------------------------------------------');
disp('');

end

end