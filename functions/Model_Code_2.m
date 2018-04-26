clear all
close all
clc

% Read and store all images, also store flipped/reversed images
cdata = flipdim( imread('transformed_stitch.JPG'), 1 );
cdatar = flipdim( cdata, 2 );

cdata2 = flipdim( imread('Top.jpg'), 1 );
cdatar2 = flipdim( cdata2, 2 );

%{
cdata3 = flipdim( imread('Top.jpg'), 1 );
cdatar3 = flipdim( cdata3, 2 );

cdata4 = flipdim( imread('Top.jpg'), 1 );
cdatar4 = flipdim( cdata4, 2 );

cdata5 = flipdim( imread('Top.jpg'), 1 );
cdatar5 = flipdim( cdata5, 2 );
%}

% for final code:
% cdata=south(front)
% cdata2=west(left)
% cdata3=east(right)
% cdata4=north(back)
% cdata5=top

% Pull size for the surfaces from front image for x and z.  Pull size from
% top image for y (depth)
[z1,x1]=size(cdata);
x1=x1/3;
y1=1000;
x1=x1;
y1=y1;
z1=z1;

% Create solid color for bottom surface (gray)
C=[0, 0, 0];

% Create surfaces
% font (south)
surface([0 x1; 0 x1], [0 0; 0 0], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% left
surface([0 0; 0 0], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% right
surface([x1 x1; x1 x1], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% back
surface([0 x1; 0 x1], [y1 y1; y1 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% top
surface([0 x1; 0 x1], [0 0; y1 y1], [z1 z1; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata2 );
% bottom
surface([0 x1; 0 x1], [0 0; y1 y1], [0 0; 0 0], ...
    C);
%}
% set 3 dimensional view
view(3);

% set figure axis so it doesn't distort images
axis equal
%axis off
% pull up camera toolbar and set preferences so rotation is set by default
cameratoolbar('NoReset')
cameratoolbar('SetMode', 'orbit')








