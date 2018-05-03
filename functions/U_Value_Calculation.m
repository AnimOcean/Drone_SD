close all;
clear all;
clc;

%% Loading IR Images
addpath('C:\Users\Jose Alvarez\Desktop\IR Images')
allFiles = dir('C:\Users\Jose Alvarez\Desktop\IR Images\*.csv');

imgHandles = {allFiles.name};
numFiles = length(imgHandles);

% U-Value Calculation Values (Convection Only)
h_inf = 10.45; % W/(m^2*K)
T_in = 298; % K
T_out = 273; % K

for i = 1:numFiles
    imgMatrix{i} = xlsread(imgHandles{i});
    pixels{i} = size(imgMatrix{i});
    area{i} = prod(cell2mat(pixels(i)));
    
    % U-Value Calculation (per Pixel)
    U_Value{i} = h_inf*((cell2mat(imgMatrix(i))+273)-T_out)/(T_in-T_out); % W/(m^2*K)
end

cell2mat(U_Value(1))