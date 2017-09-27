StartBoard = zeros(9,9,2);
for y  = 1:9
    for x = 1:9
        StartBoard(x,y,1) = 0; %%Color
        StartBoard(x,y,2) = 0; %%Shape
    end
end

Board = StartBoard;
Board(5,5,:) = [randi([1 6]),randi([1 6])];
%%Making Fake Pieces
GamePieces = zeros(6,2);
for y = 1:6
    GamePieces(y,1) = randi([1 6]); %%Color
    GamePieces(y,2) = randi([1 6]); %%Shape
end
move = 0;
while(1)
    Game_Interface;
    pause();
    %%Fill missing pieces
    for y = 1:6
        if GamePieces(y,1) == 0
            GamePieces(y,1) = randi([1 6]); %%Color
            GamePieces(y,2) = randi([1 6]); %%Shape
        end
    end
    Game_Interface
    disp('Replace Pieces');
    pause();
    %%AI TIME!!
    [PieceNum,X,Y] = QwirkleAI(Board,GamePieces);
    if PieceNum ~= 0
        MovingPiece = GamePieces(PieceNum,:);
        GamePieces(PieceNum,:) = [0 0];
        %%Place Piece
        Board(X,Y,:) = MovingPiece;
        move = move +1;
        text = sprintf('Move Number %d',move);
        fprintf(text);
    else
        disp('NO MOVES AVAILABLE');
        disp('Please SWAP');
        pause();
        GamePieces(end,:) = [0 0];
    end
end