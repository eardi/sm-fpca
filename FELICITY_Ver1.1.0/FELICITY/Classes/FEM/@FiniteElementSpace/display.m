function display(obj)

% get number of finite element spaces
Num_FEM_Spaces = length(obj);

for oi=1:Num_FEM_Spaces

disp('------------------------------------------');
disp(['FiniteElementSpace(',num2str(oi),')']);
disp(' ');

disp(['            Name: Identifier                                =  ''',obj(oi).Name,'''']);
disp(['         RefElem: Reference Finite Element object:              ','']);
obj(oi).RefElem.display;
disp(['       Mesh_Info: Struct With Mesh Info For FE Space:           ','']);
disp(obj(oi).Mesh_Info);
if isempty(obj(oi).Mesh_Info.SubName)
    DOMAIN_NAME = obj(oi).Mesh_Info.Name;
else
    DOMAIN_NAME = obj(oi).Mesh_Info.SubName;
end
disp(['        ... so the finite element space is defined on ''', DOMAIN_NAME, '''.']);
disp(' ');
disp(['          DoFmap: Local-to-Global Element Map,          SIZE =  ',num2str(size(obj(oi).DoFmap)),'']);

disp(['           Fixed: Subdomains Where DoFs Are Fixed','']);
for ci = 1:obj.RefElem.Num_Comp
    Num_Fixed_Domain = length(obj(oi).Fixed(ci).Domain);
    if (Num_Fixed_Domain > 0)
        disp(['                     Component ', num2str(ci), ':  Number of Fixed Domains =  ',num2str(Num_Fixed_Domain),'']);
        disp( '                     DoFs are fixed on:');
        for di=1:Num_Fixed_Domain
            DOM_str = obj(oi).Fixed(ci).Domain{di};
            disp(['                    ', '''', DOM_str, '''']);
        end
    end
    disp(' ');
end

disp('------------------------------------------');
disp(' ');

end

end