%class for qwirkle game actions

classdef gameplay < handle
    properties
        motionMaker;
    end
    methods
        function obj = gameplay()
            obj.motionMaker = motion();
        end
        
        %places the players nth piece on board location
        function placePiece(obj, player, n, board)
            [pieceX, pieceY] = obj.motionMaker.playerToPixel(player, n);
            obj.motionMaker.pickUpFromPoint(pieceX, pieceY, 1);
            [boardX, boardY] = obj.motionMaker.boardToPixel(board(1),board(2));
            obj.motionMaker.placeToPoint(boardX, boardY, 1);
        end
        
        %places a new piece from the box in players nth space
        function replacePiece(obj, player, n)
            [pieceX, pieceY] = obj.motionMaker.playerToPixel(player, n);
            obj.motionMaker.pickUpFromBox();
            %obj.motionMaker.orientPiece();
            obj.motionMaker.placeToPoint(pieceX, pieceY, 1);
        end
        
        %swaps all pieces of player with pieces from the box
        function swapPieces(obj, player)
            for p=1:6
                obj.motionMaker.discardPiece(player, p);
            end
            for p=1:6
                obj.replacePiece(player, p);
            end
        end
        
        %gets the current hand of the player
        function pieces = getPieces(obj, player)
            pieces = rand(6);
        end
        
        %returns the nth piece from players hand to box
        function discardPiece(obj, player, n)
            [pieceX, pieceY] = obj.motionMaker.playerToPixel(player, n);
            obj.motionMaker.pickUpFromPoint(pieceX, pieceY, 1);
            obj.motionMaker.placeInBox();
        end
        
    end
end

