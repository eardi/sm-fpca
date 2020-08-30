function Opt = set_struct_dependencies(obj,Opt)
%set_struct_dependencies
%
%   This does one pass through the dependency check.
%   Note that Opt is already initialized with some options.  This routine just updates
%   additional options if they are required to compute the initial options.
%   Note: this is only for defining dependencies between different *function* quantities.
%         this routine has nothing to do with which geometric information is needed;
%         see 'Update_Geometric_Options.m' instead.

% Copyright (c) 05-19-2016,  Shawn W. Walker

% if you want the gradient
if ~isempty(obj.f.Grad)
    if Opt.Grad
        if and((obj.GeoMap.TopDim==1),(obj.GeoMap.GeoDim > 1))
            % then you need the arc-length derivative
            Opt.d_ds = true;
        end
    end
elseif Opt.Grad
    error('Grad cannot be used in this context!');
end
%etc......
if ~isempty(obj.f.Hess)
    if Opt.Hess
        if and((obj.GeoMap.TopDim==1),(obj.GeoMap.GeoDim > 1))
            % then you need the 1st and 2nd arc-length derivatives
            Opt.d_ds   = true;
            Opt.d2_ds2 = true;
%         elseif and((obj.GeoMap.TopDim==2),(obj.GeoMap.GeoDim==3)) % domain is a surface
%             % do not need any other function evaluations
        end
    end
elseif Opt.Hess
    error('Hess cannot be used in this context!');
end
if ~isempty(obj.f.d2_ds2)
    if Opt.d2_ds2
        if (obj.GeoMap.TopDim~=1)
            error('Topological dimension must be 1!');
        end
        % then you need the arc-length 1st derivative
        Opt.d_ds = true;
    end
elseif Opt.d2_ds2
    error('d2_ds2 cannot be used in this context!');
end

% there are no other dependencies...

end