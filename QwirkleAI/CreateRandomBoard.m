%%Making Fake GameState
clear all; close all; clc; 
RandomGameBoard = zeros(9,9,2);
for y  = 1:9
    for x = 1:9
        RandomGameBoard(x,y,1) = randi([1 6]); %%Color
        RandomGameBoard(x,y,2) = randi([1 6]); %%Shape
%         %%Adding Random Empty Spots
%         for i = 1:3
%             if x == randi([1 9]) RandomGameBoard(x,y,:) = [0 0]; end;
%         end
    end
end

DisplayQwirkleBoard(RandomGameBoard);

%%Making Fake Pieces
RandomGamePieces = zeros(6,2);
for y = 1:6
    RandomGamePieces(y,1) = randi([1 6]); %%Color
    RandomGamePieces(y,2) = randi([1 6]); %%Shape
end
DisplayChoices(RandomGamePieces);
%%Testing AI to find ValidMove
[PieceNum,X,Y] = QwirkleAI(RandomGameBoard,RandomGamePieces)
if PieceNum ~= 0
    MovingPiece = RandomGamePieces(PieceNum, : );
end
% figure(2);
% DisplayQwirkleBoard(RandomGameBoard);
% %%Place Piece
% RandomGameBoard(X,Y,:) = MovingPiece;
% DisplayQwirkleBoard(RandomGameBoard);
