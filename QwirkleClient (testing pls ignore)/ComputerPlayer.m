if Player == 1
    GamePieces = P1GamePieces;
elseif Player == 2
    GamePieces = P2GamePieces;
end
%%AI PART
%[x1, y1,button] = ginput(1);
if button ~= 113
    [PieceNum,X,Y] = QwirkleAI(Board,GamePieces);
    if PieceNum == 0;
        Valid = false;
        %SWAP ALL PIECES
        GamePieces = zeros(6,2);
        ui.playGame.swapPieces(Player);
    else
        Valid = true;
    end
    UpdateMoveState
end


if Player == 1
    P1GamePieces = GamePieces;
elseif Player == 2
    P2GamePieces = GamePieces;
end
