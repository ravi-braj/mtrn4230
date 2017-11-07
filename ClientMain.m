% Client main
% 15 August 2017
% User interface for ABB robot


%% %%%%%%%%%%% 1 SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc(); clear;
global ui;

try
    %delete(ui.tableObj);
    %delete(ui.conveyorObj);
catch
end



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

%%RUNNING QWIRKLE SIMULATION
%%Initialize Board
StartBoard = zeros(9,9,2);
Board = StartBoard;
%%Insert first piece in the middile
%%Board(5,5,:) = [randi([1 6]),randi([1 6])];
%%Initialize Pieces
GamePieces = zeros(6,2);
P1GamePieces = GamePieces;
P2GamePieces = GamePieces;
%%Making Fake Pieces
% for y = 1:6
%     GamePieces(y,1) = randi([1 6]); %%Color
%     GamePieces(y,2) = randi([1 6]); %%Shape
% end
button = 0;
Player = 1;
P1Action = 'Waiting';
P2Action = 'Waiting';
P1TotalScore = 0;
P2TotalScore = 0;
QUIT = false;

while(~QUIT)
    %QwirkleClient2 runs 1 iteration of QwirkleClient
    QwirkleClient2
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
close Figure 10;
%Delete webcam objects when exiting function
delete(ui.tableObj)
delete(ui.conveyorObj)

%Deleter the User Interface
delete(ui.clientGUI);

%Delete Timer Object
delete(mainTimer);

%Program End