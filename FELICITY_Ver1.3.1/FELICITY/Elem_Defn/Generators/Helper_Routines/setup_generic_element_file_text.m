function [Element_Domain, Domain_STR, Domain_Fig_ASCII, Dim] = setup_generic_element_file_text(Element_Domain)
%setup_generic_element_file_text
%
%   This sets up generic element file text and info.

% Copyright (c) 10-07-2016,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB2, TAB];

% get the (reference) finite element space
if strcmpi(Element_Domain,'interval')
    Element_Domain = 'interval';
    Domain_STR = 'unit interval [0, 1]';
    Domain_Fig_ASCII = ['%%', TAB3, '|------------|--> x', ENDL,...
                        '%%', TAB3, '0            1', ENDL];
    Dim = 1;
elseif strcmpi(Element_Domain,'triangle')
    Element_Domain = 'triangle';
    Domain_STR = 'unit triangle with vertex coordinates: (0, 0), (1, 0), (0, 1)';
    Domain_Fig_ASCII = ['%%', TAB3, '  y', ENDL,...
                        '%%', TAB3, '  ^', ENDL,...
                        '%%', TAB3, '  |', ENDL,...
                        '%%', TAB3, '1 + ', ENDL,...
                        '%%', TAB3, '  |\\ ', ENDL,...
                        '%%', TAB3, '  | \\ ', ENDL,...
                        '%%', TAB3, '  |  \\ ', ENDL,...
                        '%%', TAB3, '  |   \\ ', ENDL,...
                        '%%', TAB3, '  |    \\ ', ENDL,...
                        '%%', TAB3, '  |     \\ ', ENDL,...
                        '%%', TAB3, '  |      \\ ', ENDL,...
                        '%%', TAB3, '  |       \\ ', ENDL,...
                        '%%', TAB3, '0-+--------+--> x', ENDL,...
                        '%%', TAB3, '  0        1', ENDL];
    Dim = 2;
elseif strcmpi(Element_Domain,'tetrahedron')
    Element_Domain = 'tetrahedron';
    Domain_STR = 'unit tetrahedron with vertex coordinates: (0, 0, 0), (1, 0, 0), (0, 1, 0), (0, 0, 1)';
    Domain_Fig_ASCII = ['%%', TAB3, '            z', ENDL,...
                        '%%', TAB3, '            ^', ENDL,...
                        '%%', TAB3, '            |', ENDL,...
                        '%%', TAB3, '          1 +', ENDL,...
                        '%%', TAB3, '           /|\\ ', ENDL,...
                        '%%', TAB3, '          / | \\ ', ENDL,...
                        '%%', TAB3, '         |  |  \\ ', ENDL,...
                        '%%', TAB3, '        |   |   \\ ', ENDL,...
                        '%%', TAB3, '       |    |    \\ ', ENDL,...
                        '%%', TAB3, '       |    |     \\ ', ENDL,...
                        '%%', TAB3, '      |     |      \\ ', ENDL,...
                        '%%', TAB3, '      |     |       \\ ', ENDL,...
                        '%%', TAB3, '     |    0-+--------+--> y', ENDL,...
                        '%%', TAB3, '     |     /0     __/1', ENDL,...
                        '%%', TAB3, '    |    /     __/', ENDL,...
                        '%%', TAB3, '    |  /    __/', ENDL,...
                        '%%', TAB3, '   | /   __/', ENDL,...
                        '%%', TAB3, '  |/  __/', ENDL,...
                        '%%', TAB3, '1 +--/', ENDL,...
                        '%%', TAB3, ' \\/', ENDL,...
                        '%%', TAB3, ' x', ENDL];
    Dim = 3;
else
    error('Not implemented!');
end

end