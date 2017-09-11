function q = Compute_Simplex_Quality(p,t,type)
%Compute_Simplex_Quality
%
%   This computes a quality measure for the simplices.
%
%   q = Compute_Simplex_Quality(p,t,type);
%
%   p = vertices of triangulation.
%   t = triangulation connectivity.
%   type == 1: Radius Ratio (default)
%   type == 2: Approximate
%
%   q = column vector of element qualities.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if nargin<3
  type=1;
end

Top_Dim = size(t,2)-1;
%Geo_Dim = size(p,2);

switch type
    case 1
        % RADIUS RATIO
        switch Top_Dim
            case 1
                q=ones(size(t,1),1);
            case 2
                a=sqrt(sum((p(t(:,2),:)-p(t(:,1),:)).^2,2));
                b=sqrt(sum((p(t(:,3),:)-p(t(:,1),:)).^2,2));
                c=sqrt(sum((p(t(:,3),:)-p(t(:,2),:)).^2,2));
                r=1/2*sqrt((b+c-a).*(c+a-b).*(a+b-c)./(a+b+c));
                R=a.*b.*c./sqrt((a+b+c).*(b+c-a).*(c+a-b).*(a+b-c));
                q=2*r./R;
            case 3
                d12=p(t(:,2),:)-p(t(:,1),:);
                d13=p(t(:,3),:)-p(t(:,1),:);
                d14=p(t(:,4),:)-p(t(:,1),:);
                d23=p(t(:,3),:)-p(t(:,2),:);
                d24=p(t(:,4),:)-p(t(:,2),:);
                d34=p(t(:,4),:)-p(t(:,3),:);
                v=abs(dot(cross(d12,d13,2),d14,2))/6;
                s1=sqrt(sum(cross(d12,d13,2).^2,2))/2;
                s2=sqrt(sum(cross(d12,d14,2).^2,2))/2;
                s3=sqrt(sum(cross(d13,d14,2).^2,2))/2;
                s4=sqrt(sum(cross(d23,d24,2).^2,2))/2;
                p1=sqrt(sum(d12.^2,2)).*sqrt(sum(d34.^2,2));
                p2=sqrt(sum(d23.^2,2)).*sqrt(sum(d14.^2,2));
                p3=sqrt(sum(d13.^2,2)).*sqrt(sum(d24.^2,2));
                q=216*v.^2./(s1+s2+s3+s4)./sqrt((p1+p2+p3).*(p1+p2-p3).* ...
                    (p1+p3-p2).*(p2+p3-p1));
            otherwise
                error('Dimension not implemented.');
        end
        
    case 2
        % APPROXIMATE FORMULA
        switch Top_Dim
            case 1
                q=ones(size(t,1),1);
            case 2
                d12=sum((p(t(:,2),:)-p(t(:,1),:)).^2,2);
                d13=sum((p(t(:,3),:)-p(t(:,1),:)).^2,2);
                d23=sum((p(t(:,3),:)-p(t(:,2),:)).^2,2);
                q=4*sqrt(3)*abs(simpvol(p,t))./(d12+d13+d23);
            case 3
                d12=sum((p(t(:,2),:)-p(t(:,1),:)).^2,2);
                d13=sum((p(t(:,3),:)-p(t(:,1),:)).^2,2);
                d14=sum((p(t(:,4),:)-p(t(:,1),:)).^2,2);
                d23=sum((p(t(:,3),:)-p(t(:,2),:)).^2,2);
                d24=sum((p(t(:,4),:)-p(t(:,2),:)).^2,2);
                d34=sum((p(t(:,4),:)-p(t(:,3),:)).^2,2);
                q=216*abs(simpvol(p,t))/sqrt(3)./(d12+d13+d14+d23+d24+d34).^(3/2);
            otherwise
                error('Dimension not implemented.');
        end
    otherwise
        error('Incorrect type.');
end

end