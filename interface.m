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
        %User interface variables
        clientGUI
        clientGUIData
        
        %TCP object
        robotTCP
        
        %Switch on or off block detection for performance and speed of program
        detectBlocks
        detectBox
        
        %Handles for the figures on the GUI
        h_camConveyor
        h_camTable
        
        %Add handles for showing box position and its properties
        h_plotTable
        h_textTable

        %add handles for having box position and its properties
        h_plotConveyor
        h_textConveyor
        
        %RGB data for conveyor
        conveyorObj
        conveyorRGB
        boxPose
        
        %RGB data for table
        tableObj
        tableRGB
        
        %Queue vairable
        commandQueue
        
        %Array of strings to display history of commands sent to robot
        commandHistory
        
        %Variables to send data to robot
        setSpeed
        setPose
        setPoseJoints
        setMotionMode
        setIOs
        setJOG
        setStop
        
        
        %Variables for reading data from robot(Telem variables)
        speed
        pose
        poseJoints
        IOs
        error
        

        %Control variables
        motionMode
        
        %Counter
        count
        
    end
    methods
        
        %% Constructor
        function obj = interface()
            obj.clientGUI = gui();
            obj.clientGUIData = guidata(obj.clientGUI);
            
            %----------- robot tcp -------------------%
            obj.robotTCP = abb_tcp();
            
            obj.IOs = [0, 0, 0, 0];
            obj.pose = [0, 0, 0, 0, 0, 0, 0, 0, 0];
            obj.setPose = [0,0,0];
            obj.error = [0,0,0,0,0,0];
            obj.motionMode = string('linear');
            
            
            obj.robotTCP.openTCP('127.0.0.1', 1025);
            %obj.robotTCP.openTCP('192.168.125.1', 1025);
            
            obj.detectBlocks = 0;
            
            obj.count = 0;
            
            %Disable connect button
            if(obj.robotTCP.connected)
                set(obj.clientGUIData.connect_tcp,'Enable','off');
                set(obj.clientGUIData.connect_tcp,'String','Connected'); 
            end
            
            %----------- PLOT HANDLES ----------------%
            % Set up plots for the handles - use the 'tag' in the GUI as
            % the handle in the plot constructor and assign to a new handle
            % the handles in the GUI are of axes type which is an
            % encompassing type whereas we need to deal with plot types 
            %(or other) which are child classes of axes
            
            %%Dummy data to fill plots
            %hold on
            obj.h_camConveyor = image(obj.clientGUIData.camera_conveyor, NaN(1200,1600,3));
            hold(obj.clientGUIData.camera_conveyor,'on');
            %set(obj.clientGUIData.camera_conveyor,'xtick',[],'ytick',[])
            obj.h_plotConveyor = plot(50,50,'r+','Parent', obj.clientGUIData.camera_conveyor);
            %obj.h_textConveyor = text(NaN, NaN, '','Parent', obj.clientGUIData.camera_conveyor);
            hold(obj.clientGUIData.camera_conveyor,'off');
            
         
            obj.h_camTable = image(obj.clientGUIData.camera_table, NaN(1200, 1600,3));
            hold(obj.clientGUIData.camera_table,'on');
            %set(obj.clientGUIData.camera_table,'xtick',[],'ytick',[])
            
            obj.h_plotTable = plot(0,0,'b+', 'Parent', obj.clientGUIData.camera_table);
            %axis([0 1600 0 1200], 'parent', obj.clientGUIData.camera_table);
            %obj.h_textTable = text(NaN, NaN, '', 'Parent', obj.clientGUIData.camera_table);
            hold(obj.clientGUIData.camera_table,'off');

            %----------- OTHER HANDLES ----------------%
            
        end
        
        %Updates the pose displayed by the interface.
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
        

        
        %Takes in the array of I/O statuses from robot studio and updates interface
        function obj = updateIOs(obj, ioArray)
            set(obj.clientGUIData.io_vacuum_on, 'String', ioArray(1));
            set(obj.clientGUIData.io_solenoid_on, 'String', ioArray(2));
            set(obj.clientGUIData.io_conveyor_enable, 'String', ioArray(3));
            set(obj.clientGUIData.io_conveyor_direction, 'String', ioArray(4));
        end
        
        function obj = updateErrors(obj, errors)
            set(obj.clientGUIData.error_ven, 'String', errors(1));
            set(obj.clientGUIData.error_ves, 'String', errors(2));
            set(obj.clientGUIData.error_vgs, 'String', errors(3));
            set(obj.clientGUIData.error_vman, 'String', errors(4));
            set(obj.clientGUIData.error_vmb, 'String', errors(5));
            set(obj.clientGUIData.error_vml, 'String', errors(6));
        end
        
        %Get RGB image from conveyor camera object - updates conveyorRGB
        function obj = datafromConveyorCam(obj)
            %update rgb image data in conveyoRGB
            obj.conveyorRGB = snapshot(obj.conveyorObj);
        end
        
        % get RGB image from table camera object - updates tableRGB
        function obj = datafromTableCam(obj)
            %update rgb image data in tableRGB
            obj.tableRGB = snapshot(obj.tableObj);
        end
        
        %Tries to send the next command in the commandQueue to the robot
        function obj = nextCommand(obj)
            %disp('executing next command')
            
            if(size(obj.commandQueue)  == 0)
                %disp('no commands to execute');
                return
            end
            
            nextCommand = obj.commandQueue(1)
        
            %Only execute command queue if the robot is connected
            %Tries and removes commands (so queue doesnt bank)
            %Add command to command queue
            if(obj.robotTCP.connected == true)
                %execute command
                switch nextCommand
                    %Send pose
                    case 1
                        
                        obj.robotTCP.setIOs(obj.setIOs)
                        comm = sprintf('Setting I/Os: [%d, %d, %d, %d]', obj.setIOs(1), obj.setIOs(2), obj.setIOs(3), obj.setIOs(4))
                        obj.commandHistory = [obj.commandHistory; string(comm)];
                        disp('sending IOs');
                    case 2
                        distance = sqrt((obj.setPose(1))^2 + (obj.setPose(2))^2);
                        if (distance > 500)
                            comm = sprintf('Pose out of reach');
                        else
                            obj.robotTCP.setPose(obj.setPose);
                            comm = sprintf('Setting pose: [%0.3f, %0.3f, %0.3f]', obj.setPose(1), obj.setPose(2), obj.setPose(3));
                            disp('sending pose');
                        end 

                        obj.commandHistory = [obj.commandHistory; string(comm)];
                       
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
                        comm = sprintf('Setting speed: %0.0f', obj.setSpeed);
                        obj.commandHistory = [obj.commandHistory; string(comm)];
                    case 6
                        
                        obj.robotTCP.pauseRobot(obj.setStop);
                        if(obj.setStop == 1)
                            disp('pausing robot');
                            comm = string('pausing robot');
                        elseif obj.setStop == 0
                            disp('unpausing robot');
                            comm = string('unpausing robot');
                        end
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