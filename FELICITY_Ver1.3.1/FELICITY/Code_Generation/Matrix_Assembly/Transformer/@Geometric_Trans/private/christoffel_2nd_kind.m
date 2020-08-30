function obj = christoffel_2nd_kind(obj)
%christoffel_2nd_kind
%
%   Get the Christoffel symbols of the 2nd kind: \Gamma^k_{i,j} (symmetric
%   in (i,j)).

% Copyright (c) 04-03-2018,  Shawn W. Walker

num_row = size(obj.PHI.Metric,1);
num_col = size(obj.PHI.Metric,2);

if ~isempty(obj.PHI.Metric)
    if (num_row==num_col)
        if (num_row==1) % curve in 2-D or 3-D
            % not needed in this case
            obj.PHI.Christoffel_2nd_Kind = [];
        elseif (num_row==2) % surface in 3-D
            % this is really where we need it!
            obj.PHI.Christoffel_2nd_Kind(2,2,2) = sym('0'); % init
%             obj.PHI.Christoffel_2nd_Kind(:,:,1) = sym('[PHI_Christoffel_2nd_Kind_1_11, PHI_Christoffel_2nd_Kind_1_12; PHI_Christoffel_2nd_Kind_1_21, PHI_Christoffel_2nd_Kind_1_22]');
%             obj.PHI.Christoffel_2nd_Kind(:,:,2) = sym('[PHI_Christoffel_2nd_Kind_2_11, PHI_Christoffel_2nd_Kind_2_12; PHI_Christoffel_2nd_Kind_2_21, PHI_Christoffel_2nd_Kind_2_22]');
            obj.PHI.Christoffel_2nd_Kind(:,:,1) = sym('PHI_Christoffel_2nd_Kind_1_%d%d',[2 2]);
            obj.PHI.Christoffel_2nd_Kind(:,:,2) = sym('PHI_Christoffel_2nd_Kind_2_%d%d',[2 2]);
        elseif (obj.GeoDim==3)
            % not needed in this case...
            obj.PHI.Christoffel_2nd_Kind = [];
        else
            error('Not implemented!');
        end
    else
        error('Metric matrix must be square!');
    end
else
    obj.PHI.Christoffel_2nd_Kind = [];
end

end