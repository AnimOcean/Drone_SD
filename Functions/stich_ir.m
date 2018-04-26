%% 
clear all 
close all 
clc

%% Step 1 - Load Images
% The image set used in this example contains pictures of a building. These
% were taken with an uncalibrated smart phone camera by sweeping the camera
% from left to right along the horizon, capturing all parts of the
% building.
%
% As seen below, the images are relatively unaffected by any lens
% distortion so camera calibration was not required. However, if lens
% distortion is present, the camera should be calibrated and the images
% undistorted prior to creating the panorama. You can use the
% |<matlab:doc('cameraCalibrator'); cameraCalibrator>| App to calibrate a
% camera if needed. 

% Load images.
folderNameRGB = 'C:\Users\liz_surface5\Desktop\Senior Design\practice photos\main_building4';
folderNameIR = 'C:\Users\liz_surface5\Desktop\Senior Design\practice photos\main_building4\round3_IR';

buildingDirOriginal = fullfile(folderNameRGB);
buildingSceneOriginal = imageDatastore(buildingDirOriginal);

buildingDirSecondary = fullfile(folderNameIR);
buildingSceneSecondary = imageDatastore(buildingDirSecondary);


% Display images to be stitched
figure
montage(buildingSceneOriginal.Files)
figure
montage(buildingSceneSecondary.Files)

%% Step 1.5 - Crop Larger Image to Match Smaller Image size
% Need to crop the RGB images around the edges to match the same size of
% the smaller IR images

% Save the starting directory for the code
originalDirectory = cd;

% Name a new folder to create in location with the images
newFolderName = 'Reduced RGB Images';

% Check if a folder already exists to place the new images
% If not, create one
if not(exist(newFolderName,'dir'))
    mkdir(folderNameRGB, newFolderName)
    newFolderLocation = './Reduced RGB Images';
end

% Count number of images in the RGB image folder
numImages = numel(buildingSceneOriginal.Files);

% Read both the first RGB and IR images
I1 = readimage(buildingSceneOriginal, 1);    
I2 = readimage(buildingSceneSecondary, 1);

% all the images should be the same size
imageSizeI = size(I1);  % Size of the RGB image
imageSizeI2 = size(I2); % Size of the IR image

widthRGB = imageSizeI(2); % Width of each image
widthIR = imageSizeI2(2);

heightRGB = imageSizeI(1); % Height of each image
heightIR = imageSizeI2(1);

% Gap between the edges of each image, if both were centered at the same location
edgeWidthDiff = round((widthRGB - widthIR)/2);      
edgeHeightDiff = round((heightRGB - heightIR)/2);

% For loop to reduce the size of the RGB images to match that of the IR
% images. Saves them as a new set of images. 
for n = 1:numImages
        % Generate an empty matrix, same size as the IR images
        I1reduced = zeros(imageSizeI2(1),imageSizeI2(2),imageSizeI2(3),class(I2));
        
        % read the current RGB image
        I1 = readimage(buildingSceneOriginal, n);

        for i = edgeHeightDiff:(edgeHeightDiff+imageSizeI2(1)-1)            % Pixel Height location for fullsize image
            a = i - edgeHeightDiff + 1;                                     % Pixel Height location to be replaced on reduced version
           
            for j = edgeWidthDiff:(edgeWidthDiff+imageSizeI2(2)-1)          % Pixel Width location for fullsize image
                b = j - edgeWidthDiff + 1;                                  % Pixel Width location to be replaced on reduced version
               
                for d = 1:imageSizeI2(3) 
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
            imwrite(I1reduced, fullfile(folderNameRGB, newFolderName, ['reducedRGB-00',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(folderNameRGB, newFolderName);
            
        elseif n >= 10 && n <= 99   % indexes with 2 digits get 1 zero added to their name
            % Record the image names
            reducedImageName = ['reducedRGB-0',sprintf('%d',n)];
            reducedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(I1reduced, fullfile(folderNameRGB, newFolderName, ['reducedRGB-0',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(folderNameRGB, newFolderName);
                       
        elseif n >= 100 && n <= 999
            % Record the image names
            reducedImageName = ['reducedRGB-',sprintf('%d',n)];
            reducedImageFormat = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

            % write the reduced RGB image as a new file in the new folder
            imwrite(I1reduced, fullfile(folderNameRGB, newFolderName, ['reducedRGB-',sprintf('%d',n),'.jpg']), reducedImageFormat);
            reducedImageFolder = fullfile(folderNameRGB, newFolderName); 
        end
end

cd(originalDirectory)

%% Step 2 - Register Image Pairs 
% To create the panorama, start by registering successive image pairs using
% the following procedure:
%
% # Detect and match features between $I(n)$ and $I(n-1)$.
% # Estimate the geometric transformation, $T(n)$, that maps $I(n)$ to $I(n-1)$.
% # Compute the transformation that maps $I(n)$ into the panorama image as $T(n) * T(n-1) * ... * T(1)$.

vSet = viewSet;

% load in the directory for the newly created reduced RGB images
buildingDirReducedRGB = fullfile(reducedImageFolder);
buildingSceneReducedRGB = imageDatastore(buildingDirReducedRGB);

figure
montage(buildingSceneReducedRGB.Files)

% Read the first image from the image set.
I1r = readimage(buildingSceneReducedRGB, 1);
I2 = readimage(buildingSceneSecondary, 1);

% Initialize features for I(1)
grayImage = rgb2gray(I1r);
points = detectSURFFeatures(grayImage);
[features, points] = extractFeatures(grayImage, points);
% vSet = addView(vSet, 1, 'Points', points, 'Orientation',...
%     orientations(:,:,1), 'Location', locations(1,:));

% Initialize all the transforms to the identity matrix. Note that the
% projective transform is used here because the building images are fairly
% close to the camera. Had the scene been captured from a further distance,
% an affine transform would suffice.
numImages = numel(buildingSceneReducedRGB.Files);
tforms(numImages) = projective2d(eye(3));


% Iterate over remaining image pairs
for n = 2:numImages
    
    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;
        
    % Read I(n).
    I1r = readimage(buildingSceneReducedRGB, n);
    
    % Detect and extract SURF features for I(n).
    grayImage = rgb2gray(I1r);    
    points = detectSURFFeatures(grayImage);    
    [features, points] = extractFeatures(grayImage, points);
  
    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
       
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);  
    
    % Estimate the transformation between I(n) and I(n-1).
    tforms(n) = estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    
    % Compute T(n) * T(n-1) * ... * T(1)
    tforms(n).T = tforms(n).T * tforms(n-1).T; 
end

%%
% At this point, all the transformations in |tforms| are relative to the
% first image. This was a convenient way to code the image registration
% procedure because it allowed sequential processing of all the images.
% However, using the first image as the start of the panorama does not
% produce the most aesthetically pleasing panorama because it tends to
% distort most of the images that form the panorama. A nicer panorama can
% be created by modifying the transformations such that the center of the
% scene is the least distorted. This is accomplished by inverting the
% transform for the center image and applying that transform to all the
% others.
%
% Start by using the |projective2d| |outputLimits| method to find the
% output limits for each transform. The output limits are then used to
% automatically find the image that is roughly in the center of the scene.

imageSizeI1r = size(I1r);  % all the images are the same size
imageSizeI2 = size(I2);

% Compute the output limits  for each transform
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSizeI1r(2)], [1 imageSizeI1r(1)]);
end

%%
% Next, compute the average X limits for each transforms and find the image
% that is in the center. Only the X limits are used here because the scene
% is known to be horizontal. If another set of images are used, both the X
% and Y limits may need to be used to find the center image.

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim); % idx indexes the avgXLim contents after sorting

% Estimates the "center" image, by finding the median for the number of images in the set
centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx); % determine index of center image

%%
% Finally, apply the center image's inverse transform to all the others.

Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)    
    tforms(i).T = tforms(i).T * Tinv.T;
end


%% Step 3 - Initialize the Panorama
% Now, create an initial, empty, panorama into which all the images are
% mapped. 
% 
% Use the |outputLimits| method to compute the minimum and maximum output
% limits over all transformations. These values are used to automatically
% compute the size of the panorama.

for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSizeI1r(2)], [1 imageSizeI1r(1)]);
end

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([imageSizeI1r(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSizeI1r(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I1r);

%% Step 4 - Create the Panorama
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImages
    
    I1r = readimage(buildingSceneReducedRGB, i);   
    
    % Transform I into the panorama.
    warpedImage = imwarp(I1r, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I1r,1),size(I1r,2)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure
imshow(panorama)
hold on 

%%
figure
imshow(panorama)
hold on 
disp('Pick top left and bottom right corner of desired box')
[xbox,ybox] = ginput(2)
% xbox=[5900 8000];
% ybox=[1200 3200]; 
h=fill([xbox(1),xbox(2),xbox(2),xbox(1)],[ybox(1),ybox(1),ybox(2),ybox(2)],'red');
h.FaceAlpha=0.3;
xbox_lim=xbox+xMin;
ybox_lim=ybox+yMin;
a=0;
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



%% IR image overlay
% Create a second panorama, using the set of IR images and the transforms
% used to stitch the first set of images together. 

panorama2 = zeros([height width 3], 'like', I1);

for n = 1:numImages    
    I2 = readimage(buildingSceneSecondary, n);   
      
    % Transform I into the panorama.
    warpedImage = imwarp(I2, tforms(n), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I2,1),size(I2,2)), tforms(n), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama2 = step(blender, panorama2, warpedImage, mask);
   
end

figure
imshow(panorama2)

figure
overlayIR = imfuse(panorama, panorama2,'falsecolor','ColorChannels','red-cyan');
imshow(overlayIR)


