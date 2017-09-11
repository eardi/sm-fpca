function display(obj)

class_str = class(obj);

Num_OBJ = length(obj);

for ind=1:Num_OBJ
    disp('-----------------------------');
    disp([class_str, ' ', '(', num2str(ind), ')',':']);
    disp('-----------------------------');
    
    disp(['            Name: Identifier For The Mesh               =  ''',obj(ind).Name,'''']);
    
    disp(['               X: Vertex  Coordinates,             size = ', '[', num2str(size(obj(ind).X)), ']']);
    disp(['   Triangulation: Element Connectivity,            size = ', '[', num2str(size(obj(ind).Triangulation)), ']']);
    
    disp(['       Subdomain: Subdomains In The Mesh:','']);
    disp(' ');
    for si = 1:length(obj(ind).Subdomain)
        disp(obj(ind).Subdomain(si));
    end
    disp(' ');
end

end