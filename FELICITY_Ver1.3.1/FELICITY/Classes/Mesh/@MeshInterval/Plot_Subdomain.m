function Plot_Handle = Plot_Subdomain(obj,ARG)
%Plot_Subdomain
%
%   This plots a subdomain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain(SubName);
%
%   SubName = (string) name of subdomain to plot in the sub-field:
%             obj.Subdomain(:).
%
%   Plot_Handle = obj.Plot_Subdomain(SubIndex);
%
%   SubIndex = positive integer index into the sub-field:
%              obj.Subdomain(SubIndex).

% Copyright (c) 08-19-2009,  Shawn W. Walker

if ischar(ARG)
    Sub_Index = obj.Get_Subdomain_Index(ARG);
    if (Sub_Index <= 0)
        disp(['This subdomain was not found: ''', ARG, '''']);
        error('Check that your subdomain exists!');
    end
else
    Sub_Index = ARG;
    if (Sub_Index <= 0)
        error('Sub_Index must be positive!');
    end
end

Plot_Handle = obj.plot_subdomain_with_index(Sub_Index);

end