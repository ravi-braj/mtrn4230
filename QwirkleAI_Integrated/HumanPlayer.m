if Player == 1
    GamePieces = P1GamePieces;
elseif Player == 2
    GamePieces = P2GamePieces;
end
Valid = false;
while (Valid == false)
    disp('Please insert Valid Move or Right Click to SWAP');
    [x1, y1,button] = ginput(1);
    if button == 113
           break;
    end
    PieceX = x1;
    PieceY = y1;
    if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
        PieceNum = ceil(PieceY/50);
        disp('Piece ');
        disp(PieceNum);
        if button == 3 %%Right Click
            GamePieces = zeros(6,2);
            
            %ui.playGame.discardPiece(1, 1);
            %ui.playGame.replacePiece(1,1,);
            %ui.playGame.discardPiece(1, 2);
            %ui.playGame.replacePiece(1, 2);
            break;
        end;
    end
    [x2, y2,button] = ginput(1);
    PlaceX = x2;
    PlaceY = y2;
    if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
        PieceNum = ceil(PieceY/50);
        if (PlaceX>=0 && PlaceX<=450) && (PlaceY>=0 && PlaceY<=450)
            X = ceil(PlaceX/50);
            Y = ceil(PlaceY/50);
            Valid = isMoveValid(GamePieces(PieceNum,:),X,Y,Board);
        end
    end
end

UpdateMoveState

if Player == 1
    P1GamePieces = GamePieces;
elseif Player == 2
    P2GamePieces = GamePieces;
end