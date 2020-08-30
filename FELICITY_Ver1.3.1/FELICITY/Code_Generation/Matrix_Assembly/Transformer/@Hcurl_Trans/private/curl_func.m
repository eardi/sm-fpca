function obj = curl_func(obj)
%curl_func
%
%   Get the curl of the vector function, i.e. \nabla \times vv.

% Copyright (c) 10-17-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

if (GD==1)
    error('H(curl) functions do not exist in 1-D!');
elseif (GD==2)
    if (TD==2)
        % the curl is a scalar in the plane
        obj.vv.Curl = sym('vv_Curl');
    else
        error('H(curl) functions do not exist on 1-D curves!');
    end
elseif (GD==3)
    if (TD==1)
        error('H(curl) functions do not exist on 1-D curves!');
    elseif (TD==2)
        error('Not implemented!');
    elseif (TD==3)
        % the curl is a vector in \R^3
        obj.vv.Curl = sym('vv_Curl_%d', [GD, 1]);
    else
        error('Invalid or not implemented!');
    end
else
    error('Invalid or not implemented!');
end

end