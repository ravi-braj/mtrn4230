%moves implemented to facilitate qwirkle playing
%mostly just manipulation of qwirkle pieces



classdef motion < handle
    properties (Access = public)
        %variables regarding the board
        
        
        
    end
    methods
        function obj = motion()
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