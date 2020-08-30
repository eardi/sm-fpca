function Embed = Get_Sub_DoI_Embedding_Data(obj)
%Get_Sub_DoI_Embedding_Data
%
%   This determines the kind of Subdomain/Domain of Integration (DoI)
%   information that is needed to represent the following containment:
%   DoI  \subset  Subdomain  \subset  Global.

% Copyright (c) 06-20-2012,  Shawn W. Walker

% Notes:
%
% Go through all of the cases (TD = Topological Dimension):
%
% Case: Global_TD = Sub_TD = DoI_TD
%
% For each ``element'' of the DoI, we need the corresponding Global Cell Index
% and/or the Subdomain Cell Index (if the Subdomain is different from the Domain
% of Integration (DoI) and the Global domain).  If all three Domains are the
% *same*, then we require nothing.
%
% Case: Global_TD = Sub_TD > DoI_TD
%
% For each ``element'' of the DoI, we need the corresponding Global Cell Index
% and/or the Subdomain Cell Index (if the Subdomain is different from the Global
% domain) that the DoI element is embedded in.  In addition, we need the DoI
% Entity Index to specify the local topological entity of the Global/Subdomain
% Cell that represents the DoI element.
%
% Case: Global_TD > Sub_TD = DoI_TD
%
% For each ``element'' of the DoI, we need the corresponding Global Cell Index
% that the DoI element is embedded in.  In addition, we need the
% Subdomain Entity Index to specify the local topological entity of the
% Global Cell that represents the DoI element.  We also need the Subdomain Cell
% Index that corresponds to the DoI element (unless the Subdomain = DoI).
%
% Case: Global_TD > Sub_TD > DoI_TD; (i.e. 3 > 2 > 1  is the only case in 3-D)
%
% For each ``element'' of the DoI, we need the Subdomain ``Cell'' (Index) that
% contains the DoI element.  Likewise, we need the Global Cell (Index) that
% contains the aforementioned Subdomain ``Cell''.  In addition, we need the
% Subdomain Entity Index to specify the local topological entity of the Global
% Cell that represents the Subdomain ``Cell''.  We also need the
% DoI Entity Index to specify the local topological entity of the Subdomain Cell
% that represents the DoI element.

Embed = Get_Sub_DoI_Embedding_Struct; % init all fields to false

Global_EQUAL_Sub = isequal(obj.Global,obj.Subdomain);
Sub_EQUAL_DoI    = isequal(obj.Subdomain,obj.Integration_Domain);

% determine which cell indices are needed, and what domains are equal
if and(Global_EQUAL_Sub,Sub_EQUAL_DoI)
    % if Global = Subdomain = DoI, then we don't need anything!
    Embed.Global_Cell_Index       = false;
    Embed.Subdomain_Cell_Index    = false;
    % Note: the generated code will set:
    %       Global_Cell_Index = Subdomain_Cell_Index = local DoI index
    Embed.Global_Equal_Subdomain  = true;
    Embed.Subdomain_Equal_DoI     = true;
    
elseif and(Global_EQUAL_Sub,~Sub_EQUAL_DoI)
    % if Global = Subdomain, then we just need the Global_Cell_Index
    Embed.Global_Cell_Index      = true;
    Embed.Subdomain_Cell_Index   = false;
    % Note: the generated code will set Subdomain_Cell_Index=Global_Cell_Index
    Embed.Global_Equal_Subdomain = true;
    Embed.Subdomain_Equal_DoI    = false;
    
elseif and(~Global_EQUAL_Sub,Sub_EQUAL_DoI)
    % if Subdomain = DoI, then we just need the Global_Cell_Index
    Embed.Global_Cell_Index      = true;
    Embed.Subdomain_Cell_Index   = false;
    % Note: the generated code will set Subdomain_Cell_Index=local DoI index
    Embed.Global_Equal_Subdomain = false;
    Embed.Subdomain_Equal_DoI    = true;
    
else% and(~Global_EQUAL_Sub,~Sub_EQUAL_DoI)
    % if none of the domains are equal, then we need both Cell indices
    Embed.Global_Cell_Index      = true;
    Embed.Subdomain_Cell_Index   = true;
    Embed.Global_Equal_Subdomain = false;
    Embed.Subdomain_Equal_DoI    = false;
end

% topological dimensions
Global_TD = obj.Global.Top_Dim;
Sub_TD    = obj.Subdomain.Top_Dim;
DoI_TD    = obj.Integration_Domain.Top_Dim;

% determine topological indices needed
if (Sub_TD > DoI_TD)
    Embed.DoI_Entity_Index       = true;
end
if (Global_TD > Sub_TD)
    Embed.Subdomain_Entity_Index = true;
end

end