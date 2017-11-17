function [Player1,Player2] = updateGameState(im)
    % Specialised block classifier for quirkle game to detect player hands
    % after a swap block or populate hand call. The function takes in a
    % table camera 1200x1600 RGB image and masks everything but the player
    % hands. Then the function iteratively moves through hardcoded player
    % hand slot regions classifying each slot. Note this assumes perfect
    % orientation and position as cropped regions are hard code. The result
    % is returned as two 2x6 matrixes, one for each player. Column 1 is
    % colour and colour and column 2 is shape.
    % written by Daniel Castillo
    % Last updated 7 November 2017

    %%
    % Initialise image and parameters
    
%     figure(1);
%     imshow(im);

    % Hard Code player origins for cropping
    Origin1 = [418, 287];
    Player1 = zeros(6,2);
    
    Origin2 = [1130, 290];
    Player2 = zeros(6,2);

    % Optional brightness/contrast adjustment
    %im = imadjust(im, [0, 0, 0; 0.53, 0.48, 0.47], []);
    im = imadjust(im, [0, 0, 0; 0.50, 0.48, 0.47], []);
    
%     figure(2);
%     imshow(im);
%     
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
%     figure(3);
%     
    % Iterate over slot i for each player
    for i = 1:6
        % Extract a player1 grid slot
        rgbBlock1 = imcrop(im,[Origin1(1),Origin1(2)+(i-1)*55,49,49]);
%         subplot(2,6,i);
%         imshow(rgbBlock1);
        
        % Classify each the grid slot
        [colour, shape] = ClassifyBlock(rgbBlock1, ...
            convnetColour, convnetShape);

        % Update Board
        Player1(i,1) = colour;
        Player1(i,2) = shape;
        
        % Extract a player2 grid slot
        rgbBlock2 = imcrop(im,[Origin2(1),Origin2(2)+(i-1)*55,49,49]);        
%         subplot(2,6,i+6);
%         imshow(rgbBlock2);
%         
        % Classify each the grid slot 
        [colour, shape] = ClassifyBlock(rgbBlock2, ...
            convnetColour, convnetShape);

        % Update Board
        Player2(i,1) = colour;
        Player2(i,2) = shape;
        
%         disp('Slot ' + i + ' | S1: ' + Player1(i,1) + ' C1: ' + ...
%             Player1(i,2) + ' | S1: ' + Player2(i,1) + ' C2: ' + ...
%             Player2(i,2) );
    end
end