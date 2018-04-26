close all; clear all; 
referenceImage = rgb2gray(imread('Screen Shot 2018-01-11 at 4.40.57 PM.png'));
figure;
imshow(referenceImage);
title('Image of an HVAC');

targetImage = rgb2gray(imread('Screen Shot 2017-11-14 at 4.26.17 PM.png'));
figure;
imshow(targetImage);
title('Image of a Cluttered Scene');

hvacPoints = detectSURFFeatures(referenceImage);
scenePoints = detectSURFFeatures(targetImage);

figure;
imshow(referenceImage);
title('100 Strongest Feature Points from HVAC Image');
hold on;
plot(selectStrongest(hvacPoints, 100));

figure;
imshow(targetImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

[hvacFeatures, hvacPoints] = extractFeatures(referenceImage, hvacPoints);
[sceneFeatures, scenePoints] = extractFeatures(targetImage, scenePoints);

hvacPairs = matchFeatures(hvacFeatures, sceneFeatures);

matchedHvacPoints = hvacPoints(hvacPairs(:, 1), :);
matchedScenePoints = scenePoints(hvacPairs(:, 2), :);
figure;
showMatchedFeatures(referenceImage, targetImage, matchedHvacPoints, matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

[tform, inlierHvacPoints, inlierScenePoints] = estimateGeometricTransform(matchedHvacPoints, matchedScenePoints, 'affine');

figure;
showMatchedFeatures(referenceImage, targetImage, inlierHvacPoints, inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

hvacPolygon = [1, 1;size(referenceImage, 2), 1;size(referenceImage, 2), size(referenceImage, 1);1, size(referenceImage, 1);1, 1];
  
newHvacPolygon = transformPointsForward(tform, hvacPolygon);

figure;
imshow(targetImage);
hold on;
line(newHvacPolygon(:, 1), newHvacPolygon(:, 2), 'Color', 'y');
title('Detected HVAC');