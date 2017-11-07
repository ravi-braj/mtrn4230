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
    ui.conveyorParams = load('conveyorParams.mat');
    ui.conveyorParams = ui.conveyorParams.conveyorParams;
    ui.tableParams = load('cameraParamsTable.mat');
    ui.tableParams = ui.tableParams.cameraParamsTable;

%     % Initialize Qwirkle Board
%     StartBoard = zeros(9,9,2);
%     ui.Board = StartBoard;
%     % Insert first piece in the middile
%     % Will create random piece in center to start game. Need to tell robot
%     % studio to do this. Better to do this with vision and choose a random
%     % piece from the box.
%     ui.Board(5,5,:) = [randi([1 6]),randi([1 6])]; 
%     % Initialize Pieces
%     GamePieces = zeros(6,2);
%     ui.P1GamePieces = GamePieces;
%     ui.P2GamePieces = GamePieces;
%     %Check function name with dan
%     [ui.P1GamePieces, ui.P2GamePieces] = updateGameState(ui.tableRGB);
%     
%     ui.Player = 1;
%     ui.P1Action = 'Waiting';
%     ui.P2Action = 'Waiting';
%     ui.P1TotalScore = 0;
%     ui.P2TotalScore = 0;
%     
    % Update Qwirkle Interface
%     Game_Interface;
    
    pause(1);

end