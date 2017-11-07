function [Output] = CheckDirection(Piece,Match,Direction,StartX,StartY,Board,Clash)
%%Looks at a specified direction on the board to find a clash/similarity  (Clash is
%% same Color/Shape that makes the move invalid.
%Returns   1 (if boundary is reached)
%      and 2 (if a clash is found)
%%Inputs:    Piece[1x2]{Contains Color and Shape}
          %  Match {Color = 1} {Shape = 2} type of clash you are looking
          %  Direction {Left,Right,Up,Down}
          %  Start Positions X and Y
          %  State of the Board
          %  Clash -> 1 looking for clash
          %           0 looking for all similar

Output = 2;
%%Starting Point
X = StartX;
Y = StartY;
while (isEmptyBoundary(X,Y,Board) == false)
    if Clash == 1
        if Piece(Match) == Board(X,Y,Match)
            Output = 2;
            break
        end
    else
        if Piece(Match) ~= Board(X,Y,Match)
            Output = 2;
            break
        end
        
    end
    %%No Breaks so Keep looking
    switch Direction
        case 'left'
        X = X-1;
        case 'right'
        X = X+1;
        case 'up'
        Y = Y-1;
        case 'down'
        Y = Y+1;
    end
end
%%If boundary is reached
    if (isEmptyBoundary(X,Y,Board) == true)
        Output = 1;
    end

end