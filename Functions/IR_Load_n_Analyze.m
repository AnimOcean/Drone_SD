%% Drexel University Senior Design: Group P28
% Advisor: Antonios Kontsos
% Team: Spencer Krok, Elizabeth McDaniel, James Blackmer, Jose Alvarez,
% Medhin Chane

% File: Load IR Images from computer harddrive, perform analysis to
% evaluate their usability.
clear all;
close all;
clc;

%% Loading IR images
% Attempting to prompt the user to load images through windows explorer
% when code runs.
    
addpath('E:\DREXEL STUFF\SENIOR DESIGN\IR Data\January Flight Data\img71-82 Analysis')

folderNameIR = 'E:\DREXEL STUFF\SENIOR DESIGN\IR Data\January Flight Data\img71-82 Analysis';

% Name a new folder to create in location with the images
newFolderNameIR = 'Manipulated IR Images';

% Check if a folder already exists to place the new images
% If not, create one
if not(exist(newFolderNameIR,'dir'))
    mkdir(folderNameIR, newFolderNameIR)
    newFolderLocationIR = './Reduced RGB Images';
end

% Read all .csv files in the selected directory
allFiles = dir('E:\DREXEL STUFF\SENIOR DESIGN\IR Data\January Flight Data\img71-82 Analysis\*.csv');
imgHandles = {allFiles.name};

numFiles = length(imgHandles);  % the number of .csv files loaded

tempCount = 0;

for i = 1:numFiles
    % Read each .csv file containing an IR image's temperature data
    imgMatrix{i} = xlsread(imgHandles{i});

    pixels = size(imgMatrix{i});
    
    tempCount = tempCount + pixels(1)*pixels(2);    
    
    % Calculate Max, Min, and Range for the thermogram's temperature data
    minTemp{i} = min(min(imgMatrix{i}));
    maxTemp{i} = max(max(imgMatrix{i}));
    rangeTemp{i} = maxTemp{i} - minTemp{i};
end

%% Basic Statistical Analysis based on recorded values
% Initialize Vectors
maxVector = zeros(1,numFiles); % Maximum Temperature values for each IR image loaded in
minVector = zeros(1, numFiles); % Minimum Temperature values for each IR image loaded in
rangeVector = zeros(1, numFiles); % Temperature Range values for each IR image loaded in

tempVector = zeros(tempCount, 1); % Vector containing all temperature values in each pixel of each IR image loaded in
index = 0;

for i = 1:numFiles  % Transfer cell array contents to vectors
    maxVector(i) = maxTemp{i};
    minVector(i) = minTemp{i};
    rangeVector(i) = rangeTemp{i};
    
    imgMean(i) = mean(mean(imgMatrix{i}));
    matrix = imgMatrix{i};
    imgStdev(i) = mean(std(matrix));
    
    for n = 1:pixels(1)*pixels(2)
        index = index + 1;
        tempVector(index) = imgMatrix{i}(n);
    end
    tempTotalMean = mean(tempVector);
end

setMean = mean(imgMean);
setStdev = mean(imgStdev);

sorted = sort(tempVector);

% Mean values of each Max Temp, Min Temp, and Temp Range
maxMean = mean(maxVector);
minMean = mean(minVector);
rangeMean = mean(rangeVector);

% Standard deviations of each Max Temp, Min Temp, and Temp Range
maxStdev = std(maxVector);
minStdev = std(minVector);
rangeStdev = std(rangeVector);

% Determining thresholding limits based on each picture
maxLimit = maxMean + maxStdev;
minLimit = minMean + minStdev;
rangeLimit = rangeMean + rangeStdev;


%% Thresholding and Plotting results
for i = 1:numFiles
    % Create a figure to display the IR image
    figure('rend','painters','pos',[100 75 1200 875])
    figIR{i} = figure(i);
    
    % Plot the original, unaltered image
    subplot(2,2,1)
    currentIRimage = imgMatrix{i};
    currentIRimage = rescale(currentIRimage);
    cmapIR = gray(256);
    
    originalIR = ind2gray(ceil(size(cmapIR,1)*currentIRimage),cmapIR);
    imagesc(originalIR)

    imagesc(imgMatrix{i},'CDataMapping','scaled');
%     originalIR = imgMatrix{i}
    ax = gca;
%    lim1 = caxis
    colormap default
    colorbar
    title(sprintf('%s - Raw Data', imgHandles{i}))
    axis image
    axis off
       
    disp(i)
% if statements checking the number of significant figures for the image's index
    if i >= 1 && i <= 9     % the first 9 images have extra zeros added to their name
                            % maintains consistent naming convention that is read in the correct order
        % Record the image names
        originalImageNameIR = ['originalIR-00',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameIR, ['originalIR-00',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameIR);

    elseif i >= 10 && i <= 99   % indexes with 2 digits get 1 zero added to their name
        % Record the image names
        originalImageNameIR = ['originalIR-0',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameIR, ['originalIR-0',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameIR);

    elseif i >= 100 && i <= 999
        % Record the image names
        originalImageNameIR = ['originalIR-',sprintf('%d',i)];
        originalImageFormatIR = 'jpg';                                         % SHOULD MAKE THIS MATCH THE FORMAT OF THE ORIGINAL IMAGES LATER

        % write the reduced RGB image as a new file in the new folder
        imwrite(originalIR, fullfile(folderNameIR, newFolderNameIR, ['originalIR-',sprintf('%d',i),'.jpg']), originalImageFormatIR);
        reducedImageFolder = fullfile(folderNameIR, newFolderNameIR); 
    end    

    
    
    %------------------------------------------------------------------------------------   

    % Determination of scaling factor to perform IR Thresholding
    scaleFactor = 0.8;
    scaleRange{i} = rangeTemp{i}*scaleFactor;
    
    % Calculate Type 1 Threshold limit
    threshold1{i} = minTemp{i} + scaleRange{i};
    tempIndexThresh1 = find(imgMatrix{i} < threshold1{i});
    
    % Scale new image to highlight threshold target
    scaleMatrix1{i} = imgMatrix{i};
    scaleMatrix1{i}(tempIndexThresh1) = imgMatrix{i}(tempIndexThresh1)/3;
    
    % Plot second image after Type 1 Threshold Scaling
    subplot(2,2,2)
    image(scaleMatrix1{i},'CDataMapping','scaled')
%     lim2 = caxis
    title(sprintf('%s - Type 1 Thresholding', imgHandles{i}))
    axis image
    axis off
     
    %------------------------------------------------------------------------------------   

    % Calculate Type 2 Threshold limits
    threshold2upper = setMean + 4*setStdev;
    threshold2lower = setMean - 4*setStdev;
    tempIndexCritical3 = find(imgMatrix{i});
    tempIndexThresh2 = find(imgMatrix{i} < threshold2upper);
    
    if threshold2upper > maxTemp{i}
        threshold2upper = maxTemp{i};
    end
    
    % Scale new image to highlight threshold Type 2 target
    scaleMatrix2{i} = imgMatrix{i};
    scaleMatrix2{i}(tempIndexThresh2) = rescale(imgMatrix{i}(tempIndexThresh2),min(minVector),(max(maxVector)-min(minVector))/4);
    
    % Plot second image after Type 1 Threshold Scaling
    subplot(2,2,3)
    image(scaleMatrix2{i},'CDataMapping','scaled')
    caxis([min(minVector) max(maxVector)])
%     lim3 = caxis
    title(sprintf('%s - Type 2 Thresholding', imgHandles{i}))
    axis image
    axis off
 
    %------------------------------------------------------------------------------------   
    
    % Calculate Type 3 Threshold limits
    threshold3upper = maxMean + maxStdev;
    threshold3lower = minMean - minStdev;
    tempIndexCritical3 = find(imgMatrix{i});
    tempIndexThresh3 = find(imgMatrix{i} < threshold3upper);
    
    tempIndexCritical3(tempIndexThresh3) = [];
    
    if threshold3upper > maxTemp{i}
        threshold3upper = maxTemp{i};
    end
    
    % Scale new image to highlight threshold Type 3 target
    scaleMatrix3{i} = imgMatrix{i};
    scaleMatrix3{i}(tempIndexThresh3) = rescale(imgMatrix{i}(tempIndexThresh3),min(minVector),(max(maxVector)-min(minVector))/4); 
    
    % Plot second image after Type 1 Threshold Scaling
    subplot(2,2,4)
    image(scaleMatrix3{i},'CDataMapping','scaled')
    caxis([min(minVector) max(maxVector)])
%     lim4 = caxis
    title(sprintf('%s - Type 3 Thresholding', imgHandles{i}))
    axis image
    axis off
    
end


%% Alternate Data Visualization

% Thresholding Type 2: "Light" Full-Data Thresholding
% Histogram showing the total temperature distribution for all pictures
% loaded in, highlighting the limits of the first 4 standard deviations
% from the mean value of the data. 
figure
histogram(sorted);
hold on;
line([setMean, setMean], ylim, 'Color', 'c','LineWidth',2)
line([setMean+setStdev, setMean+setStdev], ylim, 'Color', 'g','LineWidth',2)
line([setMean-setStdev, setMean-setStdev], ylim, 'Color', 'g','LineWidth',2)
line([setMean+2*setStdev, setMean+2*setStdev], ylim, 'Color', 'y','LineWidth',2)
line([setMean-2*setStdev, setMean-2*setStdev], ylim, 'Color', 'y','LineWidth',2)
line([setMean+3*setStdev, setMean+3*setStdev], ylim, 'Color', 'y','LineWidth',2)
line([setMean-3*setStdev, setMean-3*setStdev], ylim, 'Color', 'y','LineWidth',2)
line([setMean+4*setStdev, setMean+4*setStdev], ylim, 'Color', 'r','LineWidth',2)
line([setMean-4*setStdev, setMean-4*setStdev], ylim, 'Color', 'r')
title('Full Temperature Range')


% Thresholding Type 3: "Heavy" Limit Data Thresholding
% Upper Limit based on Max Values for each picture
figure
histogram(maxVector,'BinMethod','integers');
hold on;
line([maxMean, maxMean], ylim, 'Color', 'g','LineWidth',2)
line([maxMean+maxStdev, maxMean+maxStdev], ylim, 'Color', 'y','LineWidth',2)
line([maxMean-maxStdev, maxMean-maxStdev], ylim, 'Color', 'y','LineWidth',2)
line([maxMean+2*maxStdev, maxMean+2*maxStdev], ylim, 'Color', 'r','LineWidth',2)
line([maxMean-2*maxStdev, maxMean-2*maxStdev], ylim, 'Color', 'r','LineWidth',2)
title('Distribution of Max Temperatures')

figure
histogram(minVector,'BinMethod','integers');
hold on;
line([minMean, minMean], ylim, 'Color', 'g','LineWidth',2)
line([minMean+minStdev, minMean+minStdev], ylim, 'Color', 'y','LineWidth',2)
line([minMean-minStdev, minMean-minStdev], ylim, 'Color', 'y','LineWidth',2)
line([minMean+2*minStdev, minMean+2*minStdev], ylim, 'Color', 'r','LineWidth',2)
line([minMean-2*minStdev, minMean-2*minStdev], ylim, 'Color', 'r','LineWidth',2)
title('Distribution of Min Temperatures')





