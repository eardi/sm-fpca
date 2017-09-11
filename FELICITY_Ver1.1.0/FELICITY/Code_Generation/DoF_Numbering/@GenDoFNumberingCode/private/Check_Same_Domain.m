function SAME_DOMAIN = Check_Same_Domain(obj)
%Check_Same_Domain
%
%   This returns whether all of the elements are defined on the same domain.

% Copyright (c) 04-07-2010,  Shawn W. Walker

SAME_DOMAIN = true;
Num_Elem = length(obj.Elem);
for ind=2:Num_Elem
    if ~and(obj.Elem(1).Dim==obj.Elem(ind).Dim,strcmp(obj.Elem(1).Domain,obj.Elem(ind).Domain))
        SAME_DOMAIN = false;
        err = FELerror;
        err = err.Add_Comment(['All elements must be defined on the SAME Domain (simplex)!']);
        err = err.Add_Comment('For instance:');
        err = err.Add_Comment(['Name = ', obj.Elem(1).Name, '  |  ', 'Domain = ', obj.Elem(1).Domain]);
        err = err.Add_Comment('  and');
        err = err.Add_Comment(['Name = ', obj.Elem(ind).Name, '  |  ', 'Domain = ', obj.Elem(ind).Domain]);
        err = err.Add_Comment('are defined on different Domains!');
        err.Error;
        error('stop!');
    end
end

end