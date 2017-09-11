function obj = Set_Fixed_Subdomains(obj,Mesh,Fixed_Subdomain_Names,ARG)
%Set_Fixed_Subdomains
%
%   This sets several subdomain names (in a cell array) where the DoFs (of
%   obj.DoFmap) are considered *fixed*, i.e. this is where the DoFs are to be
%   set by some Dirichlet condition.
%   Note: this overwrites any previously stored fixed subdomain names.
%
%   obj = obj.Set_Fixed_Subdomains(Mesh,Fixed_Subdomain_Names);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Fixed_Subdomain_Names = cell array of (strings) names of mesh subdomains.
%
%   Output is an updated object.  If the space is tensor valued (more than one
%   component), then it is assumed that *all* components are fixed on those
%   subdomains.
%
%   obj = obj.Set_Fixed_Subdomains(Mesh,Fixed_Subdomain_Names,Comp);
%
%   Similar to above case, except 'Comp' specifies which component (in the
%   case of a tensor-valued space) to fix.  If Comp = [], then *all*
%   components are fixed.
%   Note: Comp may be an array of components, e.g. Comp = [1, 3], to fix
%   the first and third component in a tensor-valued space of dim=3.

% Copyright (c) 10-02-2015,  Shawn W. Walker

if (nargin==3)
    ARG = [];
end
if isempty(ARG)
    ARG = 'all'; % default to all components
end

if strcmpi(ARG,'all')
    % set the same subdomain name for all tensor components
    for ci = 1:obj.RefElem.Num_Comp
        obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,ci);
    end
else
    % just set it for individual component(s)
    Comp = ARG;
    if ~isnumeric(Comp)
        error('Given components "Comp" must be integers!');
    end
    for ci = 1:length(Comp)
        obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,Comp(ci));
    end
end

end