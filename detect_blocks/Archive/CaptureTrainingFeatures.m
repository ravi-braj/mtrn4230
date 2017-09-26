clear all; clc(); close all;

load('Labels1.mat');
sz = size(Labels);

%Extract features from label set
for k = 1:sz(1)
    I = imread(Labels.imageFilename{k});
    
    % Mask colors
    BW_Red = createRedMask(I);
    BW_Orange = createOrangeMask(I);
    BW_Yellow = createYellowMask(I);
    BW_Green = createGreenMask(I);
    BW_Blue = createBlueMask(I);
    BW_Purple = createPurpleMask(I);
    
    BW = BW_Red | BW_Orange | BW_Yellow | BW_Green | BW_Blue | BW_Purple;
    BW(1:250,:) = 0;
    
    % Remove Artifacts too small to be blocks
    stats = regionprops('table',BW,'Centroid','Area','PixelList');
    IdxList = find(stats.Area > 500);    % Must be big enough to be a block
    
    PixMap = cell2mat(stats.PixelList(IdxList));   %Capture largest group of pixels
    tmp = false(size(BW));   %Generate empty matrix
    tmp(PixMap(:,2),PixMap(:,1)) = true;    %Populate empty matrix with pixels from largest group
    BW = BW & tmp;    %Erase everything outside region
    
    Points = detectSURFFeatures(BW);
    [Features.f{k}, Features.p{k}] = extractFeatures(BW,Points);
    
    T_Points{k}(:,:) = Features.p{k}.Location(:,:);
    T_Features{k}(:,:) = Features.f{k}(:,:);
    T_BW{k}(:,:) = BW;
end