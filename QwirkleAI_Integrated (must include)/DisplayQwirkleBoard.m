function DisplayQwirkleBoard(Input)
%%DISPLAY_QWIRKLE_BOARD
%%Input is the Board -> 9x9x2 Matrix (stored as double)
%%Each cell contains [Color,Shape]
%%Colour {1 = red, 2 = orange, 3 = yellow, 4 = green, 5 = blue, 6 = purple, 0 = white}
%%Shape {1 = square, 2 = diamond, 3 = circle, 4 = club, 5 = cross, 6 = star, 0 = Empty}

%%Create Empty board and Populate the BoardDisplay
BoardDisplay = cell.empty(81,0);
for y  = 1:9
    for x = 1:9
        %%Calculate the current index from x and y
        current = (y-1)*9+x;
        %%Extract the correct image tile
        tile = sprintf('%d%d.gif',Input(x,y,1),Input(x,y,2));
        BoardDisplay(current) = {tile};
    end
end
%%Display Qwirkle Board
montage(BoardDisplay,'Size',[9 9]);
end
