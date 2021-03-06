function [Move_Found]= isMoveValid(CheckingPiece,x,y,Board)
%%isMoveValid returns a boolean [True or False]
%%Checks to see if the move that is desired is allowable based on the
%%boundaries and the state of the board
%Inputs are the Piece[1x2], X, Y positions corresponding to the
%Board[9x9x2]

% Author: Ken Le
% Last updated 15 November 2017

%%A Move_Found is also used as a flag to detect cases
Move_Found = 0; %% 1 is true and 2 is Invalid
Match = 0;
%%Check if position is availiable
if isEmptyBoundary(x,y,Board) == true
    %%Check Left
    if (isEmptyBoundary(x-1,y,Board) == false) && (Move_Found ~= 2)
        Match = PieceMatch(CheckingPiece,x-1,y,Board);
        if Match ~= 0
            Move_FoundLeft = CheckDirection(CheckingPiece,Match,'left',x-1,y,Board,0);
            Move_FoundRight = CheckDirection(CheckingPiece,Match,'right',x+1,y,Board,0);
            if (Move_FoundLeft == 1) && (Move_FoundRight == 1) 
                Move_Found =1;
            else
                Move_Found =2;
            end
            if Move_Found ~= 2
                Match = Match*-1 + 3;
                Move_Found = CheckDirection(CheckingPiece,Match,'left',x-1,y,Board,1);
            end
        else
            Move_Found = 2; %%INVALID MOVE FOUND
        end
    end
    %%Check Right
    if (isEmptyBoundary(x+1,y,Board) == false) && (Move_Found ~= 2)
        Match = PieceMatch(CheckingPiece,x+1,y,Board);
        if Match ~= 0
            Move_FoundLeft = CheckDirection(CheckingPiece,Match,'left',x-1,y,Board,0);
            Move_FoundRight = CheckDirection(CheckingPiece,Match,'right',x+1,y,Board,0);
            if (Move_FoundLeft == 1) && (Move_FoundRight == 1) 
                Move_Found =1;
            else
                Move_Found =2;
            end         
            if Move_Found ~= 2
            Match = Match*-1 + 3;
            Move_Found = CheckDirection(CheckingPiece,Match,'right',x+1,y,Board,1);
            end
        else
            Move_Found = 2;
        end
    end
    %%Check Up
    if (isEmptyBoundary(x,y-1,Board) == false) && (Move_Found ~= 2)
        Match = PieceMatch(CheckingPiece,x,y-1,Board);
        if Match ~= 0
            Move_FoundUp = CheckDirection(CheckingPiece,Match,'up',x,y-1,Board,0);
            Move_FoundDown = CheckDirection(CheckingPiece,Match,'down',x,y+1,Board,0);
            if (Move_FoundUp == 1) && (Move_FoundDown == 1) 
                Move_Found =1;
            else
                Move_Found =2;
            end
            if Move_Found ~= 2
            Match = Match*-1 + 3;
            Move_Found = CheckDirection(CheckingPiece,Match,'up',x,y-1,Board,1);
            end
        else
            Move_Found = 2;
        end
    end
    %%Check Down
    if (isEmptyBoundary(x,y+1,Board) == false) && (Move_Found ~= 2)
        Match = PieceMatch(CheckingPiece,x,y+1,Board);
        if Match ~= 0
            Move_FoundUp = CheckDirection(CheckingPiece,Match,'up',x,y-1,Board,0);
            Move_FoundDown = CheckDirection(CheckingPiece,Match,'down',x,y+1,Board,0);
            if (Move_FoundUp == 1) && (Move_FoundDown == 1) 
                Move_Found =1;
            else
                Move_Found =2;
            end

            if Move_Found ~= 2
            Match = Match*-1 + 3;
            Move_Found = CheckDirection(CheckingPiece,Match,'down',x,y+1,Board,1);
            end
        else
            Move_Found = 2;
        end
    end
    
    %%Invalid move found, must return 0
    if(Move_Found == 2)
        Move_Found = 0;
    end
end


end