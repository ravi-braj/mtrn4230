function [colour, shape] = ClassifyBlock(blockRGB, convnetColour, convnetShape)
    % Function receives input of a 50 x 50 RGB image of a block to
    % classify, a neural net for colour and a neural net for shape. The
    % classification of run on the block image and returns a value for
    % colour and shape.
    % written by Daniel Castillo
    % Last updated 4 November 2017

%%
% Classify colour
colourCat = classify(convnetColour, blockRGB);
if  (colourCat == '1')
    colour = 1;
elseif (colourCat == '2')
    colour = 2;
elseif (colourCat == '3')
    colour = 3;
elseif (colourCat == '4')
    colour = 4;
elseif (colourCat == '5')
    colour = 5;
elseif (colourCat == '6')
    colour = 6;
end

%%
%Classify shape
shapeCat = classify(convnetShape, blockRGB);
if (shapeCat == '1')
    shape = 1;
elseif (shapeCat == '2')
    shape = 2;
elseif (shapeCat == '3')
    shape = 3;
elseif (shapeCat == '4')
    shape = 4;
elseif (shapeCat == '5')
    shape = 5;
elseif (shapeCat == '6')
    shape = 6;
end

end