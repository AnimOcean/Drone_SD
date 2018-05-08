% Prepare work space
close all; clear all; clc;

% Input and resize image
input_img = strcat('test_images/','liz2','.jpg');
img = imread(input_img);
img = imresize(img,[1500 NaN]);
edgesbinary = zeros(size(img));
img_copy2 = img;

% Set threshold level
thresh = 6;

% Add padding around image
img = padarray(img, [thresh/2 thresh/2], 0, 'both');
img_copy = img;

figure(001)
imshow(img_copy)

% Apply gaussian filter
img_copy = imgaussfilt(img_copy,3.5);

% Convert image to grayscale
img = rgb2gray(img_copy);

figure(002)
imshow(img)

% Get image edges using a canny edge detector
edges = edge(img,'canny');
edges = imdilate(edges,strel('rectangle',[8 8]));

figure(003)
imshow(edges)

% Apply edge thresholding
for i=thresh+1:size(img_copy,1)-thresh
    for j=thresh+1:size(img_copy,2)-thresh
        if edges(i,j) == 1
            
            % Add rgb color values on the left side of edge pixel
            lsumr = sum(sum(img_copy(i-thresh/2:i+thresh/2,j-thresh:j,1)));
            lsumg = sum(sum(img_copy(i-thresh/2:i+thresh/2,j-thresh:j,2)));
            lsumb = sum(sum(img_copy(i-thresh/2:i+thresh/2,j-thresh:j,3)));
            
            % Add rgb color values on the right side of edge pixel
            rsumr = sum(sum(img_copy(i-thresh/2:i+thresh/2,j:j+thresh,1)));
            rsumg = sum(sum(img_copy(i-thresh/2:i+thresh/2,j:j+thresh,2)));
            rsumb = sum(sum(img_copy(i-thresh/2:i+thresh/2,j:j+thresh,3)));
            
            % Add rgb color values on the top side of edge pixel
            tsumr = sum(sum(img_copy(i-thresh:i,j-thresh/2:j+thresh/2,1)));
            tsumg = sum(sum(img_copy(i-thresh:i,j-thresh/2:j+thresh/2,2)));
            tsumb = sum(sum(img_copy(i-thresh:i,j-thresh/2:j+thresh/2,3)));
            
            % Add rgb color values on the top side of edge pixel
            bsumr = sum(sum(img_copy(i:i+thresh,j-thresh/2:j+thresh/2,1)));
            bsumg = sum(sum(img_copy(i:i+thresh,j-thresh/2:j+thresh/2,2)));
            bsumb = sum(sum(img_copy(i:i+thresh,j-thresh/2:j+thresh/2,3)));
            
            % Find average color values of all 4 sides of edge pixel
            avgr = (lsumr + rsumr + tsumr + bsumr) / 4;
            avgg = (lsumg + rsumg + tsumg + bsumg) / 4;
            avgb = (lsumb + rsumb + tsumb + bsumb) / 4;
            
            
            error_allow_r = abs(img_copy(i,j,1)-avgr)*1.0;
            error_allow_g = abs(img_copy(i,j,2)-avgg)*1.0;
            error_allow_b = abs(img_copy(i,j,3)-avgb)*1.0;
            
            right = 0;
            left = 0;
            top = 0;
            bottom = 0;
            
            if lsumr - avgr <= error_allow_r && lsumg - avgg <= error_allow_g && lsumb - avgb <= error_allow_b
                left = 1;
            end
            if rsumr - avgr <= error_allow_r && rsumg - avgg <= error_allow_g && rsumb - avgb <= error_allow_b
                right = 1;
            end
            if tsumr - avgr <= error_allow_r && tsumg - avgg <= error_allow_g && tsumb - avgb <= error_allow_b
                top = 1;
            end
            if bsumr - avgr <= error_allow_r && bsumg - avgg <= error_allow_g && bsumb - avgb <= error_allow_b
                bottom = 1;
            end
            
            score = top + bottom + left + right;
            
            % We are not near edges etc, since averages of all
            % top,left,bottom and right segments are similar and also similar
            % to the value at the current pixel. So we discard these edges
            % if they are present in the gradient image. We do this in the
            % filtered image so this would ignore small variations.
            if score == 4
                %                     edges(i,j) = 0;
                edges(i,j) = edges(i,j);
            else
                edges(i,j) = 1;
            end
            
        end
    end
end

edges_new = edges;

figure(004)
imshow(edges_new)

% Join up small disconnected edges since these generally correspond to the
% same component and need to be connected
for i = 3:size(edges,1)-2
    for j = 3:size(edges,2)-2
        
        % If one of two pixels above and below is edge, set current to edge 
        if (edges(i+2,j) == 1 || edges(i+1,j) == 1) && (edges(i-1,j) == 1 || edges(i-2,j) == 1)
            edges_new(i,j) = 1;
        end
        
        % If one of two pixels left and right is edge, set current to edge
        if (edges(i,j+2) == 1 || edges(i,j+1) == 1) && (edges(i,j-2) == 1 || edges(i,j-1) == 1)
            edges_new(i,j) = 1;
        end
    end
end
edges = edges_new;

figure(005)
imshow(edges)

% Consider regions and discard ones whose perimeters are too large or too
% small.
% Find connected components
conn = conndef(ndims(edges), 'minimal');
CC = bwconncomp(edges, conn);

% Find perimeter around boundary of connected components
D1 = regionprops(CC, 'perimeter');

perimeters = [D1.Perimeter];
[maxPerimeters] = max(perimeters);
[meanPerimeters] = mean(perimeters);
disp(maxPerimeters);

L = labelmatrix(CC);

% Remove connected components if perimeter is less than (mean perimeter)/4
% or if perimeter is greater than (1.5 * mean perimeter + max
% perimeter)/2.5
edges = ismember(L, find(([D1.Perimeter] <= (1.5*meanPerimeters + 1.0*maxPerimeters)/2.5) & ([D1.Perimeter] >= meanPerimeters/4.0)));

figure(006)
imshow(edges)

% Fill these components in with white colors
Ifill = imfill(edges,'holes');
imfinal = Ifill;

figure(007)
imshow(imfinal)

% Reduce the noise and small variations near the boundaries using a
% morphological opening
imfinal = imopen(imfinal,strel('rectangle',[5 5]));

conn = conndef(ndims(imfinal), 'minimal');
CC = bwconncomp(imfinal, conn);
D1 = regionprops(CC, 'area', 'perimeter');

areas = [D1.Area]
[meanArea] = mean(areas);
disp(meanArea);

L = labelmatrix(CC);

% Consider connected components and select regions with certain area
% constrians and the area to perimeter ratio is greater than or equal to
% 3.0; This is generally true for objects with shapes vaguely representing
% rectangles/circles for certain sizes (areas)
bwfinal = ismember(L, find(([D1.Area] >= meanArea/2.0) & ([D1.Area] <= meanArea*4.0) & ([D1.Perimeter] ./ [D1.Area] >= 0.5)));

figure(008)
imshow(bwfinal)

% Erode and then dilate to get a boundary of all the detected windows
edgesfinal = imdilate(bwfinal,strel('rectangle',[5 5])) - imerode(bwfinal,strel('rectangle',[5 5]));

% Add the window boundaries to the original image in red color
for i=1:size(img_copy2,1)
    for j=1:size(img_copy2,2)
        if edgesfinal(i,j) ~= 0.0
            img_copy2(i,j,1) = 255.0;
            img_copy2(i,j,2) = 0.0;
            img_copy2(i,j,3) = 0.0;
            edgesbinary(i,j) = 1;
        end
    end
end

figure(009)
imshow(img_copy2);

% Save output
imwrite(img_copy2, strcat(strcat('outputs/',int2str(1)),'.jpg'));

% for i = 1:size(edgesbinary,1)
%     for j = 1:size(edgesbinary,2)
%         if edgesbinary(i,j) == 1;
%             fprintf('\nEdge at row %d and column %d', i, j);
%         end
%     end
% end
% fprintf('\n');

