function display(obj)

disp('------------------------------------------');
disp(['FELDomain Object:']);
disp('');

disp(['            Global: Info About The ''Global'' Mesh Domain:       ']);
disp('');
disp(obj.Global);
disp('');
disp(['         Subdomain: Info About The (Intermediate) Sub-Domain:       ']);
disp('');
disp(obj.Subdomain);
disp('');
disp(['Integration_Domain: Info About The Domain Of Integration:        ']);
disp('');
disp(obj.Integration_Domain);
disp('');

if obj.IS_CURVED
    IS_CURVED_str = 'TRUE';
else
    IS_CURVED_str = 'FALSE';
end

disp(['         IS_CURVED: (T/F) Indicates if Higher Order Mesh Is Used           ',' = ',IS_CURVED_str]);
disp(['          Num_Quad: Number of Quad Points To Use on Domain of Integration  ',' = ',num2str(obj.Num_Quad)]);

end