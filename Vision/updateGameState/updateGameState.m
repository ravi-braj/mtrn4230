function [Player1,Player2] = UpdateGameState(im)
    figure(1);
    imshow(im);

    Origin1 = [418, 287];
    Player1 = zeros(6,2);
    
    Origin2 = [1130, 290];
    Player2 = zeros(6,2);

    % Optional brightness/contrast adjustment
    %im = imadjust(im, [0, 0, 0; 0.53, 0.48, 0.47], []);
    im = imadjust(im, [0, 0, 0; 0.50, 0.48, 0.47], []);
    
    figure(2);
    imshow(im);
    
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
    figure(3);
    
    for i = 1:6
        % Extract a player1 grid slot
        rgbBlock1 = imcrop(im,[Origin1(1),Origin1(2)+(i-1)*55,49,49]);
        subplot(2,6,i);
        imshow(rgbBlock1);
        
        % Classify each the grid slot
        [colour, shape] = ClassifyBlock(rgbBlock1, ...
            convnetColour, convnetShape);

        % Update Board
        Player1(i,1) = shape;
        Player1(i,2) = colour;
        
        % Extract a player2 grid slot
        rgbBlock2 = imcrop(im,[Origin2(1),Origin2(2)+(i-1)*55,49,49]);        
        subplot(2,6,i+6);
        imshow(rgbBlock2);
        
        % Classify each the grid slot 
        [colour, shape] = ClassifyBlock(rgbBlock2, ...
            convnetColour, convnetShape);

        % Update Board
        Player2(i,1) = shape;
        Player2(i,2) = colour;
        
        disp("Slot " + i + " | S1: " + Player1(i,1) + " C1: " + ...
            Player1(i,2) + " | S1: " + Player2(i,1) + " C2: " + ...
            Player2(i,2) );
    end
end