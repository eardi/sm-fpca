function Quad = Generate_Triangle_Quad_Rules(Deg_Of_Precision)
%Generate_Triangle_Quad_Rules
%
%    This generates quadrature rules for the unit reference triangle.
%
%    Note: This was adapted from MFEM version 3.0.1.

% Copyright (c) 10-05-2015,  Shawn W. Walker

DIG = 25; % set num digits to use

% init!
Quad.Pt = [];
Quad.Wt = [];

switch Deg_Of_Precision
    
    case  9
        Quad = AddTriMidPoint(Quad, vpa(0.0485678981413994169096209912536443,DIG));
        Quad = AddTriPoints3b(Quad, vpa(0.020634961602524744433,DIG), vpa(0.0156673501135695352684274156436046,DIG));
        Quad = AddTriPoints3b(Quad, vpa(0.12582081701412672546,DIG), vpa(0.0389137705023871396583696781497019,DIG));
        Quad = AddTriPoints3a(Quad, vpa(0.188203535619032730240961280467335,DIG), vpa(0.0398238694636051265164458871320226,DIG));
        Quad = AddTriPoints3a(Quad, vpa(0.0447295133944527098651065899662763,DIG), vpa(0.0127888378293490156308393992794999,DIG));
        Quad = AddTriPoints6_alt(Quad, vpa(0.0368384120547362836348175987833851,DIG), vpa(0.2219629891607656956751025276931919,DIG), vpa(0.0216417696886446886446886446886446,DIG));
    otherwise
        error('Not valid!');
end

end

function Quad = AddTriMidPoint(Quad, Weight)

MP = [1/3, 1/3];
Quad.Pt = [Quad.Pt; MP];
Quad.Wt = [Quad.Wt; Weight];

end

function Quad = AddTriPoints3(Quad, a, b, Weight)

PP = [a, a; a, b; b, a];
WW = [Weight; Weight; Weight];

Quad.Pt = [Quad.Pt; PP];
Quad.Wt = [Quad.Wt; WW];

end

function Quad = AddTriPoints3a(Quad, a, Weight)
Quad = AddTriPoints3(Quad, a, 1 - 2*a, Weight);
end
function Quad = AddTriPoints3b(Quad, b, Weight)
Quad = AddTriPoints3(Quad, (1 - b)/2, b, Weight);
end

function Quad = AddTriPoints3R(Quad, a, b, c, Weight)

PP = [a, b; c, a; b, c];
WW = [Weight; Weight; Weight];

Quad.Pt = [Quad.Pt; PP];
Quad.Wt = [Quad.Wt; WW];

end

function Quad = AddTriPoints3R_alt(Quad, a, b, Weight)
Quad = AddTriPoints3R(Quad, a, b, (1 - a - b), Weight);
end

function Quad = AddTriPoints6(Quad, a, b, c, Weight)

PP = [a, b; b, a; a, c; c, a; b, c; c, b];
WW = [Weight; Weight; Weight; Weight; Weight; Weight];

Quad.Pt = [Quad.Pt; PP];
Quad.Wt = [Quad.Wt; WW];

end

function Quad = AddTriPoints6_alt(Quad, a, b, Weight)
Quad = AddTriPoints6(Quad, a, b, (1 - a - b), Weight);
end