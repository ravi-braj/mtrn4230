%%RUNNING QWIRKLE SIMULATION
%%Initialize Board
StartBoard = zeros(9,9,2);
Board = StartBoard;
%%Insert first piece in the middile
%%Board(5,5,:) = [randi([1 6]),randi([1 6])];
%%Initialize Pieces
GamePieces = zeros(6,2);
P1GamePieces = GamePieces;
P2GamePieces = GamePieces;
%%Making Fake Pieces
% for y = 1:6
%     GamePieces(y,1) = randi([1 6]); %%Color
%     GamePieces(y,2) = randi([1 6]); %%Shape
% end
button = 0;
Player = 1;
P1Action = 'Waiting';
P2Action = 'Waiting';
P1TotalScore = 0;
P2TotalScore = 0;
QUIT = false;

%%MAIN LOOP
while(~QUIT)
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
    end;
    
    if button == 113
        QUIT = true;
        disp('QUIT');
    end
end
close Figure 10;