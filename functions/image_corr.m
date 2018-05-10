%% Correlation between images 

% clear all 
% clc 
% close all

%%
% imageDir = fullfile('C:\Users\liz_surface5\Desktop\Senior Design\practice photos\main_building5');
imageDir = fullfile('C:\Users\liz_surface5\Desktop\Senior Design\duo pro r\pics2');
exts1 = {'.jpg'};
images = imageDatastore(imageDir,'FileExtensions',exts1);
% montage(images.Files)
% new_folder= fullfile('C:\Users\liz_surface5\Desktop\Senior Design\practice photos\main_building5\reorder');
% I1 = readimage(images,10);
% I1a = rgb2gray(I1);
% figure
% % imshow(I1)
% imshow(I1a)
% I2 = readimage(images,11);
% I2a = rgb2gray(I2);
% corr=corr2(I1a,I2a)
% corr1=corr2(I1a,I1a)
% figure 
% imshow(I2a)

% n=numel(images.Files);
n=40;
R=zeros(1,n);


for i=1:n
    Img = readimage(images, i);
    Img = rgb2gray(Img);
    I{i} = Img;
end

testCorr = zeros(length(I));
for i = 1:length(I)
    for j = 1:i
        if i ~= j
            testCorr(i,j) = corr2(I{i},I{j});
        end
    end   
    i
end

% ph=zeros(n);
% for i = 1:length(I)
%     for j=
%    [M,I]=max(testCorr)
%    ph(I,i)=1;
% %    for 
% %    for j=
% %    end
% end

fprintf('done')


% for j=2:n
%     R(1,j)=corr2(I{j-1},I{j})
% %     [M,I]=max(R)
% %     baseFileName=images.Files(I)
% %     newBaseFileName= sprintf('%s_image.PNG', j);
% %     existingFullFileName = fullfile(imageDir, baseFileName);
% %     newFullFileName = fullfile(new_folder, newBaseFileName);
% %     movefile(existingFullFileName{1}, newFullFileName);
% end

% [folder, baseFileName, ext] = fileparts(oldFileName);
% % Change base file name and extension.
% newBaseFileName= sprintf('%s_images.PNG', baseFileName);
% newFullFileName = fullfile(folder, newBaseFileName);


% numberOfImageFiles = length(baseFileNames);
% 	if numberOfImageFiles >= 1
% 		% Go through all those files.
% 		for f = 1 : numberOfImageFiles
% 			existingFullFileName = fullfile(thisFolder, baseFileNames(f).name);
% 			if isdir(existingFullFileName)
% 				% Skip folders . and ..
% 				continue;
% 			end
% 			% Get the last character of the folder.  It should be a number from 1 to 4.
% 			lastDigit = thisFolder(end);
% 			% Create a new name for it.
% 			newBaseFileName = sprintf('%s_images_%d.png', lastDigit, f-1);
% 			newFullFileName = fullfile(thisFolder, newBaseFileName);
% 			fprintf('     Renaming file %s to %s\n', existingFullFileName, newFullFileName);
% 			% Do the actual renaming.
% 			movefile(existingFullFileName, newFullFileName);
% 		end
% 	else
% 		fprintf('     Folder %s has no files in it.\n', thisFolder);
% 	end

%Look into using Simulink as the middle point of the project
