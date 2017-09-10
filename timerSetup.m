

function timerSetup(obj, event, interface)

    disp('setup');

    % Serial connections for camera
    try
        interface.tableObj = webcam(1); % table
        interface.conveyorObj = webcam(2); %conveyor
        %interface.tableObj.Resolution = '1600x1200';
        %interface.conveyorObj.Resolution = '1600x1200';
        disp('yes');
    catch
        
    end
        
    pause(1);

end