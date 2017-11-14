%%Update Pieces and the Board
%in a running loop
%NOTE: Every time replacePiece is called, some flag (fullHand), should be
%set to false

%mainloop()
% if(fullHand == false)
    %p1hand = ui.playGame.getPieces()
    %if(p1hand == complete)
        %fullHand = true





if Valid == true
    %Grab the piece
    MovingPiece = GamePieces(PieceNum,:);
    GamePieces(PieceNum,:) = [0 0];
    %%Place Piece
    Board(X,Y,:) = MovingPiece;
    %ui.playGame.placePiece(player, n, [x, y])
    
    [TotalScore,PieceScore,Qwirkle] = CalculateMoveScore(Board,MovingPiece,X,Y);
    
    if Player == 1
    P1TotalScore = P1TotalScore + TotalScore;
    P1Action = sprintf('Piece %d to [%d ,%d]',PieceNum,X,Y);
    P2Action = sprintf('Your Turn');
    elseif Player == 2
    P2TotalScore = P2TotalScore + TotalScore;
    P2Action = sprintf('Piece %d to [%d ,%d]',PieceNum,X,Y);
    P1Action = sprintf('Your Turn');
    end
else
    if Player == 1
    P1Action = sprintf('Swapped ALL');
    P2Action = sprintf('Your Turn');
    elseif Player == 2
    P2Action = sprintf('Swapped ALL');
    P1Action = sprintf('Your Turn');
    end
end