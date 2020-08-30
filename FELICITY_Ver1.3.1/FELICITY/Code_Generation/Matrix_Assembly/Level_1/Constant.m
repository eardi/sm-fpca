function CC = Constant(Domain_of_Constant,varargin)
%Constant
%
%   This is used in the FELICITY DSL for matrix assembly and interpolation.
%   It returns a Coef function defined on a global constant FE space.
%
%   CC = Constant(Domain_of_Constant,Num_Comp);
%
%   inputs:
%   Domain_of_Constant = Level 1 Domain object (i.e. the domain of
%                        integration, or domain of expression).
%   Num_Comp = length of the *constant* column vector, i.e. if Num_Comp is
%              3, then this creates a Coef function with 3 components,
%              where each component is a global constant on the Domain.
%
%   outputs:
%   CC = Level 1 Coef object.  The "Element" that this belongs to is:
%            Element(Domain_of_Constant,constant_one,Num_Comp);
%
%   Note: when using CC in a FE form, you must use the command:  CC.val.
%
%   Other use cases:
%
%   CC = Constant(Domain_of_Constant,Num_Row,Num_Col);
%
%   Similar to previous usage, except the constant is a *matrix*, with size
%   given by Num_Row x Num_Col.
%   Note: CC = Level 1 Coef object.  The "Element" that this belongs to is:
%            Element(Domain_of_Constant,constant_one,Num_Row,Num_Col);
%
%   CC = Constant(Domain_of_Constant,[Num_Row, Num_Col]);
%
%   Same as previous, but different call procedure.

% Copyright (c) 03-29-2018,  Shawn W. Walker

if (nargin==0)
    disp('Not enough input arguments!');
    error('Use the ''help Constant'' command!');
end

if (nargin==1)
    Num_Row = 1; % default to one component
    Num_Col = 1; % default to one component
elseif (nargin==2)
    ARG = varargin{1};
    if (length(ARG)==1)
        % default to column vector
        Num_Row = ARG;
        Num_Col = 1;
    else
        Num_Row = ARG(1);
        Num_Col = ARG(2);
    end
else
    Num_Row = varargin{1};
    Num_Col = varargin{2};
end

% make sure we record the domain name
Domain_Name = inputname(1);
Domain_of_Constant.Name = Domain_Name;

% define "name" of FE space
Element_Name = ['Const_Space_', Domain_Name, '_TupleSize_', num2str(Num_Row), '_', num2str(Num_Col)];

% create the FE space
eval([Element_Name, ' = Element(Domain_of_Constant,constant_one,Num_Row,Num_Col);']);
eval([Element_Name, '.Name = Element_Name;']);
% correct domain name
eval([Element_Name, '.Domain.Name = ''', Domain_Name, ''';']);
% correct tuple-size
eval([Element_Name, '.Tensor_Comp = [', num2str(Num_Row), ', ', num2str(Num_Col), '];']);

% Yes, this is weird...

% now create the global constant Coef function
CC = eval(['Coef(', Element_Name, ');']);

end