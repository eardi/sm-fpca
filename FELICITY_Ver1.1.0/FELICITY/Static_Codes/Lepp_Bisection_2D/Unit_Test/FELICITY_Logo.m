function [LOGO, LS] = FELICITY_Logo()
%FELICITY_Logo
%
%   Struct with FELICITY logo as line segments.

% Copyright (c) 03-28-2011,  Shawn W. Walker

BASE_OFFSET = [0.21 0;0.21 0];

% F
OFFSET = [0 0;0 0] + BASE_OFFSET;
LOGO.Letter.Line_Seg.Coord = [0 0.1; 0 0.9] + OFFSET;
LOGO.Letter.Line_Seg(2).Coord = [0 0.9; 0.35 0.9] + OFFSET;
LOGO.Letter.Line_Seg(3).Coord = [0 0.5; 0.3 0.5] + OFFSET;

% E
OFFSET = [0.5 0;0.5 0] + BASE_OFFSET;
LOGO.Letter(2).Line_Seg(1).Coord = [0 0.1; 0 0.9] + OFFSET;
LOGO.Letter(2).Line_Seg(2).Coord = [0 0.9; 0.3 0.9] + OFFSET;
LOGO.Letter(2).Line_Seg(3).Coord = [0 0.5; 0.25 0.5] + OFFSET;
LOGO.Letter(2).Line_Seg(4).Coord = [0 0.1; 0.3 0.1] + OFFSET;

% L
OFFSET = [0.95 0;0.95 0] + BASE_OFFSET;
LOGO.Letter(3).Line_Seg(1).Coord = [0 0.1; 0 0.9] + OFFSET;
LOGO.Letter(3).Line_Seg(2).Coord = [0 0.1; 0.3 0.1] + OFFSET;

% I
OFFSET = [1.4 0;1.4 0] + BASE_OFFSET;
LOGO.Letter(4).Line_Seg(1).Coord = [0.15 0.1; 0.15 0.9] + OFFSET;
LOGO.Letter(4).Line_Seg(2).Coord = [0 0.1; 0.3 0.1] + OFFSET;
LOGO.Letter(4).Line_Seg(3).Coord = [0 0.9; 0.3 0.9] + OFFSET;

% C
OFFSET = [1.9 0;1.9 0] + BASE_OFFSET;
LOGO.Letter(5).Line_Seg(1).Coord = [0 0.1; 0 0.9] + OFFSET;
LOGO.Letter(5).Line_Seg(2).Coord = [0 0.1; 0.3 0.1] + OFFSET;
LOGO.Letter(5).Line_Seg(3).Coord = [0 0.9; 0.3 0.9] + OFFSET;

% I
OFFSET = [2.4 0;2.4 0] + BASE_OFFSET;
LOGO.Letter(6).Line_Seg(1).Coord = [0.15 0.1; 0.15 0.9] + OFFSET;
LOGO.Letter(6).Line_Seg(2).Coord = [0 0.1; 0.3 0.1] + OFFSET;
LOGO.Letter(6).Line_Seg(3).Coord = [0 0.9; 0.3 0.9] + OFFSET;

% T
OFFSET = [2.85 0;2.85 0] + BASE_OFFSET;
LOGO.Letter(7).Line_Seg(1).Coord = [0.15 0.1; 0.15 0.9] + OFFSET;
LOGO.Letter(7).Line_Seg(2).Coord = [0 0.9; 0.3 0.9] + OFFSET;

% Y
OFFSET = [3.3 0;3.3 0] + BASE_OFFSET;
LOGO.Letter(8).Line_Seg(1).Coord = [0.15 0.1; 0.15 0.5] + OFFSET;
LOGO.Letter(8).Line_Seg(2).Coord = [0 0.91; 0.15 0.5] + OFFSET;
LOGO.Letter(8).Line_Seg(3).Coord = [0.3 0.91; 0.15 0.5] + OFFSET;

LS.Line = [];
CNT = 0;
for Li = 1:length(LOGO.Letter)
for Si = 1:length(LOGO.Letter(Li).Line_Seg)
    CNT = CNT + 1;
    LS(CNT).Line = LOGO.Letter(Li).Line_Seg(Si).Coord;
end
end

end