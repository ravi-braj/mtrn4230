%class for qwirkle game actions
% Author: Ravi and Ken
% Last updated 15 November 2017

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
            obj.motionMaker.placeToPoint(pieceX, pieceY, 1);
        end
        
        %swaps all pieces of player with pieces from the box
        function swapPieces(obj, player)
            for p=1:6
                obj.discardPiece(player, p);
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
            obj.motionMaker.arrangeInBox(0);
        end
        
        
        %looks at all the pieces on the table and places them in the box
        %assumes that the box is empty.
        function cleanTable(obj)
            %get array of pieces on table - in pixels
            global ui;
            pieces = detectTable(ui.tableRGB); %n by 6

            toIterate = min(length(pieces(:,1)), 12);
            
            obj.motionMaker.boxSpace = zeros(6,2);
            
            if(length(pieces) == 0)
                return;
            end
            
            disp('toiterate')
            disp(toIterate)
            disp(length(pieces))
            
            for i = 1:toIterate
               pieceX = pieces(i, 1);
               pieceY = pieces(i, 2);
               orientation = pieces(i, 3);
               reachable = pieces(i, 6);
               if(reachable)
                   obj.motionMaker.pickUpFromPoint(pieceX, pieceY, 1);
                   obj.motionMaker.arrangeInBox(orientation);
               else
                   disp('piece not reachable')
               end
            end
        end
        
        function sortDecks(obj)
            %%As described in the Asst 4 specifications
            %Assuming there are 12 pieces on the table (reachable)
            %This function will automomously detect the pieces and sort the
            %pieces into their corresponding positions in the players hands

            %%Player 1 ---> COLOUR
            %%Player 2 ---> SHAPE
            
            global ui;
            %%Detect all the pieces on Table
            pieces = detectTable(ui.tableRGB);
            %%Remove Pieces NOT IN RANGE
            pieces = pieces(find(pieces(:,1)<=1120),:);
            pieces = pieces(find(pieces(:,1)>=488),:);

            %%Find the Matching Colour and Shape for P1 and P2
            %%Sorting is based on the most popular colour and shape detected
            M = mode(pieces);
            checkingColour = M(4);
            checkingShape =  M(5);
            %%Finding the amount of detected pieces (should be 12 or less)
            toIterate = min(length(pieces(:,1)), 12);
            %%Create counters to keep track of pieces in hands
            P1deckNum = 1;
            P2deckNum = 1;
            for i = 1:toIterate
                %%Identify piece
                pieceX = pieces(i, 1);
                pieceY = pieces(i, 2);
                pieceColour = pieces(i, 4);
                pieceShape = pieces(i, 5);

                %Pick up the piece
                obj.motionMaker.pickUpFromPoint(pieceX, pieceY, 1);

                %Decide if belongs in P1 or P2
                if pieceColour == checkingColour %%Same Colour ->P1
                    if P1deckNum <= 6 %%Always check if the hand is full if so then place in the other hand
                        [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
                        obj.motionMaker.placeToPoint(handX, handY, 1);
                        P1deckNum = P1deckNum +1;
                    else
                        [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
                        obj.motionMaker.placeToPoint(handX, handY-4, 1);
                        P2deckNum = P2deckNum +1;
                    end
                elseif pieceShape == checkingShape %%Same Shape ->P2
                    if P2deckNum <= 6 %%Always check if the hand is full if so then place in the other hand
                        [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
                        obj.motionMaker.placeToPoint(handX, handY, 1);
                        P2deckNum = P2deckNum +1;
                    else
                        [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
                        obj.motionMaker.placeToPoint(handX, handY-4, 1);
                        P1deckNum = P1deckNum +1;
                    end
                else %%Didnt detect color/shape so place in player 1s hand (assuming color messes up more often)
                    if P1deckNum <= 6 %%Always check if the hand is full if so then place in the other hand
                        [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
                        obj.motionMaker.placeToPoint(handX, handY, 1);
                        P1deckNum = P1deckNum +1;
                    else
                        [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
                        obj.motionMaker.placeToPoint(handX, handY-4, 1);
                        P2deckNum = P2deckNum +1;
                    end
                end
            end

        end
        
    end
end

