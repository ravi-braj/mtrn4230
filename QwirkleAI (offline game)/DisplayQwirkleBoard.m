function DisplayQwirkleBoard(Input)
%%DISPLAY_QWIRKLE_BOARD
%%Input is the Board -> 9x9x2 Matrix (stored as double)
%%Each cell contains [Color,Shape]
%%Colour {1 = red, 2 = orange, 3 = yellow, 4 = green, 5 = blue, 6 = purple, 0 = white}
%%Shape {1 = square, 2 = diamond, 3 = circle, 4 = club, 5 = cross, 6 = star, 0 = Empty}
% Author: Ken Le
% Last updated 15 November 2017

%%Create Empty board and Populate the BoardDisplay
BoardDisplay = cell.empty(81,0);
for y  = 1:9
    for x = 1:9
        %%Calculate the current index from x and y
        current = (y-1)*9+x;
        %%Extract the correct image tile
oy96        tile = sprintf('%d%d.gif',Input(x,y,1),Input(x,y,2));
        BoardDisplay(current) = {tile};
    end
end
%%Display Qwirkle Board
 fig1 = figure(1);
% axes1 = axes;
% axis(axes1,'ij');
% % Set the remaining axes properties
% set(axes1,'XAxisLocation','top','XTick',...
%     [25 75 125 175 225 275 325 375 425],'XTickLabel',...
%     {'1','2','3','4','5','6','7','8','9'},'YTick',...
%     [25 75 125 175 225 275 325 375 425],'YTickLabel',...
%     {'1','2','3','4','5','6','7','8','9'});
% xlim(axes1,[0 500]);
% ylim(axes1,[0 500]);
% title ('Board Display');
% hold on;
montage(BoardDisplay,'Size',[9 9]);
end
