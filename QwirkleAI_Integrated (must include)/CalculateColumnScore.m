function [ColumnScore,ColumnQwirkle] = CalculateColumnScore(Board,MovedPiece,Xpos,Ypos)
%%Calculates the score of the moving piece in the vertical direction
%%(column)

%%Input = Board, Piece, and X Y
%%Output = ColumnScore and if a Qwirkle is detected ie. 6 pieces
%%connected

%ColumnScore = 0;
ColumnQwirkle = 0;

%Start point of the move
X = Xpos;
Y = Ypos;

%Count amount of pieces on the UP until empty/boundary
UpCount = 0;
Y = Y-1; %Looking at the left piece
while (isEmptyBoundary(X,Y,Board) == false)
    UpCount = UpCount + 1; %Add to count
    Y = Y-1; %Moving left
end

X = Xpos;
Y = Ypos;
%Count amount of pieces on the RIGHT until empty/boundary
DownCount = 0;
Y = Y+1; %Looking at the right piece
while (isEmptyBoundary(X,Y,Board) == false)
    DownCount = DownCount + 1; %Add to count
    Y = Y+1; %Moving right
end

if (UpCount == 0) && (DownCount == 0) 
    ColumnScore = UpCount + DownCount;
else
    ColumnScore = UpCount + DownCount + 1;
end


if ColumnScore == 6  %%Check if Qwirkle was made (6 in a row)
    ColumnQwirkle = 1;
end

end