function Quad = Gen_Quadrature_Rule(obj,Num_Quad,Simplex_Type)
%Gen_Quadrature_Rule
%
%   This returns a quadrature rule on the reference element for the given
%   simplex type.
%
%   Quad = obj.Gen_Quadrature_Rule(Num_Quad,Simplex_Type);
%
%   Num_Quad     = number of quadrature points.
%   Simplex_Type = (string) specifies the type of simplex:
%                  'interval', 'triangle', 'tetrahedron'.
%                  You can also pass an empty matrix [] (for compatibility with
%                  other internal FELICITY functions).
%
%   Quad = struct containing quadrature rule:
%          .Pt = Num_Quad x T array of evaluation points;
%                T = topological dimension of Simplex_Type.
%          .Wt = Num_Quad x 1 array of quadrature weights.

% Copyright (c) 03-06-2013,  Shawn W. Walker

if ~isfinite(Num_Quad)
    error('Num_Quad is NOT a finite number!');
end

% get quadrature points
if strcmp(Simplex_Type,'interval')
    [Quad.Pt, Quad.Wt] = Quad_On_Interval(Num_Quad); % Gauss formulas
elseif strcmp(Simplex_Type,'triangle')
    [Quad.Pt, Quad.Wt] = Quad_On_Triangle(Num_Quad); % Strang formulas
    if (length(Quad.Wt)~=Num_Quad)
        error('Quadrature points were not the desired ones!');
    end
elseif strcmp(Simplex_Type,'tetrahedron')
    [Quad.Pt, Quad.Wt] = Quad_On_Tetra(Num_Quad); % Keast formulas
    if (length(Quad.Wt)~=Num_Quad)
        error('Quadrature points were not the desired ones!');
    end
elseif isempty(Simplex_Type)
    % just define a value;  it is NOT actually used
    Quad.Pt = [0];
    Quad.Wt = 1;
else
    error('NOT VALID!!!');
end

end