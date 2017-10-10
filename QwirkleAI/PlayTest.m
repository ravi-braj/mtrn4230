%%Initialize Board
StartBoard = zeros(9,9,2);
Board = StartBoard;
%%Insert first piece in the middile
Board(5,5,:) = [randi([1 6]),randi([1 6])];

%%Initialize Pieces
GamePieces = zeros(6,2);
P1GamePieces = GamePieces;
P2GamePieces = GamePieces;
%%Making Fake Pieces
% for y = 1:6
%     GamePieces(y,1) = randi([1 6]); %%Color
%     GamePieces(y,2) = randi([1 6]); %%Shape
% end
QUIT = false;
button = 0;
Player = 1;
P1Action = 'Waiting';
P2Action = 'Waiting';
P1TotalScore = 0;
P2TotalScore = 0;
while(QUIT==false)
    %%Show the Game
    Game_Interface;
%     disp('Click to Fill Hands');
%     [x, y,button] = ginput(1);
%     if button == 113
%         disp('QUIT');
%         break;
%     end
    %%Fill Missing Pieces for both players
    for y = 1:6
        if P1GamePieces(y,1) == 0
            P1GamePieces(y,1) = randi([1 6]); %%Color
            P1GamePieces(y,2) = randi([1 6]); %%Shape
        end
         if P2GamePieces(y,1) == 0
            P2GamePieces(y,1) = randi([1 6]); %%Color
            P2GamePieces(y,2) = randi([1 6]); %%Shape
        end
    end
    %%Show the Game Again
    Game_Interface;
   % disp('Player');
   % disp(Player);
    if Player == 1
        HumanPlayer
        Player = 2;
    elseif Player == 2
        HumanPlayer
        Player = 1;
    end;
    
    if button == 113
        QUIT = true;
        disp('QUIT');
    end
end
close Figure 1;