function [TotalScore,PieceScore,Qwirkle] = CalculateMoveScore(Board,MovedPiece,Xpos,Ypos)

%%Calculate the score of a player's move based on an existing board
% Author: Ken Le
% Last updated 15 November 2017

%TotalScore = 0;
%PieceScore = 0;
%Qwirkle = 0;

%%CheckRowScore
%RowScore = 0;
%RowQwirkle = 0;

%%Checking the horizontal direction
[RowScore,RowQwirkle] = CalculateRowScore(Board,MovedPiece,Xpos,Ypos);

%%CheckColumn Score
%ColumnScore = 0;
%ColumnQwirkle = 0;

%%Checking the vertical direction
[ColumnScore,ColumnQwirkle] = CalculateColumnScore(Board,MovedPiece,Xpos,Ypos);
%%Calculate Total Score
PieceScore = RowScore + ColumnScore;
Qwirkle = RowQwirkle + ColumnQwirkle;
TotalScore = PieceScore + Qwirkle*6;
end