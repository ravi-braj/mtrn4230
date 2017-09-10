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
        
        %add handles for having box here
        h_plotTable
        h_textTable

        %add handles for having box here
        h_plotConveyor
        h_textConveyor
        
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
        setPoseJoints
        setMotionMode
        setIOs
        setJOG
        
        
        %variables for reading (Telem variables)
        speed
        pose
        poseJoints
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
            obj.pose = [0, 0, 0, 0, 0, 0, 0, 0, 0];
            obj.setPose = [0,0,0];
            
            obj.motionMode = string('linear');
            
            
            obj.robotTCP.openTCP('127.0.0.1', 1025);
            %obj.robotTCP.openTCP('192.168.125.1', 1025);
            
            
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
            obj.h_camConveyor = image(obj.clientGUIData.camera_conveyor, NaN(1200,1600));
            set(obj.clientGUIData.camera_conveyor,'xtick',[],'ytick',[])
            obj.h_camTable = image(obj.clientGUIData.camera_table, NaN(1200, 1600));
            set(obj.clientGUIData.camera_table,'xtick',[],'ytick',[])
            
             % Plot handles
            obj.h_plotTable = plot(obj.clientGUIData.camera_table,0,0,'b+');
            obj.h_plotConveyor = plot(obj.clientGUIData.camera_conveyor,0,0,'b+');
            % Text handles
            obj.h_textTable = text(obj.clientGUIData.camera_table, NaN, NaN, '');
            obj.h_textConveyor = text(obj.clientGUIData.camera_conveyor, NaN, NaN, '');
            %----------- OTHER HANDLES ----------------%
            
        end
        
        %updates the pose displayed by the interface.
        function obj = updatePose(obj, pos_x, pos_y, pos_z, jointArray)
            set(obj.clientGUIData.pose_x, 'String', pos_x);
            set(obj.clientGUIData.pose_y, 'String', pos_y);
            set(obj.clientGUIData.pose_z, 'String', pos_z);
            set(obj.clientGUIData.pose_j1, 'String', jointArray(1))
            set(obj.clientGUIData.pose_j2, 'String', jointArray(2))
            set(obj.clientGUIData.pose_j3, 'String', jointArray(3))
            set(obj.clientGUIData.pose_j4, 'String', jointArray(4))
            set(obj.clientGUIData.pose_j5, 'String', jointArray(5))
            set(obj.clientGUIData.pose_j6, 'String', jointArray(6))
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
            %disp('executing next command')
            
            if(size(obj.commandQueue)  == 0)
                %disp('no commands to execute');
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
                    case 4
                        disp('sending motionMode');
                        if(obj.setMotionMode == 1)
                            comm = sprintf('Setting joint mode');
                        else
                            comm = sprintf('Setting linear mode');
                        end
                        obj.robotTCP.setMotionMode(obj.setMotionMode);
                        obj.commandHistory = [obj.commandHistory; string(comm)];
                    case 5
                        disp('setting speed');
                        obj.robotTCP.setSpeed(obj.setSpeed);
                        comm = sprintf("Setting speed: %0.0f", obj.setSpeed);
                        obj.commandHistory = [obj.commandHistory; string(comm)];

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