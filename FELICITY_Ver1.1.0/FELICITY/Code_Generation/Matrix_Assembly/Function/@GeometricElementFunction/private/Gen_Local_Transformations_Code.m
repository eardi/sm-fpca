function status = Gen_Local_Transformations_Code(obj,fid,Geo_CODE,Local_Transformation_CPP)
%Gen_Local_Transformations_Code
%
%   This creates the necessary transformations for computing with or without
%   subdomains of Codim > 0.

% Copyright (c) 04-07-2010,  Shawn W. Walker

% write the ``main'' sub-routine (it calls other ones)
status = obj.Write_SUBRoutine_Compute_Local_Transformation(fid,Local_Transformation_CPP);

for map_i = 1:Local_Transformation_CPP.Num_Compute_Map
    status = obj.Write_SUBRoutine_Compute_Map(fid,Geo_CODE,Local_Transformation_CPP.Compute_Map(map_i));
end

end