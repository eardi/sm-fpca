function [obj, GEOM, BF, CF] =...
                  Convert_Integrands_To_Tab_Tensor_Routine(obj,SubMatrices,GEOM,BF,CF)
%Convert_Integrands_To_Tab_Tensor_Routine
%
%   This converts the symbolic integrand into a Tabulate_Tensor subroutine.
%   Note: this is done for *all* sub-matrices of the (block) FE matrix.

% Copyright (c) 06-10-2016,  Shawn W. Walker

Num_SubMatrices = length(SubMatrices);
% count the number of sub-matrices to be computed from scratch
Num_NonCopies = 0; % init
NonCopy_Sub_Index = []; % init
for ii = 1:Num_SubMatrices
    if isempty(SubMatrices(ii).COPY_SubMAT) % i.e. do not copy
        Num_NonCopies = Num_NonCopies + 1;
        NonCopy_Sub_Index(Num_NonCopies,1) = SubMatrices(ii).Sub_Ind;
    end
end

% prepare the "vector" symbolic expression for computing from scratch
Vector_Sym_Integrand = sym(zeros(Num_NonCopies,1));
for ii = 1:Num_NonCopies
    % get the next sub-matrix to compute
    SM = SubMatrices(NonCopy_Sub_Index(ii));
    % concatenate:
    Vector_Sym_Integrand(ii) = SM.Sym_Integrand;
end

% generate the code snippet
[GEOM, BF, CF, Ccode_Frag] = ...
    Convert_Symbolic_Expression_To_CPP_snippet(obj,Vector_Sym_Integrand,GEOM,BF,CF);

% you always need the quad weighted jacobian for the intrinsic geometry
GEOM.DoI_Geom.Opt.Det_Jacobian_with_quad_weight = true;

Num_Ccode = length(Ccode_Frag);
if (Num_NonCopies==1)
    % change the standard variable that matlab uses for the final output
    Ccode_Frag(Num_Ccode).line = regexprep(Ccode_Frag(Num_Ccode).line, 't0', 'integrand_0');
else % there is more than one entry to compute
    for jj = 1:Num_NonCopies
        % MATLAB uses a different variable in this case
        % change the standard variable that matlab uses for the final output
        c_index_str = num2str(jj-1);
        Sub_Mat_index_str = num2str(NonCopy_Sub_Index(jj)-1);
        STR1 = ['A0\[', c_index_str, '\]\[0\]'];
        STR2 = ['integrand_', Sub_Mat_index_str];
        Ccode_Frag(Num_Ccode - Num_NonCopies + jj).line =...
            regexprep(Ccode_Frag(Num_Ccode - Num_NonCopies + jj).line, STR1, STR2);
    end
end

% create a "double" data type for each line
for line_ind = 1:Num_Ccode
    Ccode_Frag(line_ind).line = ['const double', Ccode_Frag(line_ind).line];
end

obj = obj.Store_SubMatrix_Info(SubMatrices,GEOM.DoI_Geom,BF,Ccode_Frag);
% store the order of the sub-matrix computations
obj.SubMAT_Computation_Order = NonCopy_Sub_Index;
obj = obj.Gen_Tab_Tensor_snippet(GEOM.DoI_Geom,BF,Ccode_Frag);

end