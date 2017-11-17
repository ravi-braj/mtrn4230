function [TotalScore,PieceScore,Qwirkle] = CalculateMoveScore(Board,MovedPiece,Xpos,Ypos)
% Author: Ken Le
% Last updated 15 November 2017

%TotalScore = 0;
%PieceScore = 0;
%Qwirkle = 0;

%%CheckRowScore
%RowScore = 0;
%RowQwirkle = 0;
[RowScore,RowQwirkle] = CalculateRowScore(Board,MovedPiece,Xpos,Ypos);

%%CheckColumn Score
%ColumnScore = 0;
%ColumnQwirkle = 0;
[ColumnScore,ColumnQwirkle] = CalculateColumnScore(Board,MovedPiece,Xpos,Ypos);
%%Calculate Total Score
PieceScore = RowScore + ColumnScore;
Qwirkle = RowQwirkle + ColumnQwirkle;
TotalScore = PieceScore + Qwirkle*6;
end