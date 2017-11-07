% Client main
% 15 August 2017
% User interface for ABB robot


%% %%%%%%%%%%% 1 SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc(); clear;
global ui;




%----- GLOBAL FLAGS ----

global exit;
exit = false;

global checklist_complete;



checklist_complete = false;

%----- START CHECKLIST GUI 
startCheckUI = StartUpCheckList();
%End of checklist gui sets flag checklist_complete

%----- START GUI -------

%Program waits for checklist to be declared complete
while(checklist_complete == false)
    pause(1);
end
delete(startCheckUI);

%Gui is constructed in interface constructor function
ui = interface();

%----- Set up timer
mainTimer = timer();
mainTimer.StartDelay = 1;
mainTimer.Period = 0.1;
mainTimer.ExecutionMode = 'fixedDelay';


%% %%%%%%%%%%% 2 INITIALISATIONS %%%%%%%%%%%%%%%%%%%%%%%

%Set start up function of the timer
mainTimer.StartFcn = {@timerSetup, ui};


%% %%%%%%%%%%% 3 TIMER CALLBACK FUNCTION %%%%%%%%%%%%%%%

%set the call function of the timer
mainTimer.TimerFcn = {@timerCallback, ui};

%% %%%%%%%%%%% 4 RUN TIMER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start(mainTimer);

%% %%%%%%%%%%% 5 WATCH FOR EXIT OF GUI %%%%%%%%%%%%%%%%%
while(1)
    try 
        if(get(mainTimer, 'Running') == 'off')
            break;
        end
    catch
    end
    pause(0.1);
end
disp('closing');
%Close Qwirkle figure
%Delete webcam objects when exiting function
delete(ui.tableObj)
delete(ui.conveyorObj)
imaqreset
%Deleter the User Interface
delete(ui.clientGUI);

%Delete Timer Object
delete(mainTimer);

%Program End