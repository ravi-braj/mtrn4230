

function timerSetup(obj, event, interface)

    disp('setup');

    % Serial connections for camera
    try
        interface.tableObj = webcam(1); % table
        interface.conveyorObj = webcam(2); %conveyor
        disp('yes');
    catch
        
    end
        
    pause(1);


end