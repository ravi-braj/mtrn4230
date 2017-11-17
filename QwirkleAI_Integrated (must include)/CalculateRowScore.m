function [RowScore,RowQwirkle] = CalculateRowScore(Board,MovedPiece,Xpos,Ypos)

%%Calculates the score of the moving piece in the horizontal direction
%%(row)

%%Input = Board, Piece, and X Y
%%Output = RowScore and if a Qwirkle is detected ie. 6 pieces
%%connected

% Author: Ken Le
% Last updated 15 November 2017

%RowScore = 0;
RowQwirkle = 0;

%Start point of the move
X = Xpos;
Y = Ypos;

%Count amount of pieces on the LEFT until empty/boundary
LeftCount = 0;
X = X-1; %Looking at the left piece
while (isEmptyBoundary(X,Y,Board) == false)
    LeftCount = LeftCount + 1; %Add to count
    X = X-1; %Moving left
end

X = Xpos;
Y = Ypos;
%Count amount of pieces on the RIGHT until empty/boundary
RightCount = 0;
X = X+1; %Looking at the right piece
while (isEmptyBoundary(X,Y,Board) == false)
    RightCount = RightCount + 1; %Add to count
    X = X+1; %Moving right
end

if (LeftCount == 0) && (RightCount == 0) 
    RowScore = LeftCount + RightCount;
else
    RowScore = LeftCount + RightCount + 1;
end

if RowScore == 6  %%Check if Qwirkle was made (6 in a row)
    RowQwirkle = 1;
end

end