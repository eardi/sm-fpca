function obj = Set_Fixed_Subdomains_For_Component(obj,Mesh,Fixed_Subdomain_Names,Comp)
%Set_Fixed_Subdomains_For_Component
%
%   This sets several subdomain names (in a cell array) where the DoFs (of
%   obj.DoFmap) are considered *fixed*, i.e. this is where the DoFs are to be
%   set by some Dirichlet condition for a particular component.
%   Note: this overwrites any previously stored fixed subdomain names.
%
%   obj = obj.Set_Fixed_Subdomains_For_Component(Mesh,Fixed_Subdomain_Names,Comp);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Fixed_Subdomain_Names = cell array of (strings) names of mesh subdomains to
%                           record.
%   Comp = component of tensor-valued space to fix.
%
%   Output is an updated object.

% Copyright (c) 09-07-2012,  Shawn W. Walker

if (Comp > obj.RefElem.Num_Comp)
    error('Component index is too large!');
end

obj.Fixed(Comp).Domain = {};

if ~iscell(Fixed_Subdomain_Names)
    error('Input must be a cell array of names!');
end
if ~isempty(Fixed_Subdomain_Names)
    if ~ischar(Fixed_Subdomain_Names{1})
        error('Entries of cell array must be strings!');
    end
end

% sort the names
obj.Fixed(Comp).Domain = sort(Fixed_Subdomain_Names);

obj.Verify_Mesh(Mesh);

end