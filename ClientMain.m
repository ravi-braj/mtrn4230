% Client main
% 15 August 2017
% User interface for ABB robot


%%%%%%%%%%%%% 1 SETUP %%%%%%%%%%%%%%

%----- GLOBAL FLAGS ----

global exit;
exit = false;

%----- START GUI -------
clientGui = gui();
GUIData = guidata(clientGui);

%----- Set up timer
mainTimer = timer();
mainTimer.StartDelay = 1;
mainTimer.Period = 0.1;
mainTimer.ExecutionMode = 'fixedRate';


%%%%%%%%%%%%% 2 INITIALISATIONS %%%%%%%%%%%%

%set start up function of the timer
mainTimer.StartFcn = @timerSetup;


%%%%%%%%%%%%% 3 TIMER CALLBACK FUNCTION %%%%%%%%%%%%%%%

%set the call function of the timer
mainTimer.TimerFcn = @timerCallback;

%%%%%%%%%%%%% 4 RUN TIMER %%%%%%%%%%%%%%%%
start(mainTimer);

%%%%%%%%%%%%% 4 WATCH FOR EXIT OF GUI %%%%%%%%%%%%%%%%%%%%%%
while((get(mainTimer, 'Running') ~= "off"))
    pause(0.1);
end

disp("closing");
delete(clientGui);
delete(mainTimer);

