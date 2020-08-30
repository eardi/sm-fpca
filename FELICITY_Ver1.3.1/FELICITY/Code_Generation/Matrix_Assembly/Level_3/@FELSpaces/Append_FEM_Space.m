function obj = Append_FEM_Space(obj,Domain,Space_Name,Elem,Tuple_Size)
%Append_FEM_Space
%
%   This appends another finite element space (and basis function) to the
%   internal struct.

% Copyright (c) 03-24-2017,  Shawn W. Walker

if ~ischar(Space_Name)
    error('Space_Name must be a string!');
end
if ~isa(Elem,'ReferenceFiniteElement')
    error('Elem must be a ReferenceFiniteElement!');
end

% check that this space has not already been added
All_Space_Names = obj.Space.keys;
if ismember(Space_Name,All_Space_Names)
    disp(['FE Space ', Space_Name, ' already exists!']);
    error('Use more distinct names!');
end

SS          = Get_Space_Struct();
SS.Name     = Space_Name;
SS.Domain   = Domain;
SS.Elem     = Elem;
SS.Num_Comp = Tuple_Size;
obj.Space(SS.Name) = SS; % insert

% loop through all integration domains and append the corresponding basis
% function (when valid)
Num_Integrations = length(obj.Integration);
for ind = 1:Num_Integrations
    DoI_GF = obj.Integration(ind).DoI_Geom; % geometry representation for the domain of integration
    % make geometric function for basis function
    GeomFunc = Create_Valid_BasisFunc_GeomFunc(DoI_GF,SS);
    if ~isempty(GeomFunc)
        BF = FiniteElementBasisFunction(SS.Name,SS.Elem,'Basis',GeomFunc);
        obj.Integration(ind).BasisFunc(SS.Name) = BF; % insert!
    end
end

end