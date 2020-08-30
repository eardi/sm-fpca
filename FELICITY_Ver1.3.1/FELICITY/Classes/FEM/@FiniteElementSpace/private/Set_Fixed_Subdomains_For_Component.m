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
%   Comp = component of tuple-valued space to fix (a 1x1 or 1x2 vector
%          depending on the tuple-size of the FE space).
%
%   Output is an updated object.

% Copyright (c) 03-24-2018,  Shawn W. Walker

Comp = obj.Process_Tuple_Component(Comp);

obj.Fixed(Comp(1),Comp(2)).Domain = {};

if ~iscell(Fixed_Subdomain_Names)
    error('Input must be a cell array of names!');
end
if ~isempty(Fixed_Subdomain_Names)
    if ~ischar(Fixed_Subdomain_Names{1})
        error('Entries of cell array must be strings!');
    end
end

% remove empty entries
Fixed_Subdomain_Names = Fixed_Subdomain_Names(~cellfun('isempty',Fixed_Subdomain_Names));

% sort the names
obj.Fixed(Comp(1),Comp(2)).Domain = sort(Fixed_Subdomain_Names);

obj.Verify_Mesh(Mesh);

end