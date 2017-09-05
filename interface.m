% wrapper class for the GUI data
% designed to stop globals being passed around everywhere. Instead just
% pass an 'interface' object to access all your handles.

% command queue protocol
% 1 = 
% 2 = 
% 3 = 
% 4 = 
% 5 = 

classdef interface < handle
    properties (Access = public)
        %user interface
        clientGUI
        clientGUIData
        
        %tcp object
        robotTCP
        
        % handles
        h_camConveyor
        h_camTable
        
        %rgb data conveyor
        conveyorObj
        conveyorRGB
        boxPose
        
        %rgb data table
        tableObj
        tableRGB
        
        %Queue stuff
        commandQueue
        
        %Array of strings to display historic commands to robot
        commandHistory
        
        %variables for sending
        setSpeed
        setPose
        setMotionMode
        setIOs
        setJOG
        
        
        %variables for reading (Telem variables)
        speed
        pose
        IOs
        

        %control variables
        motionMode
        
    end
    methods
        
        %% constructor
        function obj = interface()
            obj.clientGUI = gui();
            obj.clientGUIData = guidata(obj.clientGUI);
            
            %----------- robot tcp -------------------%
            obj.robotTCP = abb_tcp();
            
            obj.IOs = [0, 0, 0, 0];
            obj.pose = [0, 0, 0]; %zeros(1,7);
            obj.setPose = [0,0,0];
            
            obj.motionMode = "linear";
            
            
            obj.robotTCP.openTCP('127.0.0.1', 1025);
            
            
            
            %disable connect button
            if(obj.robotTCP.connected)
                set(obj.clientGUIData.connect_tcp,'Enable','off');
                set(obj.clientGUIData.connect_tcp,'String','Connected'); 
            end
            
            %----------- PLOT HANDLES ----------------%
            % set up plots for the handles - use the 'tag' in the GUI as
            % the handle in the plot constructor and assign to a new handle
            % the handles in the GUI are of axes type which is an
            % encompassing type whereas we need to deal with plot types 
            %(or other) which are child classes of axes
            
            %%dummy data to fill plots
            x = linspace(1, 20, 100);
            y = sin(x);
            obj.h_camConveyor = image(obj.clientGUIData.camera_conveyor, NaN(1600,1200));
            set(obj.clientGUIData.camera_conveyor,'xtick',[],'ytick',[])
            obj.h_camTable = image(obj.clientGUIData.camera_table, NaN(1600, 1200));
            set(obj.clientGUIData.camera_table,'xtick',[],'ytick',[])
            
            %----------- OTHER HANDLES ----------------%
            
        end
        
        %updates the pose displayed by the interface.
        function obj = updatePose(obj, pos_x, pos_y, pos_z)
            set(obj.clientGUIData.pose_x, 'String', pos_x);
            set(obj.clientGUIData.pose_y, 'String', pos_y);
            set(obj.clientGUIData.pose_z, 'String', pos_z);
        end
        
        %takes in the array of i/o statuses and updates interface
        function obj = updateIOs(obj, ioArray)
            set(obj.clientGUIData.io_vacuum_on, 'String', ioArray(1));
            set(obj.clientGUIData.io_solenoid_on, 'String', ioArray(2));
            set(obj.clientGUIData.io_conveyor_enable, 'String', ioArray(3));
            set(obj.clientGUIData.io_conveyor_direction, 'String', ioArray(4));
        end
        
        % get serial data from camera on conveyor - updates conveyorRGB
        % property (rgb)
        function obj = datafromConveyorCam(obj)
            %obj.camRGB = blahblahgetserial
            %update rgb data in camdata
            obj.conveyorRGB = snapshot(obj.conveyorObj);
            
        end
        
        % get serial data from camera on table - updates tableRGB
        % property (rgb)
        function obj = datafromTableCam(obj)
            %obj.camRGB = blahblahgetserial
            %update rgb data in camdata
            obj.tableRGB = snapshot(obj.tableObj);
            
        end
        
        %tries to send the next command in the commandQueue to the robot
        function obj = nextCommand(obj)
            disp('executing next command')
            
            if(size(obj.commandQueue)  == 0)
                disp('no commands to execute');
                return
            end
            
            nextCommand = obj.commandQueue(1)
        
            %only execute command queue if the robot is connected
            %still tries and removes commands (so queue doesnt bank)
            %add command to command queue
            if(obj.robotTCP.connected == true)
                %execute command
                switch nextCommand
                    %send pose
                    case 1
                        obj.robotTCP.setIOs(obj.setIOs)
                        comm = sprintf('Setting I/Os: [%d, %d, %d, %d]', obj.setIOs(1), obj.setIOs(2), obj.setIOs(3), obj.setIOs(4))
                        obj.commandHistory = [obj.commandHistory; string(comm)];
                        disp('sending IOs');
                    case 2
                        obj.robotTCP.setPose(obj.setPose);
                        comm = sprintf('Setting pose: [%0.3f, %0.3f, %0.3f]', obj.setPose(1), obj.setPose(2), obj.setPose(3))
                        obj.commandHistory = [obj.commandHistory; string(comm)];
                        disp('sending pose');

                    case 3
                        disp('sending JOG command');
                        obj.robotTCP.setJOG(obj.setJOG);

                    otherwise
                        disp('cannot decipher queue object');
                end
            end
            
            set(obj.clientGUIData.command_history,'String',obj.commandHistory);
       

            %remove item from command queue
            if(size(obj.commandQueue) == 1)
                obj.commandQueue = [];
            else
                obj.commandQueue = obj.commandQueue(2:end);
            end
   
        end
        
        
        
        
    end
end