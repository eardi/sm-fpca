function plot_FELICITY_logo()
%plot_FELICITY_logo
%
%

% Copyright (c) 03-28-2011,  Shawn W. Walker

LOGO = FELICITY_Logo();

LINEWIDTH = 2.2;

hold on;
for Li = 1:length(LOGO.Letter)
for Si = 1:length(LOGO.Letter(Li).Line_Seg)
    VC = LOGO.Letter(Li).Line_Seg(Si).Coord;
    plot(VC(:,1),VC(:,2),'k','LineWidth',LINEWIDTH);
end
end
hold off;

axis([0 4 0 1]);
axis equal
axis([0 4 0 1]);

end