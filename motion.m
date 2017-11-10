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
        
        %boxSpace
        boxSpace;
        
        safePoint;
        
    end
    methods
        function obj = motion()
            %define board positions
            obj.board_topLeft = [551, 286];
            obj.board_bottomRight = [1042, 785];
            
            obj.p1_topLeft = [418, 286];
            obj.p2_topLeft = [1130, 286];
            
            obj.squareSize = 56;
            
            %set orientation point
            obj.orientationPoint = [1140, 709];
            
            obj.boxLocation = [0, 0];
            
            obj.safePoint = [1140, 709];

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
            ui.poseQueue =cat(1, ui.poseQueue, [x, y, 200]);
            ui.commandQueue = [ui.commandQueue, 7];
            %go down to point
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, z]);
            ui.commandQueue = [ui.commandQueue, 7];

            newIOs = ui.IOs;
            newIOs(1) = 1;
            newIOs(2) = 1;
            ui.ioQueue = cat(1, ui.ioQueue, newIOs);
            ui.commandQueue = [ui.commandQueue, 9]; 
            
            %go to a point just above the table
            ui.poseQueue =cat(1, ui.poseQueue, [x, y, 200]);
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
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, 200]);
            ui.commandQueue = [ui.commandQueue, 7];            
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, z]);
            ui.commandQueue = [ui.commandQueue, 7];
            
            %turn off vacuum
            newIOs = ui.IOs;

            newIOs(1) = 0;
            newIOs(2) = 0;
            ui.ioQueue = cat(1, ui.ioQueue, newIOs);
            ui.commandQueue = [ui.commandQueue, 9];            

            %go to a point just above the table
            ui.poseQueue =cat(1, ui.poseQueue, [x, y, 200]);
            ui.commandQueue = [ui.commandQueue, 7];
            disp('added to queue');
        end
        
        
        %picks up a piece from the box. Stores its coordinates in the box
        %array. Takes in the xy coordinates of the piece
        function obj = pickUpFromBox(obj)
            %need a function to return the xy coords of a piece in the box
            [x, y, orientation, reachable] = obj.findFromBox();

            if(reachable)
                obj.pickUpFromPoint(x, y, 0);
                obj.orientPiece(orientation);
            else 
                disp('piece not reachable');
            end
        end
        
        function [x, y, orientation, reachable] = findFromBox(obj)
           global ui;
           [obj.blocks, box, foundBox] = detectConveyor(ui.conveyorRGB);
           if(length(obj.blocks) > 0 && foundBox == 1)
               index = 1;
               x = obj.blocks(index, 1);
               y = obj.blocks(index, 2);
               orientation = obj.blocks(index, 3);
               reachable = obj.blocks(index, 6);
           else
              x = 0;
              y = 0;
              orientation = 0;
              reachable = 0;
           end
        end
        
        %places piece into the box at some random location from the center.
        %Assumes the robot is holding a piece.
        function obj = placeInBox(obj)
            %set the position of the box.
            global ui;
            if(obj.boxLocation(1) == 0 && obj.boxLocation(2) == 0)
                [obj.blocks, box, foundBox] = detectConveyor(ui.conveyorRGB);
                if(foundBox)
                    obj.boxLocation = [box.x, box.y];
                    obj.boxOrientation = -box.orient;
                end
            end

            %random distance from box center so that not all pieces are
            %placed in the centre of the box.
            randX = randi([-20,20]);
            randY = randi([-20,20]);
            obj.goToInterimPoint();
            obj.placeToPoint(obj.boxLocation(1)+randX, obj.boxLocation(2)+randY, 0); 
            obj.goToInterimPoint();
        end
        
        %positive offset is clockwise correction
        %negative offset is anti-clockwise correction
        function obj = orientPiece(obj, orientationOffset)
            global ui;

            %current end effector angle
            currJoints = ui.pose(9);

            adjJoints = currJoints - orientationOffset;
            ui.jointQueue = cat(1, ui.jointQueue, adjJoints);
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

            if(playerID == 1)
                x_p = obj.p1_topLeft(2) + (n-1)*obj.squareSize+0.5*obj.squareSize;
                y_p = obj.p1_topLeft(1) + 0.5*obj.squareSize;
            else
                y_p = obj.p2_topLeft(2) + (n-1)*obj.squareSize+0.5*obj.squareSize;
                x_p = obj.p2_topLeft(1) + 0.5*obj.squareSize;
            end
        end
        
        %assumes a piece is being held. Locates a free space in the box to
        %place it. It will rotate the piece by the angle of the box plus
        %the offset in the arguments
        function obj = arrangeInBox(obj, angleOffset)
            global ui;
            
            if(obj.boxLocation(1) == 0 && obj.boxLocation(2) == 0)
                [obj.blocks, box, foundBox] = detectConveyorBlocks(ui.conveyorRGB);
                if(foundBox)
                    obj.boxLocation = [box.x, box.y];
                    obj.boxOrientation = -box.orient;
                end
            end
            disp('box orientation')
            disp(obj.boxOrientation)
            box_topLeft(1) = obj.boxLocation(1)-3*obj.squareSize;
            box_topLeft(2) = obj.boxLocation(2) + obj.squareSize;
            
            %orient the piece
            obj.orientPiece(angleOffset+obj.boxOrientation);
           

            for i = 1:length(obj.boxSpace)
                %empty space
                if(obj.boxSpace(i) == 0)
                    [r_box, c_box] = ind2sub(size(obj.boxSpace), i);
                    xb = (r_box-1)*obj.squareSize+0.5*obj.squareSize;
                    yb = (c_box-1)*obj.squareSize+0.5*obj.squareSize;
                    
                    xb_ = xb*cosd(obj.boxOrientation)-yb*sind(obj.boxOrientation);
                    yb_ = xb*sind(obj.boxOrientation)+yb*cosd(obj.boxOrientation);
                    
                    xb_ = xb_+ box_topLeft(1);
                    yb_ = yb_ + box_topLeft(2);
                    
                    disp(xb_)
                    disp(yb_)
                    
                    obj.placeToPoint(xb_, yb_, 0);
                    obj.boxSpace(i) = 1;
                    return;
                end
            end
        end
        
        %a safe point so that linear mode can be used
        function obj = goToInterimPoint(obj)
            global ui;
            %point on table
            [x, y, z] = convertCoordsTable(obj.safePoint(1), obj.safePoint(2));
            %go to the point
            ui.poseQueue = cat(1, ui.poseQueue, [x, y, 200]);
            ui.commandQueue = [ui.commandQueue, 7];            
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
    
    rs_y = (x - conveyorOffsetXPx)*pxToMM-8;
    rs_x = (-y + conveyorOffsetYPx)*pxToMM-12;
    rs_z = 33;
    %rs_z = 33+100;
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
    rs_z = 147+7;
    
end