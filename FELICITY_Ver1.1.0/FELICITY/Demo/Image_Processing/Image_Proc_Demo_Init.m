function [P1_Mesh_DoFmap, P1_Mesh_Vtx, Image_Data] = Image_Proc_Demo_Init()
%Image_Proc_Demo_Init
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

% load image
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% read image
Raw_Image = imread(fullfile(Current_Dir, 'bird.jpg'));
Raw_Image = double(Raw_Image);
Raw_Image = Raw_Image / max(Raw_Image(:)); % rescale

% % smooth it?
% Fave = fspecial('average', [3 3]);
% Raw_Image = imfilter(Raw_Image, Fave);

% represent it on a cartesian mesh
Image_Data.I = Raw_Image;
NR = size(Image_Data.I,1);
NC = size(Image_Data.I,2);
Image_Data.X = linspace(0,1,NC);
Image_Data.Y = linspace(0,NR/NC,NR);
[Image_Data.X_grid, Image_Data.Y_grid] = meshgrid(Image_Data.X,Image_Data.Y);

% precompute grad(I) over the image domain
dx = Image_Data.X(2) - Image_Data.X(1);
dy = Image_Data.Y(2) - Image_Data.Y(1);
Image_Data.dx = dx;
Image_Data.dy = dy;
[Image_Data.I_grad_X, Image_Data.I_grad_Y]  = gradient(Image_Data.I,dx,dy);

% generate initial contour

% BEGIN: define 1-D (closed) curve mesh
Num_P1_Nodes = 100;
rad = 0.3; % 0.3
[X,Y] = cylinder(rad,Num_P1_Nodes);
X = X(1,:)' + 0.5; % 0.5
Y = Y(1,:)' + 0.35; % 0.35

P1_Mesh_Vtx = [X(1:end-1,1), Y(1:end-1,1)];
clear X Y;
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1);
                         P1_Ind(end,1),     P1_Ind(1,1)]); % NOTE! unsigned integer
% END: define 1-D (closed) curve mesh

% figure;
% imagesc(Image_Data.X,Image_Data.Y,Image_Data.I);
% colormap(gray);
% axis image;

end