function display(obj)

Num_Obj = length(obj);

for oi=1:Num_Obj
    
    disp('------------------------------------------');
    disp(['GeometricElementFunction(', num2str(oi), '):']);
    disp('');
    
    display@GenericFiniteElementFunction(obj(oi));
    
    disp(['           Domain: a FELDomain:  ','']);
    disp('');
    obj(oi).Domain.display;
    disp('');
    disp(['              Opt: Struct Indicating Needed Geometric Quantities:     ','']);
    disp('');
    disp(obj(oi).Opt);
    disp('');
    disp(['         GeoTrans: Transformer Object (for computing quantites in Opt) ', '']);
    disp('');
    disp(obj(oi).GeoTrans);
    disp('');
    disp(['              CPP: C++ identifier names:  ','']);
    disp('');
    disp(obj(oi).CPP);
end

end