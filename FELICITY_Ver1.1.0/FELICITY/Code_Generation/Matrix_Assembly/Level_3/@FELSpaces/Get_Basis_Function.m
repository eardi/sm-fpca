function Func = Get_Basis_Function(obj,Space_Name,Func_Type_str,Given_Integration_Domain)
%Get_Basis_Function
%
%   This returns an object that is a function for FELICITY language.

% Copyright (c) 06-02-2012,  Shawn W. Walker

Int_Index = obj.Get_Integration_Index(Given_Integration_Domain);
GF = obj.Integration(Int_Index).BasisFunc(Space_Name).GeomFunc;

RefElem = obj.Space(Space_Name).Elem;
Func = FiniteElementBasisFunction(Space_Name,RefElem,Func_Type_str,GF);

end