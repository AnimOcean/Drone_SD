function [II] = edge_id(im_file, scale)
%%read Image
im_type = fliplr(strtok(fliplr(im_file), '.'));
img=imread(im_file,im_type);
I=img;
%% Segment Image (k means)
II=imresize(I,scale);
YUV=rgb2ycbcr(II);
ab=YUV(:,:,2:3);
rows=size(ab,1);
cols=size(ab,2);
ab=reshape(ab,rows*cols,2);
num=3;
[idx, center]=kmeans(double(ab),num,'distance','sqEuclidean','Replicates',3);
labels=reshape(idx,rows,cols);
segmented_images = cell(1,num);
rgb_label = repmat(labels,[1 1 3]);
%%apply color to the segments
for i=1:num
    color=II;
    color(rgb_label~=i)=0;
    segmented_images{i}=color;
end
xy=0;
%%Choose segement to keep
i=1;
s=size(II);
W=uint8(zeros(s(1),s(2),3));
% while xy==0 && i<=num
for i=1:num
    figure(),imshow(segmented_images{i}), title('objects in cluster 1');
    y=1;Y=1;n=0;N=0;
    xy=input('Do you want this? (y/n)');
    if xy==1
        W=W+segmented_images{i};
    else
    end
    xy=0;
    close all
end
% end
%%Create the mask
mask=uint8(imresize(W,1/scale)>0);
mask=mask(1:size(I,1),1:size(I,2),:);
I=I.*mask;
%% Subtract the blurred grayscale image from original image
bounds=2;
mirrorsize=50;
Gn=rgb2gray(I);
Gl=medfilt2(rgb2gray(I),[mirrorsize mirrorsize]);
G=double(Gn)-double(Gl);
%%remove boundary
G=G(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize);
mask=mask(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,:);
%% Vectorize the image and set up the new matrices
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
%% Determine Eigenvalues and Eigenvectors
for i=2:length(r)-s(1)
    n=ceil(i/s(1))-1;
    col=n+1;
    row=i-s(1)*n;
    if i/50==floor(i/50) || i==2
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
%% Remove parts that were created by segementation using the mask
se=strel('disk',10);
Mask=imdilate(edge(mask(:,:,1)),se);
EVs=abs(valss(:,:,1,1)-valss(:,:,2,2));
EVs=EVs.*~Mask;
%% Plot results
figure(),imagesc(EVs)
axis equal
axis off
figure(),imshow(I)
%% Connect Cracks
% ev=imresize(EVs(1:end-1,1:end-1),.25);
% r=5;
% angles=[0:10:180];
% f1=zeros(2*r+1,2*r+1,length(angles));
% for i=-r:r
%     c1(:,:,i+r+1)=round((i).*cos(-angles*pi/180));
%     s1(:,:,i+r+1)=round((i).*sin(-angles*pi/180));
%     f1(s1+r+1,c1+r+1,:)=1;
% end
% for i=-r:r
%     for j=1:length(angles)
%         cc=c1(:,j,:);
%         ss=s1(:,j,:);
%         ss=ss(:);
%         cc=cc(:);
%         f1(ss(i+r+1)+r+1,cc(i+r+1)+r+1,j)=1;
%     end
% end
% II=double(ones(size(ev,1),size(ev,2)));
% f1=f1(2:end-1,2:end-1,:);
% strelem=[.25 .5 .25;
%     .5 1 .5;
%     .25 .5 .25];
% strelem=strelem./sum(sum(strelem));
% for i=1:length(angles)
%     f1(:,:,i)=imfilter(f1(:,:,i),strelem);
% end
% new=ones(size(ev,1),size(ev,2));
% for i=1:length(angles)
%     se=f1(:,:,i)./sum(sum(f1(:,:,i)));
%     II(:,:,i)=(imfilter((ev),se)).*double(ev>0);
%     new=double(II(:,:,i))+new;
% end
% M=zeros(size(ev,1),size(ev,2));
% for i=1:size(ev,1)
%     for j=1:size(ev,2)
%         for k=1:length(angles)
%             mm(k)=II(i,j,k);
%         end
%         M(i,j)=max(mm);
%         Mm(i,j)=min(mm);
%     end
% end
% EE=edge(M-Mm,'canny',.02,sqrt(2));
% clear se
% se=strel('disk',3);
% Ed=imerode(imdilate(EE,se),se);
% aa=imresize(Ed,4).*EVs(1:end-1,1:end-1);
spr=sqrt(var(EVs(:)));
evs=EVs.*(EVs>5*spr);
se=strel('disk',10);
GGl=medfilt2(rgb2gray(I),[100 100]);
hardedges=~imdilate(edge(GGl,'prewitt',.005),se);
evs=(evs.*hardedges(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize));
%%
se1=strel('disk',30);
se2=strel('disk',10);
eee=imerode(imdilate(double(evs>50),se1),se2);
A=cell2mat(struct2cell(regionprops(eee>0,'Area')))';
P=cell2mat(struct2cell(regionprops(eee>0,'Perimeter')))';
Ex=cell2mat(struct2cell(regionprops(eee>0,'Extrema')))';
R=4.*pi.*A./(P.^2);
f=find(R<.9);
crackid=bwselect(eee,ceil(Ex(2*f-1,7)),floor(Ex(2*f,7)));

clear se
se=strel('disk',2);
see=strel('disk',3);
cracks=(imerode(imfill(imdilate(edge(I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,1).*uint8(crackid),.025)-imdilate(edge(uint8(crackid)),se),se),'holes'),see));
se=strel('disk',5);
cracks2=imdilate(cracks,se);
clear II
II(:,:,1)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,1);
II(:,:,2)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,2)+500.*uint8(cracks2);
II(:,:,3)=I(mirrorsize:end-mirrorsize,mirrorsize:end-mirrorsize,3);
figure(),imshow(II)