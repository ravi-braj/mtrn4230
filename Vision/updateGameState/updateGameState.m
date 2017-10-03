function [Player1,Player2] = UpdateGameState(im)
    Origin1 = [423, 290];
    Player1 = zeros(6,2);
    
    Origin2 = [1124, 290];
    Player2 = zeros(6,2);

    % Optional brightness/contrast adjustment
    %im = imadjust(im, [0, 0, 0; 0.53, 0.48, 0.47], []);
    
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
    for i = 1:6
        % Extract a player1 grid slot
        rgbBlock1 = imcrop(im,[Origin1(1),Origin1(2)+(i-1)*55,49,49]);

        % Classify each the grid slot
        [colour, shape] = ClassifyBlock(rgbBlock1, ...
            convnetColour, convnetShape);

        % Update Board
        Player1(i,1) = colour;
        Player1(i,2) = shape;
        
        % Extract a player2 grid slot
        rgbBlock2 = imcrop(im,[Origin2(1),Origin2(2)+(i-1)*55,49,49]);
        
        % Classify each the grid slot 
        [colour, shape] = ClassifyBlock(rgbBlock2, ...
            convnetColour, convnetShape);

        % Update Board
        Player2(i,1) = shape;
        Player2(i,2) = colour;
    end
end