% Client main
% 15 August 2017
% User interface for ABB robot


%% %%%%%%%%%%% 1 SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----- GLOBAL FLAGS ----

global exit;
exit = false;

checklist_complete = false;

%----- START CHECKLIST GUI -----
%end of checklist gui sets flag checklist_complete


%----- START GUI -------
% gui is constructed in interface constructor function
while(checklist_complete == false)
    %donothing
end
ui = interface();

%----- Set up timer
mainTimer = timer();
mainTimer.StartDelay = 1;
mainTimer.Period = 0.1;
mainTimer.ExecutionMode = 'fixedRate';


%% %%%%%%%%%%% 2 INITIALISATIONS %%%%%%%%%%%%%%%%%%%%%%%

%set start up function of the timer
mainTimer.StartFcn = {@timerSetup, ui};


%% %%%%%%%%%%% 3 TIMER CALLBACK FUNCTION %%%%%%%%%%%%%%%

%set the call function of the timer
mainTimer.TimerFcn = {@timerCallback, ui};

%% %%%%%%%%%%% 4 RUN TIMER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start(mainTimer);

%% %%%%%%%%%%% 5 WATCH FOR EXIT OF GUI %%%%%%%%%%%%%%%%%
while((get(mainTimer, 'Running') ~= 'off'))
    pause(0.1);
end

disp('closing');
delete(ui.clientGUI);
delete(mainTimer);

