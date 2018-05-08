% Auto-generated by cameraCalibrator app on 06-May-2018
%-------------------------------------------------------

FolderLocation = 'C:\Users\liz_surface5\Desktop\Senior Design\duo pro r\calibration_photos4';


% Define images to process
imageFileNames = {fullfile(FolderLocation,'20180503_170155_857_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170200_359_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170206_468_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170215_473_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170221_980_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170225_483_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170230_958_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170246_088_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170250_378_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170257_683_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170320_671_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170323_178_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170325_678_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170328_380_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170344_062_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170351_870_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170354_572_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170358_578_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170401_579_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170405_688_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170408_988_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170413_458_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170419_868_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170423_568_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170433_578_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170437_282_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170500_071_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170504_778_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170512_688_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170519_158_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170522_461_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170528_768_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170536_478_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170540_378_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170544_683_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170551_658_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170555_160_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170559_468_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170602_968_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170607_471_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170613_578_8b.JPG'),...
    fullfile(FolderLocation,'20180503_170616_080_8b.JPG'),...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
% h1=figure; 
% showReprojectionErrors(cameraParams);

% Visualize pattern locations
% h2=figure; 
% showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
% displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
% undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
