function Plot_Handle = plot_subdomain_with_index(obj,Sub_Index)
%plot_subdomain_with_index
%
%   This plots a subdomain of the global mesh.
%
%   Plot_Handle = obj.plot_subdomain_with_index(Sub_Index);
%
%   Sub_Index = positive integer index into the sub-field:
%               obj.Subdomain(SubIndex).

% Copyright (c) 08-19-2009,  Shawn W. Walker

if (Sub_Index <= 0)
    error('Subdomain Index must be positive!');
end
if (Sub_Index > length(obj.Subdomain))
    error('Subdomain Index is greater than the number of subdomains!');
end

if (obj.Subdomain(Sub_Index).Dim==0)
    Plot_Handle = obj.Plot_Subdomain_0D(obj.Subdomain(Sub_Index));
elseif (obj.Subdomain(Sub_Index).Dim==1)
    Plot_Handle = obj.Plot_Subdomain_1D(obj.Subdomain(Sub_Index));
else
    error('Subdomain dimension is not valid!  Must be 0 or 1 for MeshInterval.');
end

end