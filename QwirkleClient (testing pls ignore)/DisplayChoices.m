function DisplayChoices(Input)
%%DISPLAY_Choices
%%Input is the Pieces -> 9x9x2 Matrix (stored as double)
%%Each cell contains [Color,Shape]
%%Colour {1 = red, 2 = orange, 3 = yellow, 4 = green, 5 = blue, 6 = purple, 0 = white}
%%Shape {1 = square, 2 = diamond, 3 = circle, 4 = club, 5 = cross, 6 = star, 0 = Empty}

PieceDisplay = cell.empty(6,0);
    for x = 1:6
        %%Extract the correct image tile
        tile = sprintf('%d%d.gif',Input(x,1),Input(x,2));
        PieceDisplay(x) = {tile};
    end
montage(PieceDisplay,'Size',[6 1]);
end
