function CPP = Determine_CPP_Info(obj)
%Determine_CPP_Info
%
%   This determines the CPP code names for the specific Domain_Class.

% Copyright (c) 02-29-2012,  Shawn W. Walker

CPP.Name = [obj.Subdomain.Name, '_embedded_in_', obj.Global.Name, '_restricted_to_', obj.Integration_Domain.Name];
CPP.Identifier_Name    = ['Domain_', CPP.Name];
CPP.Data_Type_Name     = ['CLASS_', CPP.Identifier_Name];
CPP.Data_Type_Name_cc  = [CPP.Data_Type_Name, '.cc'];

end