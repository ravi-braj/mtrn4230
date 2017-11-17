function [Output] = PieceMatch(Piece,X,Y,Board)
%%Checks if the Piece in your hand matches with
%%Corresponding Piece on the board
%Output: No Match = 0;
%     Color Match = 1;
%     Shape Match = 2;
%If the piece is IDENTICAL = 0;

% Author: Ken Le
% Last updated 15 November 2017

ColorMatch = 0;
ShapeMatch = 0;
Output = 0;
if Piece(1) == Board(X,Y,1)
    ColorMatch = 1;
    Output = 1;
end
if Piece(2) == Board(X,Y,2)
    ShapeMatch = 1;
    Output = 2;
end
if (ColorMatch == 1) && (ShapeMatch == 1)
    Output = 0;
end

end

