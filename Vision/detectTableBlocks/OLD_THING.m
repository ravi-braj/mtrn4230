function blocks = detectTableBlocks(I)
    % This function takes in a 1200 x 1600 image and detects the state of
    % the game (blocks in play: 6 player blocks + field blocks). The
    % function returns blocks = [x,y,colour,shape].
    
    I = imread('img4.jpg');
    
%==============New Image Set================    
    % Erase anything outside region of interest (Player Inventory + Board) 
     I(1:275,:,:) = 0; % Crop the top
       I(793:end,:,:) = 0; %Crop the bottom
     I(:,1:410,:) = 0; %Crop left side
    I(:,1190:end,:) = 0; %Crop Right side
    I(:,1060:1110,:) = 0; %Crop inventory right side
    I(:,490:538,:) = 0; %Crop inventory right side
     I(632:end,1110:1195,:) = 0;
     I(630:end,412:493,:) = 0;
    

%=========== Old Image set ========================
%     % Erase anything outside region of interest (Player Inventory + Board) 
%     I(1:380,:,:) = 0;
%      I(910:end,:,:) = 0;
%     I(:,1:412,:) = 0;
%    I(:,1195:end,:) = 0;
%    I(:,1060:1110,:) = 0;
%    I(:,493:544,:) = 0;
%     I(735:end,1110:1195,:) = 0;
%     I(740:end,412:493,:) = 0;

    figure(1); imshow(I);    
    % Create empty blocks matrix
    blocks = [];

    % Extract colours centers and colours.
    BW_Red = TableRedMask(I);
    blocks = ProcessMask(BW_Red, 1, blocks);
    BW_Orange = TableOrangeMask(I);
    blocks = ProcessMask(BW_Orange, 2, blocks);
    BW_Yellow = TableYellowMask(I);
    blocks = ProcessMask(BW_Yellow, 3, blocks);
    BW_Green = TableGreenMask(I);
    blocks = ProcessMask(BW_Green, 4, blocks);
    BW_Blue = TableBlueMask(I);
    blocks = ProcessMask(BW_Blue, 5, blocks);
    BW_Purple = TablePurpleMask(I);
    blocks = ProcessMask(BW_Purple, 6, blocks);
    
    % Generate colour/shape mask
    ColourMask = BW_Red | BW_Orange | BW_Yellow | BW_Green | BW_Blue | BW_Purple;
    
    % Apply colour/shape mask
    I(~ColourMask(:,:,[1, 1, 1])) = 0;
% 	figure(2); imshow(I);
    % Plot Centers
%     hold on;
%     plot(blocks(:,1),blocks(:,2),'r*');
    
    % Order the blocks list by x position before using classifier
    blocks = orderByPosition(blocks);

    % Extract shapes from colour/shape mask
    shape_stats = regionprops('table',ColourMask,'Area','Centroid','BoundingBox');
    ShapesIdx = find(shape_stats.Area > 50 && shape_stats.Area < 300);
    blocks = ClassifyShapes(blocks, ColourMask, shape_stats, ShapesIdx);
end

function c_out = ProcessMask(mask, colorID, c_in)
    % This extracts and sets block properties c_in from a single given masked 
    % colour of image.
    
    c_out = c_in;

    stats = regionprops('table',mask,'Centroid','Area');
    IdxList = find(stats.Area > 50 && stats.Area < 300);    % Must be big enough to be a shape
    
    if (n > 0)
        c_t = zeros(numel(IdxList),4);    % Create empty blocks array
        c_t(:,1:2) = stats.Centroid(IdxList,:);   % Fill centers
        c_t(:,3) = colorID;   % Set color
        
        vertcat(c_out,c_t);
    end
end

function c_out = orderByPosition(c_in)
    c_out = c_in;

    [sortedX, sortedX_idx] = sort(c_out(:,1));
    c_out(1:size(sortedX_idx,1),:) = c_in(sortedX_idx(:),:); 
end

function c_out = ClassifyShapes(c_in, mask, stats, idx)
    % Load Shape Classifier Training data
    load('T_Features.mat');
%     load('T_BW.mat');
%     load('T_Points.mat');
    
    % Extract features and feature points from shape mask
    I_Points = detectSURFFeatures(mask);
    I_Features = extractFeatures(mask,I_Points);
    
    shapeBounds = stats.BoundingBox(idx,:);
    x1 = shapeBounds(:,1)' - 10; x2 = x1 + shapeBounds(:,3)' + 10;
    y1 = shapeBounds(:,2)' - 10; y2 = y1 + shapeBounds(:,4)' + 10;
    
    sz_T = size(T_Features,2);
    sz = size(blocks,1);
    vote = zeros(6,sz);
    
%     figure(3);
    
    % iterate through shape training data
    for k = 1:sz_T
        matchedFeatures = matchFeatures(I_Features, T_Features{k});
        matchedPoints_I = I_Points.Location(matchedFeatures(:, 1), :);
%         matchedPoints_T = T_Points{k}(matchedFeatures(:,2),:);
        
        X = matchedPoints_I(:,1); Y = matchedPoints_I(:,2);
        for i = 1:size(x1,2)  % iterate through shapeBounds
            matchIdx{i} = find((X > x1(i)) & (X < x2(i)) & (Y > y1(i)) & (Y < y2(i)));
        end
   
        for j = 1:sz    % Iterate through all blocks
            vote(k,j) = vote(k,j) + size(matchIdx{j},1);
        end
        
        % plot result
%         showMatchedFeatures(ColourMask, T_BW{k}, matchedPoints_I, ...
%         matchedPoints_T, 'montage');
    end
    
    % pick a solution based on matched votes
    [~,ID] = max(vote);
    c_out = c_in;
    c_out(:,4) = ID';   % Set shape to highest vote
end 