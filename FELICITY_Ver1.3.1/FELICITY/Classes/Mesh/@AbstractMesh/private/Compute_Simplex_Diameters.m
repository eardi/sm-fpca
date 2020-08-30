function D = Compute_Simplex_Diameters(p,t)
%Compute_Simplex_Diameters
%
%   This computes the diamters of the mesh elements.
%
%   D = Compute_Simplex_Diameters(p,t);
%
%   p = vertices of triangulation.
%   t = triangulation connectivity.
%
%   D: Mx1 column vector, where each row contains the diameter of a
%      single element in the mesh.

% Copyright (c) 08-29-2016,  Shawn W. Walker

Top_Dim = size(t,2)-1;
%Geo_Dim = size(p,2);

switch Top_Dim
    case 1
        X2_X1 = p(t(:,2),:) - p(t(:,1),:);
        norm_X2_X1 = sqrt(sum(X2_X1.^2,2)); % length of edge
        D = norm_X2_X1;
    case 2
        % compute edges
        X2_X1 = p(t(:,2),:) - p(t(:,1),:);
        X3_X1 = p(t(:,3),:) - p(t(:,1),:);
        X3_X2 = p(t(:,3),:) - p(t(:,2),:);
        % length of edges
        norm_X2_X1 = sqrt(sum(X2_X1.^2,2));
        norm_X3_X1 = sqrt(sum(X3_X1.^2,2));
        norm_X3_X2 = sqrt(sum(X3_X2.^2,2));
        TEMP = [norm_X2_X1, norm_X3_X1, norm_X3_X2];
        [D, Ind] = max(TEMP,[],2);
    case 3
        % compute edges
        e_1 = p(t(:,2),:) - p(t(:,1),:);
        e_2 = p(t(:,3),:) - p(t(:,1),:);
        e_3 = p(t(:,4),:) - p(t(:,1),:);
        e_4 = p(t(:,3),:) - p(t(:,2),:);
        e_5 = p(t(:,4),:) - p(t(:,3),:);
        e_6 = p(t(:,2),:) - p(t(:,4),:);
        % length of edges
        norm_e1 = sqrt(sum(e_1.^2,2));
        norm_e2 = sqrt(sum(e_2.^2,2));
        norm_e3 = sqrt(sum(e_3.^2,2));
        norm_e4 = sqrt(sum(e_4.^2,2));
        norm_e5 = sqrt(sum(e_5.^2,2));
        norm_e6 = sqrt(sum(e_6.^2,2));
        TEMP = [norm_e1, norm_e2, norm_e3, norm_e4, norm_e5, norm_e6];
        [D, Ind] = max(TEMP,[],2);
    otherwise
        error('Dimension not implemented.');
end

end