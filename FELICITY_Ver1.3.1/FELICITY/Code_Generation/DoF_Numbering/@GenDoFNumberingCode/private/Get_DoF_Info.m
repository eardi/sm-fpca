function DoF = Get_DoF_Info(Elem)
%Get_DoF_Info
%
%   Extract info about the DoF arrangement.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Domain                 = Get_Domain_Info(Elem);
Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

% get vertex DoF info
DoF.V.Num_Set          = 0;
DoF.V.Num_DoF          = 0;
DoF.V.Max_DoF_Per_Set  = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).V)
        DoF.V.Num_Set       = DoF.V.Num_Set + 1;
        Num_V_for_this_set  = size(Elem_Nodal_Top(nnt).V{ind},2);
        DoF.V.Num_DoF       = DoF.V.Num_DoF + Num_V_for_this_set;
        DoF.V.Max_DoF_Per_Set = max(DoF.V.Max_DoF_Per_Set,Num_V_for_this_set);
    end
end
if (DoF.V.Max_DoF_Per_Set==0)
    DoF.V.Num_Set = 0;
end

% get edge DoF info
DoF.E.Num_Set          = 0;
DoF.E.Num_DoF          = 0;
DoF.E.Max_DoF_Per_Set  = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        DoF.E.Num_Set       = DoF.E.Num_Set + 1;
        Num_E_for_this_set  = size(Elem_Nodal_Top(nnt).E{ind},2);
        DoF.E.Num_DoF       = DoF.E.Num_DoF + Num_E_for_this_set;
        DoF.E.Max_DoF_Per_Set = max(DoF.E.Max_DoF_Per_Set,Num_E_for_this_set);
    end
end
if (DoF.E.Max_DoF_Per_Set==0)
    DoF.E.Num_Set = 0;
end

% get face DoF info
DoF.F.Num_Set          = 0;
DoF.F.Num_DoF          = 0;
DoF.F.Max_DoF_Per_Set  = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        DoF.F.Num_Set       = DoF.F.Num_Set + 1;
        Num_F_for_this_set  = size(Elem_Nodal_Top(nnt).F{ind},2);
        %%%%%Num_F_for_this_set  = Get_Num_DoFs_On_Face(Elem,Elem_Nodal_Top(nnt).F{ind});
        DoF.F.Num_DoF       = DoF.F.Num_DoF + Num_F_for_this_set;
        DoF.F.Max_DoF_Per_Set = max(DoF.F.Max_DoF_Per_Set,Num_F_for_this_set);
    end
end
if (DoF.F.Max_DoF_Per_Set==0)
    DoF.F.Num_Set = 0;
end

% get tet DoF info
DoF.T.Num_Set          = 0;
DoF.T.Num_DoF          = 0;
DoF.T.Max_DoF_Per_Set  = 0;
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).T)
        DoF.T.Num_Set       = DoF.T.Num_Set + 1;
        Num_T_for_this_set  = size(Elem_Nodal_Top(nnt).T{ind},2);
        DoF.T.Num_DoF       = DoF.T.Num_DoF + Num_T_for_this_set;
        DoF.T.Max_DoF_Per_Set = max(DoF.T.Max_DoF_Per_Set,Num_T_for_this_set);
    end
end
if (DoF.T.Max_DoF_Per_Set==0)
    DoF.T.Num_Set = 0;
end

% compute the total number of DoF's per element
DoF.Total = 0;
DoF.Total = DoF.Total + DoF.V.Num_DoF * Domain.Num_Vtx;
DoF.Total = DoF.Total + DoF.E.Num_DoF * Domain.Num_Edge;
DoF.Total = DoF.Total + DoF.F.Num_DoF * Domain.Num_Face;
DoF.Total = DoF.Total + DoF.T.Num_DoF * Domain.Num_Tet;

% END %