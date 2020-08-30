function Geo_Opt = Update_Geometric_Options(obj,Func_Opt,Geo_Opt)
%Update_Geometric_Options
%
%   This updates the given geometric function based on what the function options are for
%   this type of transformation.

% Copyright (c) 03-22-2018,  Shawn W. Walker

if (length(obj) > 1)
    error('This only operates on a *single* object.');
end

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

if Func_Opt.Val
    if (TD==2)
        if or(GD==2,GD==3)
            Geo_Opt.Inv_Det_Jacobian = true;
            Geo_Opt.Grad             = true;
        else
            error('Invalid!');
        end
    else
        error('not implemented!');
        Geo_Opt.Inv_Grad = true;
    end
end

% if Func_Opt.Div
%     if (TD==2)
%         if or(GD==2,GD==3)
%             Geo_Opt.Inv_Det_Jacobian = true;
%         else
%             error('Invalid!');
%         end
%     else
%         Geo_Opt.Inv_Grad = true;
%     end
% end

% Not needed!
% % Note: H(div) elements need to know the local facet orientation.
% %       Thus, we modify the struct to include that info.
% if Func_Opt.Orientation
%     Geo_Opt.Orientation = true;
% end

end