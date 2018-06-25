function [bw] = idcrack( image, scale)
%%read Image
I=image;
II=imresize(I,scale);
%% Section 1
%%%% Segment Image (k means)
%%This section was found online
nk=8;
if size(image, 3) == 3
    YUV=double(rgb2ycbcr(II))./255;
    hsvs=rgb2hsv(II);
    ab=zeros(size(II,1),size(II,2),nk);
    ab(:,:,1:2)=YUV(:,:,2:3);
    ab(:,:,3:5)=hsvs;
    ab(:,:,6:8)=II; 
    rows=size(ab,1);
    cols=size(ab,2);
    ab=reshape(ab,rows*cols,nk);
else
    ab = II;
    [rows cols] = size(ab);
    ab=ab(:);
end

num=5;
[idx ~]=kmeans(double(ab),num,'distance','sqEuclidean','Replicates',3);
labels=reshape(idx,rows,cols);
segmented_images = cell(1,num);
rgb_label = repmat(labels,[1 1 size(ab, 3)]);
%%apply color to the segments
for i=1:num
    color=II;
    color(rgb_label~=i)=0;
    segmented_images{i}=color;
end
%%End section found online
%%I wrote another code for x-means that uses this as well, but I didn't
%%impliment it here yet. I still have a bug somewhere that it sometimes
%%runs forever.


xy=0;
%%Choose segement to keep
i=1;
s=size(II);
W=uint8(zeros(s(1),s(2),3));
% while xy==0 && i<=num
for i=1:num
    imshow(segmented_images{i}), title('objects in cluster 1');
    y=1;Y=1;n=0;N=0;
    xy=input('Do you want this? (y/n)');
    if xy==1
        W=W+segmented_images{i};
    else
    end
    xy=0;
end
% end
%%Create the mask
mask=uint8(imresize(W,1/scale)>0);
mask=mask(1:size(I,1),1:size(I,2),:);
I=I.*mask;
%% Section 2
%%%% Subtract the blurred grayscale image from original image
bounds=2;
mirrorsize=50;
Gn=rgb2gray(I);
Gl=medfilt2(rgb2gray(I),[mirrorsize mirrorsize]);
G=double(Gn)-double(Gl);
%%remove boundary
G=G(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize);
mask=mask(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,:);
%% Section 3
%%%% Vectorize the image and set up the new matrices
s=size(G);
r=reshape(G,s(1)*s(2),1);
vecss=zeros(s(1),s(2),2,2);
valss=zeros(s(1),s(2),2,2);
%%Create the padding at the edges using a mirror
M1=flipdim(G,1);%%Mirror
M2=flipdim(G,2);%%Mirror
GG=zeros(2*mirrorsize+s(1),2*mirrorsize+s(2));%%New image with padding
sg=size(GG);
GG(mirrorsize+1:sg(1)-mirrorsize,mirrorsize+1:sg(2)-mirrorsize)=G;
GG(1:mirrorsize,mirrorsize:sg(2)-mirrorsize-1)=M1(s(1)-mirrorsize+1:end,:);
GG(sg(1)-mirrorsize+1:end,mirrorsize:sg(2)-mirrorsize-1)=M1(1:mirrorsize,:);
GG(mirrorsize:sg(1)-mirrorsize-1,1:mirrorsize)=M2(:,s(2)-mirrorsize+1:end);
GG(mirrorsize:sg(1)-mirrorsize-1,sg(2)-mirrorsize+1:end)=M2(:,1:mirrorsize);
GG(1:mirrorsize,1:mirrorsize)=M1(end-mirrorsize+1:end,1:mirrorsize);
GG(1:mirrorsize,end-mirrorsize+1:end)=M1(end-mirrorsize+1:end,end-mirrorsize+1:end);
GG(end-mirrorsize+1:end,1:mirrorsize)=M1(1:mirrorsize,1:mirrorsize);
GG(end-mirrorsize+1:end,end-mirrorsize+1:end)=M1(end-mirrorsize+1:end,1:mirrorsize);
%% Section 4
%%%% Determine Eigenvalues and Eigenvectors
for i=2:length(r)-s(1)
    n=ceil(i/s(1))-1;
    col=n+1;
    row=i-s(1)*n;
    if i/mirrorsize==floor(i/mirrorsize) || i==2
        w=GG(row:row+2*mirrorsize,col:col+2*mirrorsize);
        avg=mean(w(:));
        stdev=std(w(:));
        cutoff=avg-3*stdev;
    end
    if double(r(i-1))<cutoff || double(r(i))<cutoff || double(r(i+s(1)))<cutoff || double(r(i+s(1)-1))<cutoff
        mat=[double(r(i-1)) double(r(i)); double(r(i+s(1)-1)) double(r(i+s(1)))]';
        [vec val]=eig(mat);
        vecss(row,col,:,:)=vec;
        valss(row,col,:,:)=val;
    end
end
%% Section 5
%%%% Remove parts that were created by segementation using the mask
sizese=3;
se=strel('disk',sizese);
Mask=imdilate(edge(mask(:,:,1)),se);
EVs=abs(valss(:,:,1,1)-valss(:,:,2,2));%%This was found in the Tensor Voting code from online
EVs=EVs.*~Mask;
%% Section 6
%%%% Keep pixels with large eigenvalues
spr=sqrt(var(EVs(:)));
evs=EVs.*(EVs>5*spr);
se=strel('disk',sizese);
%% Section 7
%%%% Remove Hard Edges
GGl=medfilt2(rgb2gray(I),[100 100]);
hardedges=~imdilate(edge(GGl,'prewitt',.005),se);
evs=(evs.*hardedges(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize));
%% Section 8
%%%% Filter by shape
se1=strel('disk',3*sizese);
se2=strel('disk',sizese);
stdevevs=sqrt(var(evs(:)));
eee=imerode(imdilate(double(evs>10*stdevevs),se1),se2);
A=cell2mat(struct2cell(regionprops(eee>0,'Area')))';
P=cell2mat(struct2cell(regionprops(eee>0,'Perimeter')))';
Ex=cell2mat(struct2cell(regionprops(eee>0,'Extrema')))';
%%determine roundness
R=4.*pi.*A./(P.^2);
f=find(R<.6);
%%keep likely cracks
crackid=bwselect(eee,ceil(Ex(2*f-1,7)),floor(Ex(2*f,7)));
clear se
se=strel('disk',2);
see=strel('disk',3);
%% Section 9
%%%% dilate and erode image to make cracks connected
cracks=(imerode(imfill(imdilate(edge(I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,1).*uint8(crackid),.025)-imdilate(edge(uint8(crackid)),se),se),'holes'),see));
se=strel('disk',ceil(sizese/2));
cracks2=imdilate(cracks,se);
A=cell2mat(struct2cell(regionprops(cracks2>0,'Area')))';
P=cell2mat(struct2cell(regionprops(cracks2>0,'Perimeter')))';
Ex=cell2mat(struct2cell(regionprops(cracks2>0,'Extrema')))';
R=4.*pi.*A./(P.^2);
ff=(R<.5).*(A<size(cracks2,1)*size(cracks2,2)/10);
f=find(ff==1);
cracks2=bwselect(cracks2,ceil(Ex(2*f-1,7)),floor(Ex(2*f,7)));
clear II
% I=image;
%%identify and show cracks
II(:,:,1)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,1)+500.*uint8(cracks2);
if size(I, 3) == 3
    II(:,:,2)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,2).*uint8(~cracks2);
    II(:,:,3)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,3).*uint8(~cracks2);
end
imshow(II)

%% Section 10
%%%% use matched filtering
%%set up kernel
r=10;
angles=[0:10:180];
f1=zeros(2*r+1,2*r+1,length(angles));
for i=-r:r
    c1(:,:,i+r+1)=round((i).*cos(-angles*pi/180));
    s1(:,:,i+r+1)=round((i).*sin(-angles*pi/180));
end
for i=-r:r
    for j=1:length(angles)
        cc=c1(:,j,:);
        ss=s1(:,j,:);
        ss=ss(:);
        cc=cc(:);
        f1(ss(i+r+1)+r+1,cc(i+r+1)+r+1,j)=1;
    end
end
%%convolve image multiple times
II=double(ones(size(cracks,1),size(cracks,2)));
new=zeros(size(cracks,1),size(cracks,2));
for i=1:length(angles)
    se=f1(:,:,i)./sum(sum(f1(:,:,i)));
    II(:,:,i)=(imfilter((cracks),se));
    new=double(II(:,:,i))+new;
end

for i=1:size(II,1)
    for j=1:size(II,2)
        nnew(i,j)=max(II(i,j,:));
    end
end
        
%% Section 11
%%%% Hough Transform - find lines
BW=nnew;
npts=20;
[H, T, R] = hough(BW,'Theta', -89:0.5:89);
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
hold on;
P  = houghpeaks(H,npts,'threshold',ceil(0.3*max(H(:))),'NHoodSize',[701 101]);
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',10,'MinLength',50);
% imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   pts(2*k-1:2*k,:)=[lines(k).point1;lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');
hold off;

