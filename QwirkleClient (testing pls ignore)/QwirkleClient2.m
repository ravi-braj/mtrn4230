    %%Show the Game
    [P1GamePieces,P2GamePieces] = updateGameState(ui.tableRGB);
    Game_Interface;
    
    %If missing pieces
    %Load board
    
    
    %%Show the Game Again
    [P1GamePieces,P2GamePieces] = updateGameState(im);
    Game_Interface;
    
    if Player == 1
        %HUMAN MOVE
        HumanPlayer
        Player = 2;
    elseif Player == 2
        %PLAYER 2 (COMPUTER MOVE)
        ComputerPlayer
        %HumanPlayer
        Player = 1;
    end
    
    if button == 113
        QUIT = true;
        disp('QUIT');
    end