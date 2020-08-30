function d=dist_circle(p,xc,yc,r)

%   analytic formula for the oriented distance function of a circle
%   Note: negative inside.

d=sqrt((p(:,1)-xc).^2+(p(:,2)-yc).^2)-r;
