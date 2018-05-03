close all; clear all; 
referenceImage = rgb2gray(imread('ref7.jpg'));
figure;
imshow(referenceImage);
title('Image of a Reference');

targetImage = rgb2gray(imread('tar5.jpg'));
figure;
imshow(targetImage);
title('Image of a Target');

referencePoints = detectSURFFeatures(referenceImage);
targetPoints = detectSURFFeatures(targetImage);

figure;
imshow(referenceImage);
title('100 Strongest Feature Points from Reference Image');
hold on;
plot(selectStrongest(referencePoints, 100000));

figure;
imshow(targetImage);
title('300 Strongest Feature Points from Target Image');
hold on;
plot(selectStrongest(targetPoints, 100000));

[referenceFeatures, referencePoints] = extractFeatures(referenceImage, referencePoints);
[targetFeatures, targetPoints] = extractFeatures(targetImage, targetPoints);

referencePairs = matchFeatures(referenceFeatures, targetFeatures);

matchedRefPoints = referencePoints(referencePairs(:, 1), :);
matchedTarPoints = targetPoints(referencePairs(:, 2), :);
figure;
showMatchedFeatures(referenceImage, targetImage, matchedRefPoints, matchedTarPoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

[tform, inlierRefPoints, inlierTarPoints] = estimateGeometricTransform(matchedRefPoints, matchedTarPoints, 'affine');

figure;
showMatchedFeatures(referenceImage, targetImage, inlierRefPoints, inlierTarPoints, 'montage');
title('Matched Points (Inliers Only)');

referencePolygon = [1, 1;size(referenceImage, 2), 1;size(referenceImage, 2), size(referenceImage, 1);1, size(referenceImage, 1);1, 1];
  
newRefPolygon = transformPointsForward(tform, referencePolygon);

figure;
imshow(targetImage);
hold on;
line(newRefPolygon(:, 1), newRefPolygon(:, 2), 'Color', 'y');
title('Detected Object');