function [blocks, box] = detectConveyorBlocks(im)
    % This function takes in a 1200 x 1600 image and detects a set of 
    % blocks which reside within a carry box. It returns blocks which is 
    % structured [x, y]. This allows the robot arm to swap blocks.
    
    % Erase anything outside conveyor region of interest (Conveyor belt)
    im(:,1:556,:) = 0;
    im(:,1137:end,:) = 0;
    im(705:end,:,:) = 0;
    figure(1); imshow(im);
    
    % Generate conveyor mask (inverse should leave the box)
    Conveyor_BW = conveyorMask(im);
    Conveyor_BW = imclose(Conveyor_BW,strel('square',12));
    BoxMask = imclose(~Conveyor_BW,strel('square',12));
    figure(2); imshow(BoxMask);
    
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
        figure(1); imshow(im); hold on; plot(box.x,box.y,'*');

        % Generate colour/shape mask
        BW_Red = ConvRedMask(im);
        BW_Orange = ConvRedMask(im);
        BW_Yellow = ConvYellowMask(im);
        BW_Green = ConvGreenMask(im);
        BW_Blue = ConvBlueMask(im);
        BW_Purple = ConvPurpleMask(im);
        ColourMask = BW_Red | BW_Orange | BW_Yellow | BW_Green | BW_Blue | BW_Purple;

        % Apply colour/shape mask
        im(~ColourMask(:,:,[1, 1, 1])) = 0;

        % Plot image with box mask 
        figure(3); imshow(im);

        % Extract shape centers
        shape_stats = regionprops('table',ColourMask,'Area','Centroid');
        ShapesIdx = find(shape_stats.Area > 50 & shape_stats.Area < 300);
        blocks(:,1:2) = shape_stats.Centroid(ShapesIdx,:);

        % Plot Centers
        hold on;
        plot(blocks(:,1),blocks(:,2),'r*');
    else
        blocks = [];
        box.x = []; box.y = []; box.orient = [];
    end
    
    disp(blocks); disp(box);
end