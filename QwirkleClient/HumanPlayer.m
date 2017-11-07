if Player == 1
    GamePieces = P1GamePieces;
elseif Player == 2
    GamePieces = P2GamePieces;
end
Valid = false;
while (Valid == false)
    %disp('Please insert Valid Move or Right Click to SWAP');
    %[x1, y1,button] = ginput(1);
%     qwirkleX
%     qwirkleY
%     qwirkleButton
    if (ui.ginputFlag == 1)
        if (ui.qwirkleButton(1) == 113 ||  ui.qwirkleButton(2) == 113)
               break;
        end
        PieceX = ui.qwirkleX(1);
        PieceY = ui.qwirkleY(1);
        if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
            PieceNum = ceil(PieceY/50);
            disp('Piece ');
            disp(PieceNum);
            if button == 3 %%Right Click
                GamePieces = zeros(6,2);
                ui.playGame.swapPieces(Player);
                break;
            end;
        end

        PlaceX = ui.qwirkleX(2);
        PlaceY = ui.qwirkleY(2);
        if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
            PieceNum = ceil(PieceY/50);
            if (PlaceX>=0 && PlaceX<=450) && (PlaceY>=0 && PlaceY<=450)
                X = ceil(PlaceX/50);
                Y = ceil(PlaceY/50);
                Valid = isMoveValid(GamePieces(PieceNum,:),X,Y,Board);
                if firstmove == true
                    Valid = true;
                    firstmove = false;
                end
            end
        end
        ui.ginputFlag = 0;
    end
    pause(0.1);
end

UpdateMoveState

if Player == 1
    P1GamePieces = GamePieces;
elseif Player == 2
    P2GamePieces = GamePieces;
end