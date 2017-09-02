%%%% CALLBACK FUNCTION FOR CLIENTMAIN TIMER


function timerCallback(obj, event, ui) 

    %av_period = get(obj, 'AveragePeriod')
    fprintf("Timer callback executed. %f seconds since last call\n", get(obj, 'InstantPeriod'));
    
    %% %%%%%%%%%%%% CONDITIONAL EXECUTIONS %%%%%%%%%%%%%%
    
    %%------------- send commands to robot --------------------
    % 1) check the command queue to see if there is a command waiting
    % 2) send command via tcp and remove it from the command queue
    
    
    %% ---------- request status of i/o via tcp from robot -----
    % 1) send a request packet to the robot
    % 2) receive the i/o packet from the robot
    % 3) update status of i/o s
    
    %currently fills io status on gui to junk data
    ui.updateIOs(randi([0 1],1,4));
    
    %% ---------- request pose of the robot and update ui ------
    % 1) send request packet to robot
    % 2) receive the packet from the robot
    % 3) update interface
    
    
    ui.updatePose(rand(), rand(), rand());
    
    
    
    %% ---------- receive serial from camera ---------------------
    % 1) receive the serial data
    ui.datafromConveyorCam();
    %box(ui.camData); commented out since camData is currently just stub
    % 2) use gui plot handle for setting the data in the camera plot

    
    
    
     %some dummy data
    y = get(ui.h_camConveyor, 'YData');
    y = [y(end), y(1:end-1)];

    set(ui.h_camConveyor, 'YData', y);

    
    
    %% ---------- receive tcp from conveyor camera -----------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the camera plot
    
    y = get(ui.h_camTable, 'YData');
    y = [y(2:end), y(1)];
    set(ui.h_camTable, 'YData', y);

    
    %% %%%%%%%%%%%% FIRST READ %%%%%%%%%%%%%%%%%%%%%
    %disp("first read?");
    %ui.robotTCP.firstRead();
    
    
    %% %%%%%%%%%%%% EXIT PROGRAM CONDITION %%%%%%%%%%%%%%%%%%%
    
    %exit button pressed, stop the timer
    global exit;
    if(exit == true)
        disp('stopping');
        stop(obj);
    end

end

