%%Beginning of Computer/AI moves during gameplay
%%Does not run as a function but called during gameplay to make the action
% Author: Ken Le
% Last updated 15 November 2017
%%Receive the correct pieces (store)
if Player == 1
    GamePieces = P1GamePieces;
elseif Player == 2
    GamePieces = P2GamePieces;
end
%%AI PART
%%NOT USING GINPUT FOR LIVE RUNNING -->%[x1, y1,button] = ginput(1);
if button ~= 113
    %%AI makes a decision on which piece and which position(X,Y)
    [PieceNum,X,Y] = QwirkleAI(Board,GamePieces);
    if PieceNum == 0 %%No valid Moves avaliable
        Valid = false;
        %SWAP ALL PIECES
        GamePieces = zeros(6,2);
    else
        Valid = true;
    end
    UpdateMoveState
end

%%Return the correct pieces back to the player
if Player == 1
    P1GamePieces = GamePieces;
elseif Player == 2
    P2GamePieces = GamePieces;
end
