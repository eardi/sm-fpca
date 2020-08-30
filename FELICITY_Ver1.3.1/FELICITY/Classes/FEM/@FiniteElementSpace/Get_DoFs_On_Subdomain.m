function DoFs = Get_DoFs_On_Subdomain(obj,Mesh,Given_SubName,ARG)
%Get_DoFs_On_Subdomain
%
%   This returns a list of Degree-of-Freedom (DoF) indices (of obj.DoFmap) that
%   are attached to the given subdomain.
%
%   DoFs = obj.Get_DoFs_On_Subdomain(Mesh,Given_SubName);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Given_SubName = (string) name of the mesh subdomain to get DoFs for.
%                   if Given_SubName = [], then this is the same as calling
%                   obj.Get_DoFs.
%   NOTE: Given_SubName can also be a cell array of strings, so you can
%         specify multiple sub-domains.
%
%   DoFs = is an (increasing) ordered array (length R) of unique DoF indices in
%          obj.DoFmap that are attached to the given subdomain.
%          Note: this is only for the 1st component of a tuple-valued space.
%
%   DoFs = obj.Get_DoFs_On_Subdomain(Mesh,Given_SubName,Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tuple
%          component specified by 'Comp', which is a row vector of length
%          1 or 2 depending on the tuple-size of the FE space.
%          Note: DoFs are shifted by the corresponding linear index version
%          of 'Comp'.
%
%   DoFs = obj.Get_DoFs_On_Subdomain(Mesh,Given_SubName,'all');
%
%   DoFs = similar to above, except DoFs is an RxC matrix, where C is the
%          *total* number of components in the tuple-valued space, and
%          column k = i + (j-1)*M, where (i,j) is the tuple index pair
%          into the (block) cartesian product FE space of tuple-size M x N.
%
%   Note: if none of the DoFs in obj.DoFmap lie on the given subdomain, then
%         this routine returns an empty matrix.

% Copyright (c) 03-26-2018,  Shawn W. Walker

obj.Verify_Mesh(Mesh);
if (nargin >= 4)
    Check_ARG(ARG);
end

if isempty(Given_SubName)
    if (nargin==3)
        ARG = [];
    end
    % just return all of the DoFs
    DoFs = obj.Get_DoFs(ARG);
    return;
end
if ischar(Given_SubName)
    Cell_Subname = {Given_SubName};
elseif ~iscell(Given_SubName)
    error('Given subdomain input argument should be a string, or a cell array of strings!');
else
    Cell_Subname = Given_SubName;
end

Num_Subname = length(Cell_Subname);
Cell_DoFs = cell(Num_Subname,1);
for si = 1:Num_Subname

% get subdomain embedding data for given subdomain relative to the global mesh
% (domain) that the DoFmap is defined on
if ~isempty(obj.Mesh_Info.SubName)
    
    Global_Mesh_For_DoFmap = Mesh.Get_Global_Subdomain(obj.Mesh_Info.SubName);
    warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId'); % temporarily disable!
    % create global mesh for DoFmap domain
    if (size(Global_Mesh_For_DoFmap,2)==1)
        error('Invalid subdomain mesh!');
    elseif (size(Global_Mesh_For_DoFmap,2)==2)
        DoFmap_Mesh = MeshInterval(Global_Mesh_For_DoFmap,Mesh.Points,'temp');
    elseif (size(Global_Mesh_For_DoFmap,2)==3)
        DoFmap_Mesh = MeshTriangle(Global_Mesh_For_DoFmap,Mesh.Points,'temp');
    elseif (size(Global_Mesh_For_DoFmap,2)==4)
        DoFmap_Mesh = MeshTetrahedron(Global_Mesh_For_DoFmap,Mesh.Points,'temp');
    else
        error('Dimension is not valid!');
    end
    warning('on', 'MATLAB:TriRep:PtsNotInTriWarnId');
    
    % embed the given subdomain as a subdomain of the DoFmap domain
    Global_Given_Subdomain = Mesh.Get_Global_Subdomain(Given_SubName);
    Given_Top_Dim = size(Global_Given_Subdomain,2) - 1;
    Dim_str = [num2str(Given_Top_Dim), 'D'];
    % note: any part of the given subdomain that is NOT contained in the 
    %       DoFmap domain will be ignored.
    
    % embed the given subdomain
    DoFmap_Mesh = DoFmap_Mesh.Append_Subdomain(Dim_str,'temp_sub',Global_Given_Subdomain);
    Subdomain = DoFmap_Mesh.Subdomain; % get the data
    
else % DoFmap is defined on the global mesh (this is easy)
    
    % get the subdomain data
    Given_Sub_Index = Mesh.Get_Subdomain_Index(Given_SubName);
    if (Given_Sub_Index == 0)
        error(['This subdomain does not exist: ', Given_SubName]);
    end
    Subdomain = Mesh.Subdomain(Given_Sub_Index);
    
end

if ~isempty(Subdomain.Data)
    % now extract the DoFs that are defined on the given subdomain
    Cell_DoFs{si} = obj.Get_DoFs_On_Subdomain_INTERNAL(Subdomain);
    if (nargin==3)
        ARG = [];
    end
    Cell_DoFs{si} = obj.Get_DoFs_INTERNAL(Cell_DoFs{si},ARG);
else
    Cell_DoFs{si} = []; % if the subdomain data is empty, then there are no DoFs!
end

end

% BEGIN: now concatenate everything, and make sure it is unique

% error check!
%nr = zeros(Num_Subname,1);
nc = zeros(Num_Subname,1);
for si = 1:Num_Subname
    %nr(si) = size(Cell_DoFs{si},1);
    nc(si) = size(Cell_DoFs{si},2);
end
if (min(nc)~=max(nc))
    disp('DoFs for different sub-domains do not have the same number of components!');
    error('This should not happen!');
end

% % this can be deleted...
% DoFs = [];
% for si = 1:Num_Subname
%     DoFs = [DoFs; Cell_DoFs{si}];
% end
DoFs = cell2mat(Cell_DoFs);
DoFs = unique(DoFs,'rows');

% END: now concatenate everything, and make sure it is unique

end