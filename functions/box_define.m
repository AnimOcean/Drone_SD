function [b,newFolderLocation2] = box_define(xlim, ylim, folderNameRGB)
disp('Pick top left and bottom right corner of desired box')
[xbox,ybox] = ginput(2)
% xbox=[5900 8000];
% ybox=[1200 3200]; 
h=fill([xbox(1),xbox(2),xbox(2),xbox(1)],[ybox(1),ybox(1),ybox(2),ybox(2)],'red');
h.FaceAlpha=0.3;
xbox_lim=xbox+xMin;
ybox_lim=ybox+yMin;
a=0;
numImages=length(xlim)
b=zeros(1,numImages);

% Name a new folder to create in location with the images
newFolderName2 = 'Partial Section';

% Check if a folder already exists to place the new images
% If not, create one
if not(exist(newFolderName2,'dir'))
    mkdir(folderNameRGB, newFolderName2)
    newFolderLocation2 = './Partial Section';
end

for i = 1:numImages
    if a==0 && xlim(i,1)>=xbox_lim(1) && xlim(i,1)<=xbox_lim(2)
        if ylim(i,1)>=ybox_lim(1) && ylim(i,1)<=ybox_lim(2)
            %move to folder 
            a=1;
            b(i)=1;
        elseif ylim(i,2)>=ybox_lim(1) && ylim(i,2)<=ybox_lim(2) 
            %move to folder
            a=1;
            b(i)=2;
        end
    end
    
    if a==0 && xlim(i,2)>=xbox_lim(1) && xlim(i,2)<=xbox_lim(2)
        if ylim(i,1)>=ybox_lim(1) && ylim(i,1)<=ybox_lim(2)
            %move to folder 
            a=1;
            b(i)=3;
        elseif ylim(i,2)>=ybox_lim(1) && ylim(i,2)<=ybox_lim(2) 
            %move to folder
            a=1; 
            b(i)=4;
        end
    end
    
    if a==0 && xbox_lim(1)>=xlim(i,1) && xbox_lim(1)<=xlim(i,2)
        if ybox_lim(1)>=ylim(i,1) && ybox_lim(1)<=ylim(i,2)
            %move to folder 
            a=1;
            b(i)=5;
        elseif ybox_lim(2)>=ylim(i,1) && ybox_lim(2)<=ylim(i,2)
            %move to folder
            a=1;
            b(i)=6;
        end
    end
    
    if a==0 && xbox_lim(2)>=xlim(i,1) && xbox_lim(2)<=xlim(i,2)
        if ybox_lim(1)>=ylim(i,1) && ybox_lim(1)<=ylim(i,2)
        %move to folder 
            a=1;
            b(i)=7;
        elseif ybox_lim(2)>=ylim(i,1) && ybox_lim(2)<=ylim(i,2)
            %move to folder
            a=1;
            b(i)=8;
        end
    end
    a=0;
    
    % if statements checking the number of significant figures for the image's index
    if b(i)~=0    
        if i >= 1 && i <= 9     % the first 9 images have extra zeros added to their name maintains consistent naming convention that is read in the correct order
            % write the desired image as a new file in the new folder
            img_dup = readimage(buildingSceneOriginal, i);
            imwrite(img_dup, fullfile(folderNameRGB, newFolderName2, ['duplicateRGB-00',sprintf('%d',i),'.jpg']), 'jpg');
            reducedImageFolder = fullfile(folderNameRGB, newFolderName2);
        elseif i >= 10 && i <= 99   % indexes with 2 digits get 1 zero added to their name
           % write the desired image as a new file in the new folder
            img_dup = readimage(buildingSceneOriginal, i);
            imwrite(img_dup, fullfile(folderNameRGB, newFolderName2, ['duplicateRGB-00',sprintf('%d',i),'.jpg']), 'jpg');
            reducedImageFolder = fullfile(folderNameRGB, newFolderName2);
        elseif i >= 100 && i <= 999
            % write the desired image as a new file in the new folder
            img_dup = readimage(buildingSceneOriginal, i);
            imwrite(img_dup, fullfile(folderNameRGB, newFolderName2, ['duplicateRGB-00',sprintf('%d',i),'.jpg']), 'jpg');
            reducedImageFolder = fullfile(folderNameRGB, newFolderName2);
        end 
    end
end
end

