function Integrand = Get_All_Matrix_Integrals(obj,Matrix_Name)
%Get_All_Matrix_Integrals
%
%   This returns the integrands (strings) that define the given matrix, and the
%   corresponding domains of integration (DoIs).

% Copyright (c) 06-18-2012,  Shawn W. Walker

Integrand.Str = [];
Integrand.Domain = [];
NUM = 0; % init
for ind = 1:length(obj.Integration)
    Domain = obj.Integration(ind).Domain;
    Mat_Set = obj.Integration(ind).Matrix;
    Mat_Set_Names = Mat_Set.keys;
    if ismember(Matrix_Name,Mat_Set_Names)
        NUM = NUM + 1;
        Integrand(NUM).Domain = Domain;
        Integrand(NUM).Str = Mat_Set(Matrix_Name).Integral_str;
    end
end

if (NUM==0)
    error(['ERROR: this matrix was not found: ', Matrix_Name]);
end

end