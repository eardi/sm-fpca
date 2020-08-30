function Nodal_Sets_str = write_element_file_nodal_top_string(Nodal_Sets,TAB)
%write_element_file_nodal_top_string
%
%   This creates a string representing the sets of DoF indices.

% Copyright (c) 10-10-2016,  Shawn W. Walker

Nodal_Sets_str = []; % init
for ii = 1:length(Nodal_Sets)-1
    DoF_set = Nodal_Sets{ii};
    Nodal_Sets_str = write_one_set(DoF_set,TAB,Nodal_Sets_str);
    Nodal_Sets_str = [Nodal_Sets_str, ',...\n'];
end
DoF_set = Nodal_Sets{end};
Nodal_Sets_str = write_one_set(DoF_set,TAB,Nodal_Sets_str);
Nodal_Sets_str = [Nodal_Sets_str, '...'];

end

function DoF_set_string = write_one_set(DoF_set,TAB,DoF_set_string)

DoF_set_string = [DoF_set_string, TAB, '['];
for rr = 1:size(DoF_set,1)
    for cc = 1:size(DoF_set,2)-1
        DoF_set_string = [DoF_set_string, num2str(DoF_set(rr,cc)), ', '];
    end
    if (rr < size(DoF_set,1))
        DoF_set_string = [DoF_set_string, num2str(DoF_set(rr,end)), ';\n'];
        DoF_set_string = [DoF_set_string, TAB, ' '];
    else
        DoF_set_string = [DoF_set_string, num2str(DoF_set(rr,end)), ']'];
    end
end

end