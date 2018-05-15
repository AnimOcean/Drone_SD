<<<<<<< HEAD
function [reducedImageFolder,resizedImageFolder] = calibration_img(org_folder)

% calibration; 
=======
function [reducedImageFolder,resizedImageFolder] = calibration_img(org_folder, cameraParams)
>>>>>>> d4b71621abbe9b9b3432fe9384e64262280ca6b8

% TopFolder ='C:\Users\liz_surface5\Desktop\Senior Design\duo pro r\pics';
TopFolder = org_folder;
TopFolderDir = fullfile(TopFolder);

exts1 = {'.jpg'};
OriginalRGB = imageDatastore(TopFolderDir, 'FileExtensions',exts1);

% Name a new folder to create in location with the images
ReducedRGB = 'ReducedRGB';
ResizedRGB = 'ResizedRGB';

% Check if a folder already exists to place the new images
% If not, create one
if not(exist(ReducedRGB,'dir'))
    mkdir(TopFolder, ReducedRGB)
%     newFolderLocation = './Test';
end

if not(exist(ResizedRGB,'dir'))
    mkdir(TopFolder, ResizedRGB)
%     newFolderLocation = './ResizedRGB';
end

% Count number of images in the RGB image folder
numImages = numel(OriginalRGB.Files);

% Read both the first RGB and IR images
I1 = readimage(OriginalRGB, 1);    

% all the images should be the same size
imageSizeRGB = size(I1);  % Size of the RGB image

widthRGB = imageSizeRGB(2); % Width of each image
widthIR = round(0.85*widthRGB);

heightRGB = imageSizeRGB(1); % Height of each image
heightIR = round(0.90666667*heightRGB);

% Gap between the edges of each image, if both were centered at the same location
edgeWidthDiff = round((widthRGB - widthIR)/2);      
edgeHeightDiff = round((heightRGB - heightIR)/2);

% For loop to reduce the size of the RGB images to match that of the IR
% images. Saves them as a new set of images. 
for n = 1:numImages
        % Generate an empty matrix, same size as the IR images
        I1reduced = zeros(heightIR, widthIR, imageSizeRGB(3),class(I1)); 
        
        % read the current RGB image
        I1 = readimage(OriginalRGB, n);
        I1 = undistortImage(I1,cameraParams); %Undistort
        
        for i = edgeHeightDiff:(edgeHeightDiff+heightIR-1)            % Pixel Height location for fullsize image
            a = i - edgeHeightDiff + 1;                                     % Pixel Height location to be replaced on reduced version
           
            for j = edgeWidthDiff:(edgeWidthDiff+widthIR-1)          % Pixel Width location for fullsize image
                b = j - edgeWidthDiff + 1;                                  % Pixel Width location to be replaced on reduced version
               
                for d = 1:imageSizeRGB(3) 
                    % Copy relevant pixel color data from the full size image to the reduced image
                    % Essentially, remove the borders from the larger RGB image
                    I1reduced(a,b,d) = I1(i,j,d);  
                end
            end
        end
        
        % if statements checking the number of significant figures for the image's index
        if n >= 1 && n <= 9     % the first 9 images have extra zeros added to their name
                                % maintains consistent naming convention that is read in the correct order
            % Record the image names
            reducedImageName = ['reducedRGB-00',sprintf('%d',n)];
            reducedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(I1reduced, fullfile(TopFolder, ReducedRGB, ['reducedRGB-00',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(TopFolder, ReducedRGB);
            
        elseif n >= 10 && n <= 99   % indexes with 2 digits get 1 zero added to their name
            % Record the image names
            reducedImageName = ['reducedRGB-0',sprintf('%d',n)];
            reducedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(I1reduced, fullfile(TopFolder, ReducedRGB, ['reducedRGB-0',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(TopFolder, ReducedRGB);
                       
        elseif n >= 100 && n <= 999
            % Record the image names
            reducedImageName = ['reducedRGB-',sprintf('%d',n)];
            reducedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(I1reduced, fullfile(TopFolder, ReducedRGB, ['reducedRGB-',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(TopFolder, ReducedRGB); 
        end
end

ReducedImageDir = fullfile(reducedImageFolder);
Reduced_DS_RGB = imageDatastore(ReducedImageDir, 'FileExtensions',exts1);

for j=1:numImages
    img3=readimage(Reduced_DS_RGB,j);
    img3resized=imresize(img3,0.56470588);
            % if statements checking the number of significant figures for the image's index
        if j >= 1 && j <= 9     % the first 9 images have extra zeros added to their name
                                % maintains consistent naming convention that is read in the correct order
            % Record the image names
            resizedImageName = ['resizedRGB-00',sprintf('%d',j)];
            resizedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(img3resized, fullfile(TopFolder, ResizedRGB, ['resizedRGB-00',sprintf('%d',j),'.jpg']), resizedImageFormat);
            resizedImageFolder = fullfile(TopFolder, ResizedRGB);
            
        elseif j >= 10 && j <= 99   % indexes with 2 digits get 1 zero added to their name
           % Record the image names
            resizedImageName = ['resizedRGB-0',sprintf('%d',j)];
            resizedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(img3resized, fullfile(TopFolder, ResizedRGB, ['resizedRGB-0',sprintf('%d',j),'.jpg']), resizedImageFormat);
            resizedImageFolder = fullfile(TopFolder, ResizedRGB);
                       
        elseif j >= 100 && j <= 999
            resizedImageName = ['resizedRGB-',sprintf('%d',j)];
            resizedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(img3resized, fullfile(TopFolder, ResizedRGB, ['resizedRGB-',sprintf('%d',j),'.jpg']), resizedImageFormat);
            resizedImageFolder = fullfile(TopFolder, ResizedRGB);
        end
end

end

