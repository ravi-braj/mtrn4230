%%Used to allow a human player to make a decision during gameplay
% Author: Ken Le
% Last updated 15 November 2017

global ui

%%Storing the hands
if ui.Player == 1
    GamePieces = ui.P1GamePieces;
elseif Player == 2
    GamePieces = ui.P2GamePieces;
end
Valid = false;
while (Valid == false)
    disp('Please insert Valid Move or Right Click to SWAP');
    [x1, y1,button] = ginput(1);
%     if button == 113
%            break;
%     end
    PieceX = x1;
    PieceY = y1;
    %%Choosing a piece from your hand
    if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
        PieceNum = ceil(PieceY/50);
        disp('Piece ');
        disp(PieceNum);
        if button == 3 %%Right Click
            GamePieces = zeros(6,2);
            ui.playGame.swapPieces(ui.Player);
            break;
        end;
    end
    
    %%Choosing a position to place the piece
    [x2, y2,button] = ginput(1);
    PlaceX = x2;
    PlaceY = y2;
    if (PieceX>=0 && PieceX<=50) && (PieceY>=0 && PieceY<=300)
        PieceNum = ceil(PieceY/50);
        if (PlaceX>=0 && PlaceX<=450) && (PlaceY>=0 && PlaceY<=450)
            X = ceil(PlaceX/50);
            Y = ceil(PlaceY/50);
            Valid = isMoveValid(GamePieces(PieceNum,:),X,Y,ui.Board);
        end
    end
end

UpdateMoveState

%%Restoring the hand (after updating the state of the game)
if Player == 1
    P1GamePieces = GamePieces;
elseif Player == 2
    P2GamePieces = GamePieces;
end