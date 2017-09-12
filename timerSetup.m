

function timerSetup(obj, event, interface)
    global ui
    disp('setup');

    % Serial connections for camera
    try
        ui.tableObj = webcam(1); % table
        ui.conveyorObj = webcam(2); %conveyor
        %interface.tableObj.Resolution = '1600x1200';
        %interface.conveyorObj.Resolution = '1600x1200';
        disp('yes');
    catch
        
    end
        
    pause(1);

end