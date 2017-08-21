%%%% CALLBACK FUNCTION FOR CLIENTMAIN TIMER


function timerCallback(obj, event, interface) 

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
    
    
    interface.updateIOs(randi([0 1],1,4));
    
    %% ---------- request pose of the robot and update ui ------
    % 1) send request packet to robot
    % 2) receive the packet from the robot
    % 3) update interface
    
    
    interface.updatePose(rand(), rand(), rand());
    
    
    
    %% ---------- receive tcp from camera ---------------------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the camera plot

     %some dummy data
    x = get(interface.h_camConveyor, 'XData');
    x = [x(end), x(1:end-1)];

    set(interface.h_camConveyor, 'XData', x);

    
    
    %% ---------- receive tcp from conveyor camera -----------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the camera plot
    
    x = get(interface.h_camTable, 'XData');
    x = [x(2:end), x(1)];
    set(interface.h_camTable, 'XData', x);

    
    
    
    
    %% %%%%%%%%%%%% EXIT PROGRAM CONDITION %%%%%%%%%%%%%%%%%%%
    
    %exit button pressed, stop the timer
    global exit;
    if(exit == true)
        disp("stopping");
        stop(obj);
    end

end

