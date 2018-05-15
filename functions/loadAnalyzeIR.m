%% Drexel University Senior Design: Group P28
% Advisor: Antonios Kontsos
% Team: Spencer Krok, Elizabeth McDaniel, James Blackmer, Jose Alvarez,
% Medhin Chane

% File: Load IR Images from computer harddrive, perform analysis to
% evaluate their usability.
% clear all;
% close all;
% clc;
% function loadAnalyzeIR(windowBlockOut)
function loadAnalyzeIR(directory)

%% Loading IR images
% Attempting to prompt the user to load images through windows explorer
% when code runs.
    
% baseFolder = baseFolder;
folderNameIR = 'E:\DREXEL STUFF\SENIOR DESIGN\IR Data\4-28-18 data\Tiffs\Test 1';
addpath(folderNameIR);

% Name a new folder to create in location with the images
newFolderNameOriginalIR = 'Original IR Images';
newFolderNameThresholdIR = 'Threshold IR Images';

% Check if a folder already exists to place the new images
% If not, create one
if not(exist(newFolderNameOriginalIR,'dir'))
    mkdir(folderNameIR, newFolderNameOriginalIR);
    newFolderLocationIR = './Original IR Images';
end

% Create another new folder for the IR images that have gone through
% thresholding
% The program should be able to use either set as a threshold
if not(exist(newFolderNameThresholdIR,'dir'))
    mkdir(folderNameIR, newFolderNameThresholdIR);
    newFolderLocationIR = './Threshold IR Images';
end

% Read all .csv files in the selected directory
allFiles = dir('E:\DREXEL STUFF\SENIOR DESIGN\IR Data\4-28-18 data\Tiffs\*.tiff');
imgHandles = {allFiles.name};   % Filename for each image
numFiles = length(imgHandles);  % the number of .tiff files loaded

tempCount = 0;  % Initialize the variable, counts total number of temperature data points across all images

for i = 1:numFiles
    % Read each .csv file containing an IR image's temperature data
    imgMatrixIR{i} = im2double(imread(imgHandles{i}),'indexed')*0.04-273.15;
   
    pixels = size(imgMatrixIR{i});
    
    % Count total number of temperature data points across all images
    tempCount = tempCount + pixels(1)*pixels(2);    
end

%% Basic Statistical Analysis based on recorded values
% Initialize Vectors

tempVector = zeros(tempCount, 1); % Vector containing all temperature values in each pixel of each IR image loaded in
index = 0;

for i = 1:numFiles  % Transfer cell array contents to vectors
    % Store all temperature values in the set of images in a single
    % variable
    for n = 1:pixels(1)*pixels(2)
        index = index + 1;
        tempVector(index) = imgMatrixIR{i}(n);
    end
end

% ALL TEMPERATURES, SORTED
sorted = sort(tempVector);

%% Split images into sections

% for n = 1:23
%     windowBlockout{n} = imresize(windowBlockOut{n},[size(imgMatrixIR{n}(1)) size(imgMatrixIR{n}(2))]);
% end

%% Quartile Calculations

tempMedian = median(sorted); 	% Calculate the Median value for the set 

% First Quartile = Bottom 25% of data
botQuartile = mean(quantile(sorted,0.15));

% Third Quartile = Top 25% of data
topQuartile = mean(quantile(sorted,0.85));

% Range between quartiles
interQuartileRange = topQuartile - botQuartile;

% Range for determining minor outliers (to be highlighted)
innerFence = interQuartileRange*1.5;

% Range for determining Major outliers (to be removed)
outerFence = interQuartileRange*3;

% Limits for  minor outliers (to be highlighted)
upperSoftLimit = tempMedian + innerFence/1.5;
lowerSoftLimit = tempMedian - innerFence/1.5;

% limits for Major outliers (to be removed)
upperHardLimit = tempMedian + outerFence/1.5;
lowerHardLimit = tempMedian - outerFence/1.5;

%% Scale back any extreme outliers
% Extreme Outliers considered as values above or below the HardLimits set above

for i = 1:numFiles
    % Initialize cell arrays to store manipulated IR images
    threshMatrixIR{i} = imgMatrixIR{i}; 
    
    % Within each image, index the positions of outliers
    topOutlierIndex{i} = find(imgMatrixIR{i} > upperHardLimit);
    botOutlierIndex{i} = find(imgMatrixIR{i} < lowerHardLimit);
    
    scaleBackIndex{i} = find(imgMatrixIR{i} < upperSoftLimit);
    
    % Replace all outlying values that exceed the outer limits with the
    % limiting value itself
    threshMatrixIR{i}(topOutlierIndex{i}) = upperHardLimit;
    threshMatrixIR{i}(botOutlierIndex{i}) = lowerHardLimit;
    
    % Rescale the parts of the temperature matrix that are not considered
    % hotspots. This is purely for Visualization purposes. 
    % "ThreshMatrixIR" should not be considered actual quantiative data
    threshMatrixIR{i}(scaleBackIndex{i}) = rescale(threshMatrixIR{i}(scaleBackIndex{i}),lowerSoftLimit,tempMedian);
end


%% Thresholding and Plotting results
for i = 1:numFiles
    % Create a figure to display the IR image
    
    % The following lines with currentIRimage, cmapIR, are used to save the
    % IR data as an image. 
    currentIRimage = imgMatrixIR{i};
    
    % Option 1: Scaling for the total range of data
%     currentIRimage = rescale(currentIRimage,'InputMin',lowerHardLimit,'InputMax',upperHardLimit);
    
    % Option 2: Scaling each image individually
    currentIRimage = rescale(currentIRimage);

    cmapIR1 = parula(256); % Set colormap for saving as PARULA
    
    originalIR = ind2rgb(ceil(size(cmapIR1,1)*currentIRimage),cmapIR1);
    originalIR = imresize(originalIR,3);
       
% if statements checking the number of significant figures for the image's index
    if i >= 1 && i <= 9     % the first 9 images have extra zeros added to their name
                            % maintains consistent naming convention that is read in the correct order
        % Record the image names
        originalImageNameIR = ['originalIR-00',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameOriginalIR, ['originalIR-00',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameOriginalIR);

    elseif i >= 10 && i <= 99   % indexes with 2 digits get 1 zero added to their name
        % Record the image names
        originalImageNameIR = ['originalIR-0',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameOriginalIR, ['originalIR-0',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameOriginalIR);

    elseif i >= 100 && i <= 999
        % Record the image names
        originalImageNameIR = ['originalIR-',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameOriginalIR, ['originalIR-',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameOriginalIR); 
    end    

    %------------------------------------------------------------------------------------   
    
    % Plot second image after Threshold Scaling
%     subplot(1,2,2)
   
    currentIRthresh = threshMatrixIR{i};
    currentIRthresh = rescale(currentIRthresh,'InputMin',lowerSoftLimit,'InputMax',upperHardLimit);
   
    cmapIR2 = parula(256);  % Set colormap for saving as PARULA
 
    % Convert the image to an rgb image with a specific colormap
    threshIR = ind2rgb(ceil(size(cmapIR2,1)*currentIRthresh),cmapIR2);
    threshIR = imresize(threshIR,3);

    % if statements checking the number of significant figures for the image's index
    if i >= 1 && i <= 9     % the first 9 images have extra zeros added to their name
                            % maintains consistent naming convention that is read in the correct order
        % Record the image names
        threshImageNameIR = ['ThresholdIR-00',sprintf('%d',i)];
        threshImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(threshIR, fullfile(folderNameIR, newFolderNameThresholdIR, ['ThresholdIR-00',sprintf('%d',i),'.jpg']), threshImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameThresholdIR);

    elseif i >= 10 && i <= 99   % indexes with 2 digits get 1 zero added to their name
        % Record the image names
        threshImageNameIR = ['ThresholdIR-0',sprintf('%d',i)];
        threshImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(threshIR, fullfile(folderNameIR, newFolderNameThresholdIR, ['ThresholdIR-0',sprintf('%d',i),'.jpg']), threshImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameThresholdIR);

    elseif i >= 100 && i <= 999
        % Record the image names
        threshImageNameIR = ['ThresholdIR-',sprintf('%d',i)];
        threshImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(threshIR, fullfile(folderNameIR, newFolderNameThresholdIR, ['ThresholdIR-',sprintf('%d',i),'.jpg']), threshImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameThresholdIR); 
    end 
end


%% Alternate Data Visualization

% figure
% histogram(sorted);
% hold on;
% line([tempMedian, tempMedian], ylim, 'Color', 'c','LineWidth',2)
% % line([setMean+setStdev, setMean+setStdev], ylim, 'Color', 'g','LineWidth',2)
% % line([setMean-setStdev, setMean-setStdev], ylim, 'Color', 'g','LineWidth',2)
% line([upperSoftLimit, upperSoftLimit], ylim, 'Color', 'y','LineWidth',2)
% line([lowerSoftLimit, lowerSoftLimit], ylim, 'Color', 'y','LineWidth',2)
% line([upperHardLimit, upperHardLimit], ylim, 'Color', 'r','LineWidth',2)
% line([lowerHardLimit, lowerHardLimit], ylim, 'Color', 'r')
% title('Full Temperature Range')
% hold off

disp('done')
