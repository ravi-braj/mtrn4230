

function timerSetup(obj, event, interface)
    disp("setup");
    % Serial connections for camera
    %vid1 = videoinput('winvideo', 1, 'RGB24_1600x1200'); % table
    interface.converyorObj = videoinput('winvideo', 2, 'RGB24_1600x1200'); %conveyor
    preview(interface.converyorObj);
    
    pause(1);


end