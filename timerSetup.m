

function timerSetup(obj, event, interface)
    disp("setup");
    interface.robotTCP.openTCP('127.0.0.1', 1025);
    pause(1);


end