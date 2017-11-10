%%%% CALLBACK FUNCTION FOR CLIENTMAIN TIMER
%Takes in the user interface object
%Executes the main tick of the client side
%Written by Aravind Baratha Raj
%Last modified 15 September 2017


function timerCallback(obj, event, ui) 
    disp('Running main timer');
    %av_period = get(obj, 'AveragePeriod')
    fprintf('Timer callback executed. %f seconds since last call\n', get(obj, 'InstantPeriod'));
    
    

    
    %% %%%%%%%%%%%% CONDITIONAL EXECUTIONS %%%%%%%%%%%%%%
    
    %%------------- Send commands to robot --------------------
    % 1) Check the command queue to see if there is a command waiting
    % 2) Send command via tcp and remove it from the command queue
    
    
    %% ---------- Request status of I/O via tcp from robot -----
    % 1) Send a request packet to the robot
    % 2) Receive the i/o packet from the robot
    % 3) Update status of i/o s
    
    % Fills I/O status on gui to junk data here
    
    ui.updateIOs(ui.IOs);
    
    %% ---------- request pose of the robot and update ui ------
    % 1) send request packet to robot
    % 2) receive the packet from the robot
    % 3) update interface
    
    ui.pose = ui.robotTCP.requestPose();
    ui.updatePose(ui.pose(1), ui.pose(2), ui.pose(3), ui.pose(4:9));
    
    %% ---------- poll error status ----------------
    ui.error = ui.robotTCP.requestErrors();
    ui.updateErrors(ui.error);
    
    %% ---------- receive serial from conveyor camera ---------------------
    % 1) receive the serial data
    % 2) use gui plot handle for setting the data in the conveyor camera plot
    try
        ui.datafromConveyorCam();
        set(ui.h_camConveyor, 'CData', ui.conveyorRGB);
    catch
        disp('no camera data from conveyor')
        sb = sprintf('img%01d.jpg',round(randi([1 23],1,1)));
        ui.conveyorRGB = imread(sb);
        set(ui.h_camConveyor, 'CData', ui.conveyorRGB);
    end

    %% ---------- receive serial from table camera ------------------------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the table camera plot
    %s = sprintf('IMG_0%02d.jpg',round(randi([1 99],1,1)));
    try
       %I = imread(s);
       %I = imread('IMG_005.jpg');
       I = ui.tableRGB;
    catch
       I = imread('IMG_005.jpg');
    end
    
    try
        ui.datafromTableCam();
        %set(ui.h_camTable, 'CData', ui.tableRGB);
        set(ui.h_camTable,'CData', I);
    catch
        set(ui.h_camTable, 'CData', I);
    end
    
    
    %Only redetect the blocks and Box pose and properties every 6 periods 
    %to increase speed of program execution
    
    if mod(ui.count,15) == 0
        
        if(ui.detectBlocks == 1)
            % Call function detect_blocks
            blocks = detect_blocks(I);
            blockstext = Update_TableHdl(blocks);
            %set(ui.h_camTable,'xdata',blocks(:,1),'ydata',blocks(:,2));
            delete(ui.h_textTable);
            ui.h_textTable = text(ui.clientGUIData.camera_table, blocks(:,1), 1200.-blocks(:,2), blockstext, 'Color', 'red', 'FontSize',6);
        end
        if(ui.detectBox == 1)
            [centroid, orientation] = box(ui.conveyorRGB);
            boxtext = sprintf('%.2f %.2f %.2f', round(centroid(:,1),2), round(centroid(:,2),2), round(orientation));

            delete(ui.h_textConveyor);
            ui.h_textConveyor = text(ui.clientGUIData.camera_conveyor, centroid(:,1), centroid(:,2), boxtext, 'Color', 'red', 'FontSize',6);
        end
    end
    
        %% ---------- Display Game Board ---------------------
    % 1) receive the serial data
    % 2) use gui plot handle for setting the data in the conveyor camera plot
    % display game board here using Game_Interface function if required
    % every iteration, for now testing if it can just be updated when a
    % move is made
    %% Check Box position
    if ui.loadBox == 1
        % If Box is not in position. Turn on conveyor. If on leave it on
        % If Box is in position, Turn conveyor off, set loadBox to 0
        [~, ~, found] = detectConveyorBlocks(ui.conveyorRGB);
        if (~found)
           % If conveyor is off. Turn Conveyor on
           if ui.IOs(3) ~= 1
                    ui.setIOs = ui.IOs;
                    ui.setIOs(3) = 1;
                    ui.setIOs(4) = 1;
                    ui.IOs = ui.setIOs;
                    ui.commandQueue = [ui.commandQueue, 1];
           end
        else
            disp('Found Box');
            % As Load Box is complete. Turn conveyor off
            ui.setIOs = ui.IOs;
            ui.setIOs(3) = 0;
            ui.IOs = ui.setIOs;
            ui.commandQueue = [ui.commandQueue, 1];
            
            % As Load Box complete. Set flag to 0 again
            ui.loadBox = 0;
        end
        
    end
    
    %% ----------- execute queued commands (added by GUI) ------
    ui.nextCommand();
    
    %------------- Increment counter -------------------------
    ui.count = ui.count+1;
    
    
    
    %% %%%%%%%%%%%% EXIT PROGRAM CONDITION %%%%%%%%%%%%%%%%%%%
    
    %exit button pressed, stop the timer
    global exit;
    if(exit == true)
        disp('stopping');
        stop(obj);
    end

end


function textoutput = Update_TableHdl(c)
    %Produce Strings for text output theta, colour, shape, upper_surface, reachable
       
    if (~isempty(c))
        for i=1:size(c,1)
            % Get orientation as a text
            orientation = string(c(i,3));
            % Check what colour the top surface of the box is
            
            if c(i,4) == 1
                colour = 'red';
            elseif c(i,4) == 2
                colour = 'orange';
            elseif c(i,4) == 3
                colour = 'yellow';
            elseif c(i,4) == 4
                colour = 'green';
            elseif c(i,4) == 5
                colour = 'blue';
            elseif c(i,4) == 6
                colour = 'purple';
            elseif c(i,4) == 0
                colour = 'inverted';
            end
            % Check what shape the top surface of the box is
            
            if c(i,5) == 1
                shape = 'square';
            elseif c(i,5) == 2
                shape = 'diamond';
            elseif c(i,5) == 3
                shape = 'circle';
            elseif c(i,5) == 4
                shape = 'club';
            elseif c(i,5) == 5
                shape = 'cross';
            elseif c(i,5) == 6
                shape = 'star';
            elseif c(i,5) == 0
                shape = 'inverted';
            end
            
            % Check if the upper surface is inverted
            % Coloured side = 1
            % Inverted side = 2
            if c(i,6) == 1
                uppersurface = '1';
            elseif c(i,6) == 2
                uppersurface = '2';
            else
                uppersurface = '';
            end
            
            % Check to if the block is reachable by robot
            % Reachable = 1
            % Not Reachable = 0
            if c(i,7) == 1
                reachable = '1';
            elseif c(i,7) == 0
                reachable = '0';
            end
            %textoutput(i) = "yes";
            textoutput(i) = {sprintf('%s,%s,%s,%c,%c',orientation,string(colour),string(shape),uppersurface,reachable)};
        end
    else
        textoutput = '';
    end
end