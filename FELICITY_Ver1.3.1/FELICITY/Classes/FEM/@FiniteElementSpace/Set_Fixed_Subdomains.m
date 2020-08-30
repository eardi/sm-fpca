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
%   Output is an updated object.  If the space is tuple-valued (more than one
%   component), then it is assumed that *all* components are fixed on those
%   subdomains.
%
%   obj = obj.Set_Fixed_Subdomains(Mesh,Fixed_Subdomain_Names,Comp);
%
%   Similar to above case, except 'Comp' specifies which component (in the
%   case of a tuple-valued space) to fix.  I.e. Comp may be a 1x1 or 1x2
%   row vector.  If Comp = [], then *all* components are fixed.
%
%   Note: Comp may be a *cell array* of components, e.g.
%         Comp = {[3, 1], [2, 2]},
%         to fix the (3,1) and (2,2) tuple components of the tuple-valued
%         space.  Alternatively, if the FE space is M x 1, then Comp may be
%         a 1x1 vector, or a cell array of 1x1 vectors, e.g. Comp = {[3], [1]},
%         would fix the third and 1st component in a vector-valued FE space.

% Copyright (c) 03-24-2018,  Shawn W. Walker

if (nargin==3)
    ARG = [];
end
if isempty(ARG)
    ARG = 'all'; % default to all components
end

if strcmpi(ARG,'all')
    % set the same subdomain name for all tuple components
    for ci_1 = 1:obj.Num_Comp(1)
        for ci_2 = 1:obj.Num_Comp(2)
            obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,[ci_1, ci_2]);
        end
    end
else
    % just set it for individual tuple component(s)
    if iscell(ARG)
        % must be several components
        for cc = 1:length(ARG)
            Comp = ARG{cc};
            obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,Comp);
        end
    else
        % must be one component
        Comp = ARG;
        obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,Comp);
    end
end

end