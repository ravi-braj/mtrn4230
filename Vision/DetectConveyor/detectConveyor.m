function [blocks, box, FoundBox] = detectConveyor(im)
    % This function takes in a 1200 x 1600 image and detects a set of 
    % blocks which reside within a carry box. It returns blocks which is 
    % structured [x, y]. This allows the robot arm to swap blocks.
    
    FoundBox = false;
    
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
    % Generate conveyor mask
    Conveyor_BW = ~createConMask(im);
    Conveyor_BW(:,1:556) = 0;
    Conveyor_BW(:,1137:end) = 0;
    Conveyor_BW(705:end,:) = 0;
    %figure(1); imshow(Conveyor_BW);
    
    %Insert Filled Image and create BoxMask
    con_stats = regionprops('table',Conveyor_BW,'Area','BoundingBox','FilledImage');
    [~, idx] = max(con_stats.Area);
    
    BoxMask = false(size(Conveyor_BW));
   
    if con_stats.Area(idx) > 40000
        
        col = floor(con_stats.BoundingBox(idx,1));
        row = floor(con_stats.BoundingBox(idx,2));
        sz = size(con_stats.FilledImage{idx});
        if (col(1) == 0)
            col = col + 1;
        end
        
        if (row(1) == 0)
            row = row + 1;
        end
        
        BoxMask(row:(row+sz(1)-1),col:(col+sz(2)-1)) = con_stats.FilledImage{idx};
        FoundBox = true;
    end
    
    %figure(2); imshow(BoxMask);
    
    if (any(BoxMask(:)))
        % Extract box regionprops
        box_stats = regionprops('table',BoxMask,'Centroid','Area','PixelList');
        [~, BoxIdx] = max(box_stats.Area);
        
        % Extract box center
        box.x = box_stats.Centroid(BoxIdx, 1);
        box.y = box_stats.Centroid(BoxIdx, 2);
        
        % Extract box orientation
        [~, i1] = max(box_stats.PixelList{1}(:,1));
        [~, i2] = max(box_stats.PixelList{1}(:,2));
        x = abs(box_stats.PixelList{1}(i1,1) - box_stats.PixelList{1}(i2,1));
        y = abs(box_stats.PixelList{1}(i1,2) - box_stats.PixelList{1}(i2,2));
        box.orient = rad2deg(atan2(y,x));

        % Apply BoxMask to Image (leaves only the box)
        im(~BoxMask(:,:,[1, 1, 1])) = 0;
        
        % Plot BoxMask
        %figure(1); imshow(im); hold on; plot(box.x,box.y,'*');
        
        blocks = detectBlocks(im);
    else
        blocks = [];
        box.x = []; box.y = []; box.orient = [];
    end
end