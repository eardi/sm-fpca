function v = Compute_Simplex_Vol(p,t)
%Compute_Simplex_Vol
%
%   This computes the volume of simplices in the given mesh.  The volume is
%   signed if the geometric dimension = topological dimension.
%
%   v = Compute_Simplex_Vol(p,t);
%
%   p = vertices of triangulation.
%   t = triangulation connectivity.
%
%   v = column vector of element volumes.

% Copyright (c) 04-13-2011,  Shawn W. Walker

Top_Dim = size(t,2)-1;
Geo_Dim = size(p,2);

switch Top_Dim
    case 1 % edge segment
        d12 = p(t(:,2),:)-p(t(:,1),:);
        if (Geo_Dim > 1)
            v = sqrt(sum(d12.^2,2));
        else
            v = d12;
        end

    case 2 % triangle
        d12=p(t(:,2),:)-p(t(:,1),:);
        d13=p(t(:,3),:)-p(t(:,1),:);
        if (Geo_Dim > 2)
            v = sqrt(sum(cross(d12,d13,2).^2,2))/2;
        else
            v = (d12(:,1).*d13(:,2)-d12(:,2).*d13(:,1))/2;
        end
        
    case 3 % tetrahedron
        d12=p(t(:,2),:)-p(t(:,1),:);
        d13=p(t(:,3),:)-p(t(:,1),:);
        d14=p(t(:,4),:)-p(t(:,1),:);
        v=dot(cross(d12,d13,2),d14,2)/6;

    otherwise
        disp('Warning: computing volumes of 4-D meshes!');
        v=zeros(size(t,1),1);
        for ii=1:size(t,1)
            A=zeros(size(p,2)+1);
            A(:,1)=1;
            for jj=1:size(p,2)+1
                A(jj,2:end)=p(t(ii,jj),:);
            end
            v(ii)=det(A);
        end
        v=v/factorial(size(p,2));
end

end