% Set up function for client side timer. 
% Takes in a user interface, does initalisations
% Written by Aravind Baratha Raj
% Last modified 15 September 2017

function timerSetup(obj, event, interface)
    global ui
    disp('setup');

    %Serial connections for camera
    
    %Try is used so that the software works on our personal computer aswell
    %for testing purposes
    try
        %Create Objects to connect to the relevant objects
        ui.tableObj = webcam(1); % table
        ui.conveyorObj = webcam(2); %conveyor
        %Set Resolutions to the 1600x1200 if available
        interface.tableObj.Resolution = '1600x1200';
        interface.conveyorObj.Resolution = '1600x1200';
        disp('yes');
    catch
        
    end
        
    pause(1);

end