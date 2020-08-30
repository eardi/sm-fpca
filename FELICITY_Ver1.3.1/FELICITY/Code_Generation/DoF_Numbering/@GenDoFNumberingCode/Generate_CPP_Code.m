function SUCCESS = Generate_CPP_Code(obj)
%Generate_CPP_Code
%
%   This generates a self-contained code for DoF allocation.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% init
disp('---------------------------------------------------------------');
disp('***Generate DoF Map Allocation C++ Code...');

% ensure that all elements have different names
obj.Check_Distinct_Names;
% ensure that they are all defined on the same domain
obj.Check_Same_Domain;

% clone standard files
obj.Clone_Standalone_Files;

% generate code for each element
Num_Elem = length(obj.Elem);
Elem_Alloc(Num_Elem).CPP_Data_Type_str = []; % init
for ind=1:Num_Elem
    Elem_Alloc(ind).CPP_Data_Type_str = obj.Gen_Specific_Elem_DoF_Allocator_cc(ind);
end

% generate the main file
status = obj.Gen_mexDoF_Allocator_cpp(Elem_Alloc);

SUCCESS = true;
disp('***Code Generation Complete...');
disp('---------------------------------------------------------------');

end