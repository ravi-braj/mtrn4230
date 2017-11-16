function [MovePiece,Xpos,Ypos] = QwirkleAI(Board,Pieces)
%%Given the Board[9x9] and the Pieces[1x6]
%This function will return the MovePiece Number [1 to 6]
%and also the X,Y board position corresponding to the correct move
%It will return 0 for all 3 outputs if no moves found
MovePiece = 0;
Xpos=0;
Ypos=0;

%%Initializing Variables
CheckingPiece = zeros(1,2);
PieceNum = 0;
Move_Found = 0;
%%Looking for the right piece (out of 6 possible pieces)
while (Move_Found == 0)
    %%Starting with Piece 1 to 6
    PieceNum = PieceNum+1; 
    CheckingPiece = Pieces(PieceNum,:);
    %%Find the right X,Y position on the board
    for y  = 1:9
        for x = 1:9
            %%Check if the move is Valid
            Move_Found = isMoveValid(CheckingPiece,x,y,Board);
            %Move_Found = 1;
            if Move_Found == 1
                MovePiece = PieceNum;
                Xpos= x;
                Ypos = y;
                break
            end
        end
        if Move_Found == 1 break
        end
    end
    %%If 6th Piece and No Move Found, then BREAK
    if PieceNum == 6 break
    end
    
end

end