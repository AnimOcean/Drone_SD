function [edited_image] = selectWindow(I, boundary)
%%SELECTWINDOW Crop window for desired features
% I - black and white image
% boundary - [x1 y1; x2 y2] boundary values


x = boundary(:,1);
y = boundary(:,2);
[h,w] = size(I);
x_bool = [min(x) > 0, max(x) < w];
y_bool = [min(y) > 0, max(y) < h];
x = int16(x_bool.*[min(x) max(x)] + (~x_bool).*[1 w]);
y = int16(y_bool.*[min(y) max(y)] + (~y_bool).*[1 h]);

edited_image = (I(y(1):y(2), x(1):x(2),:));

end

