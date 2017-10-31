%moves implemented to facilitate qwirkle playing
%mostly just manipulation of qwirkle pieces



classdef motion < handle
    properties (Access = public)
        %variables regarding the board
        boxLocation;
        boxOrientation;
        
        %pieces removed (so free spaces) in the box
        boxSpaces;
        
        %point used for orienting pieces
        orientationPoint;
        
        boardOrientation;
        
        %position definitions of the board
        board_topLeft;
        board_bottomRight;
        
        p1_topLeft;
        p2_topLeft;
        
        squareSize;
        
        blocks;
        
    end
    methods
        function obj = motion()
            %define board positions
            obj.board_topLeft = [551, 286];
            obj.board_bottomRight = [1042, 785];
            
            obj.p1_topLeft = [420, 286];
            obj.p2_topLeft = [1125, 286];
            
            obj.squareSize = 56;
            
            %set orientation point
            obj.orientationPoint = [1140, 709];
            
            %set the position of the box.
            global ui;
            [obj.blocks, box, foundBox] = detectConveyorBlocks(ui.conveyorRGB);
            if(foundBox)
                obj.boxLocation = [box.x, box.y];
            end
        end
        
        
        %picks up a quirkle block from a particular point. Takes in matlab
        %coords. If table is false, it goes to conveyor
        function obj = pickUpFromPoint(obj, x, y, table)
            global ui;
            %point on table
            if(table == 1)
                [x, y, z] = convertCoordsTable(x, y);
            else
                [x, y, z] = convertCoordsConveyor(x,y);
            end
            %go to the point
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, z]);
            ui.commandQueue = [ui.commandQueue, 7];
            
            %turn on vacuum
            ui.setIOs = ui.IOs;
            ui.setIOs(1) = 1;
            ui.IOs = ui.setIOs;
            ui.commandQueue = [ui.commandQueue, 1];
            
            %go to a point just above the table
            ui.poseQueue =cat(1, ui.poseQueue, [x, y, z+10]);
            ui.commandQueue = [ui.commandQueue, 7];
        end
        
        
        %assumes that gripper is holding piece
        function obj = placeToPoint(obj, x, y, table)
            global ui;
            %point on table
            if(table == 1)
                [x, y, z] = convertCoordsTable(x, y);
            else
                [x, y, z] = convertCoordsConveyor(x,y);
            end
            %go to the point
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, z]);
            ui.commandQueue = [ui.commandQueue, 7];
            
            %turn off vacuum
            ui.setIOs = ui.IOs;
            ui.setIOs(1) = 0;
            ui.IOs = ui.setIOs;
            ui.commandQueue = [ui.commandQueue, 1];
            
            %go to a point just above the table
            ui.poseQueue =cat(1, ui.poseQueue, [x, y, z+10]);
            ui.commandQueue = [ui.commandQueue, 7];
        end
        
        
        %picks up a piece from the box. Stores its coordinates in the box
        %array. Takes in the xy coordinates of the piece
        function obj = pickUpFromBox(obj)
            %need a function to return the xy coords of a piece in the box
            [x, y] = findFromBox();
            
            
            obj.pickUpFromPoint(x, y, 0);
        end
        
        function [x, y] = findFromBox(obj)
           global ui;
           [obj.blocks, box, foundBox] = detectConveyorBlocks(ui.conveyorRGB);
           index = randi([1, length(obj.blocks)]);
           x = obj.blocks(index, 1);
           y = obj.blocks(index, 2);
        end
        
        %places piece into the box at some random location from the center.
        %Assumes the robot is holding a piece.
        function obj = placeInBox(obj)
            %random distance from box center so that not all pieces are
            %placed in the centre of the box.
            randX = randi([-20,20]);
            randY = randi([-20,20]);
            obj.placeToPoint(obj.boxLocation(1)+randX, obj.boxLocation(2)+randY, 0); 
        end
           
        function obj = orientPiece(obj)
            obj.placeToPoint(obj.orientationPoint(1), obj.orientationPoint(2), 1);
            %read orientation of piece
            
            %orientation = readOrientation(obj.orientationPoint(1), obj.orientationPoint(2))
            orientation = 0;
            
            %rotate the end effector by some amount
            global ui;
            %current end effector angle
            currJoints = ui.pose(9);
            %add 20 degrees (may need to convert to radians)
            adjJoints = currJoints + orientation;
            ui.jointQueue = cat(1, ui.jointQueue, adjJoints);
            ui.commandQueue = [ui.commandQueue, 8];
            
            %pick up piece
            obj.pickUpFromPoint(obj.orientationPoint(1), obj.orientationPoint(2), 1);
            
            
            %rotate the end effector by some amount opposite way (orienting
            %piece)
            ui.jointQueue = cat(1, ui.jointQueue, currJoints);
            ui.commandQueue = [ui.commandQueue, 8];
        end
        
        %takes in the grid square on the board and returns a pixel
        %coordinate. Top left of board is (0, 0)
        function [x_p, y_p] = boardToPixel(obj, x, y)
            x_p = obj.board_topLeft(1) + x*obj.squareSize + 0.5*obj.squareSize;
            y_p = obj.board_topLeft(2) + y*obj.squareSize + 0.5*obj.squareSize;
        end
        
        %takes in a player number and square and returns a pixel
        %coordinate of the centre of the square.
        function [x_p, y_p] = playerToPixel(obj, playerID, n)
            %alternatively, could use topcorner, bottomcorner and board
            %size to determine position of grid squares.
            if(playerID == 0)
                y_p = obj.p1_topLeft(2) + n*obj.squareSize+0.5*obj.squareSize;
                x_p = obj.p1_topLeft(1) + 0.5*obj.squareSize;
            else
                y_p = obj.p2_topLeft(2) + n*obj.squareSize+0.5*obj.squareSize;
                x_p = obj.p2_topLeft(1) + 0.5*obj.squareSize;
            end
        end
    end
end






function [rs_x, rs_y, rs_z] = convertCoordsConveyor(x, y)
% hObject    handle to choosePoint_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;


    M = undistortPoints([x,y], ui.conveyorParams);
    x = M(1,1);
    y = M(1,2);
    z = 10;
    y =1200 - y;
    if(x>1600) || (y>1200) || (x<0) || (y<0)
        x = NaN;
        y = NaN;
        z = NaN;
    end
    
    conveyorOffsetXPx = 215;
    conveyorOffsetYPx = 683;
    
    pxToMM = 0.659375;
    
    rs_y = (x - conveyorOffsetXPx)*pxToMM;
    rs_x = (-y + conveyorOffsetYPx)*pxToMM-16;
    rs_z = 40;
end

function [rs_x, rs_y, rs_z] = convertCoordsTable(x, y)
    global ui;
    M = undistortPoints([x,y], ui.tableParams);
    x = M(1,1);
    y = M(1,2);
    y =1200 - y;
    if(x>1600) || (y>1200) || (x<0) || (y<0)
        x = NaN;
        y = NaN;
        z = NaN;
    end
    
    pxToMM = 0.659375;
    
    tableXoffsetPx = 800; 
    tableYoffsetPx = 1178;
    
    rs_y = (x - tableXoffsetPx)*pxToMM;
    rs_x = (-y + tableYoffsetPx)*pxToMM;    
    rs_z = 147+12;
end