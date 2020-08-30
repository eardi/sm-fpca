function [FM, Matrix_Parsed] = Init_FELMatrices(obj,FS,Snippet_Dir)
%Init_FELMatrices
%
%   This inits the FELMatrices object.

% Copyright (c) 03-24-2017,  Shawn W. Walker

% init
FM = FELMatrices(FS,Snippet_Dir);

Num_Matrix = length(obj.MATS.Matrix_Data);
Matrix_Parsed(Num_Matrix).Integral = [];
for ind = 1:Num_Matrix
    FORM           = obj.MATS.Matrix_Data{ind};
    if ~isempty(FORM(1,1).Test_Space)
        Row_Space_Name = FORM.Test_Space.Name;
    else
        Row_Space_Name = ''; % i.e. the constant space
    end
    if ~isempty(FORM(1,1).Trial_Space)
        Col_Space_Name = FORM.Trial_Space.Name;
    else
        Col_Space_Name = ''; % i.e. the constant space
    end
    Matrix_Name = FORM(1,1).Name;
    
    if ~isa(FORM,'Real')
        ID = FORM.Integral;
        Num_Integrals = length(ID);
        Matrix_Parsed(ind).Integral = cell(Num_Integrals,1);
        for dd = 1:Num_Integrals
            Integration_Index = FM.Get_Integration_Index(ID(dd).Domain);
            Current_Integrand = ID(dd).Integrand;
            Integrand_str = char(Current_Integrand);
            Specific_Domain_Name = [Matrix_Name, '_', ID(dd).Domain.Name];
            
            % parse integrand
            [Parsed, Num_Nonzeros] = ID(dd).Parse_Integrand_With_Functions;
            % keep track of the integration domain index
            Parsed.Integration_Index = Integration_Index;
            % get number of sub-matrices
            Num_Sub_Matrices = Num_Nonzeros;
            Matrix_Parsed(ind).Integral{dd} = Parsed;
            
            if isa(FORM,'Bilinear')
                
                v = FS.Get_Basis_Function(Row_Space_Name,'Test',ID(dd).Domain);
                u = FS.Get_Basis_Function(Col_Space_Name,'Trial',ID(dd).Domain);
                v_str = ID(dd).TestF.Name;
                u_str = ID(dd).TrialF.Name;
                FM = FM.Append_FEM_Matrix(Row_Space_Name,Col_Space_Name,Matrix_Name,Specific_Domain_Name,...
                    Integration_Index,Integrand_str,Num_Sub_Matrices,v,u,v_str,u_str);
            elseif isa(FORM,'Linear')
                
                v = FS.Get_Basis_Function(Row_Space_Name,'Test',ID(dd).Domain);
                u = [];
                v_str = ID(dd).TestF.Name;
                u_str = '';
                FM = FM.Append_FEM_Matrix(Row_Space_Name,Col_Space_Name,Matrix_Name,Specific_Domain_Name,...
                    Integration_Index,Integrand_str,Num_Sub_Matrices,v,u,v_str,u_str);
            else
                error('Form type not valid!');
            end
        end
    else % it is Real
        
        % manually create Parsed structure
        [Parsed, Num_Nonzeros] = FORM.Parse_Integrals;
        Num_Integrals = length(Parsed);
        Matrix_Parsed(ind).Integral = cell(Num_Integrals,1);
        for pp = 1:Num_Integrals
            Integration_Index = FM.Get_Integration_Index(Parsed(pp).Domain{1,1});
            Integrand_str = char(Parsed(pp).Integrand_Sym(1,1));
            Specific_Domain_Name = [Matrix_Name, '_', Parsed(pp).Domain{1,1}.Name];
            
            % keep track of the integration domain index
            Parsed(pp).Integration_Index = Integration_Index;
            % get number of sub-matrices
            Num_Sub_Matrices = Num_Nonzeros(pp);
            Matrix_Parsed(ind).Integral{pp} = Parsed(pp);
            
            DEBUG = true;
            v = FiniteElementBasisFunction([],...
                ReferenceFiniteElement(constant_one(),DEBUG),'CONST',[]);
            u = FiniteElementBasisFunction([],...
                ReferenceFiniteElement(constant_one(),DEBUG),'CONST',[]);
            v_str = [Specific_Domain_Name, '_CONST_ROW_FUNC'];
            u_str = [Specific_Domain_Name, '_CONST_COL_FUNC'];
            Num_Row = size(FORM,1);
            Num_Col = size(FORM,2);
            FM = FM.Append_Real_Matrix(Matrix_Name,Specific_Domain_Name,Num_Row,Num_Col,...
                Integration_Index,Integrand_str,Num_Sub_Matrices,v,u,v_str,u_str);
        end
    end
end

end