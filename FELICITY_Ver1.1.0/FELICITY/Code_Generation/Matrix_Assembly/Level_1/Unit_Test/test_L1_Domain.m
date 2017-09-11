function status = test_L1_Domain()
%test_L1_Domain
%
%   Test code for FELICITY class.

% Copyright (c) 08-01-2011,  Shawn W. Walker

status = 0;

% define some domains
BOX    = Domain('tetrahedron');
SQUARE = Domain('triangle') < BOX;
LINE   = Domain('interval') < SQUARE;
if ~strcmp(SQUARE.Subset_Of,'BOX')
    status = 1;
end
if ~strcmp(LINE.Subset_Of,'BOX')
    status = 1;
end
if (SQUARE.GeoDim~=3)
    status = 1;
end
if (LINE.GeoDim~=3)
    status = 1;
end
if (BOX.Top_Dim~=3)
    status = 1;
end
if (SQUARE.Top_Dim~=2)
    status = 1;
end
if (LINE.Top_Dim~=1)
    status = 1;
end

% define some more domains
Surface = Domain('triangle',3);
Curve   = Domain('interval') < Surface;
if ~strcmp(Curve.Subset_Of,'Surface')
    status = 1;
end
if (Curve.GeoDim~=3)
    status = 1;
end

% define some more domains
Patch    = Domain('triangle');
SubPatch = Domain('triangle') < Patch;
if ~strcmp(SubPatch.Subset_Of,'Patch')
    status = 1;
end
if (SubPatch.GeoDim~=2)
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end