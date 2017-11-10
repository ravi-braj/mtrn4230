function sortDecks(obj)
global ui;
%%Detect all the pieces on Table
pieces = detectTable(ui.tableRGB);
%%Find the Matching Colour and Shape for P1 and P2
M = mode(pieces);
checkingColour = M(4);
checkingShape =  M(5);

toIterate = min(length(pieces(:,1)), 12);

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
        if P1deckNum <= 6
            [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P1deckNum = P1deckNum +1;
        else
            [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P2deckNum = P2deckNum +1;
        end
    elseif pieceShape == checkingShape %%Same Shape ->P2
        if P2deckNum <= 6
            [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P2deckNum = P2deckNum +1;
        else
            [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P1deckNum = P1deckNum +1;
        end
    else %%Didnt detect color/shape so place in player 1s hand (assuming color messes up more often)
        if P1deckNum <= 6
            [handX, handY] = obj.motionMaker.playerToPixel(1, P1deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P1deckNum = P1deckNum +1;
        else
            [handX, handY] = obj.motionMaker.playerToPixel(2, P2deckNum);
            obj.motionMaker.placeToPoint(handX, handY, 1);
            P2deckNum = P2deckNum +1;
        end
    end
end

end