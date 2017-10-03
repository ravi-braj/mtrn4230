function c = detectTableBlocks(im)
    % Erase anything outside region of interest (Player Inventory + Board) 
    I(1:275,:,:) = 0; % Crop the top
    I(793:end,:,:) = 0; %Crop the bottom
    I(:,1:410,:) = 0; %Crop left side
    I(:,1190:end,:) = 0; %Crop Right side
    I(:,1060:1110,:) = 0; %Crop inventory right side
    I(:,490:538,:) = 0; %Crop inventory right side
    I(632:end,1110:1195,:) = 0;
    I(630:end,412:493,:) = 0;

    % Optional brightness/contrast adjustment
    im = imadjust(im, [0, 0, 0; 0.53, 0.48, 0.47], []);
    
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
    for i = 1:n
        % Extract a grid slot
        rgbBlock = 
        
        % Classify each block (shape and colour)
        [colour, shape] = ClassifyBlock(rgbBlock, ...
            convnetColour, convnetShape);
        
        % Convert to assignment coordinate frame
        x = squares(2, i);
        y = 1200 - squares(1, i);

        % Update output matrix
        c(i, :) = [x, y, colour, shape];
    end
end