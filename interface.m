% wrapper class for the GUI data
% designed to stop globals being passed around everywhere. Instead just
% pass an 'interface' object to access all your handles.

classdef interface
    properties (Access = public)
        %user interface
        clientGUI
        clientGUIData
        
        %tcp object
        robotTCP
        
        % handles
        h_camConveyor
        h_camTable
        
    end
    methods
        
        %% constructor
        function obj = interface()
            obj.clientGUI = gui();
            obj.clientGUIData = guidata(obj.clientGUI);
            
            %----------- robot tcp -------------------%
            obj.robotTCP = abb_tcp();
            
            %----------- PLOT HANDLES ----------------%
            % set up plots for the handles - use the 'tag' in the GUI as
            % the handle in the plot constructor and assign to a new handle
            % the handles in the GUI are of axes type which is an
            % encompassing type whereas we need to deal with plot types 
            %(or other) which are child classes of axes
            
            %%dummy data to fill plots
            x = linspace(1, 20, 100);
            y = sin(x);
            obj.h_camConveyor = plot(obj.clientGUIData.camera_conveyor, x, y);
            obj.h_camTable = plot(obj.clientGUIData.camera_table, x, y);
            
            %----------- OTHER HANDLES ----------------%
            
        end
        
        %updates the pose displayed by the interface.
        function updatePose(obj, pos_x, pos_y, pos_z)
            set(obj.clientGUIData.pose_x, 'String', pos_x);
            set(obj.clientGUIData.pose_y, 'String', pos_y);
            set(obj.clientGUIData.pose_z, 'String', pos_z);
        end
        
        %takes in the array of i/o statuses and updates interface
        function updateIOs(obj, ioArray)
            set(obj.clientGUIData.io_vacuum_on, 'String', ioArray(1));
            set(obj.clientGUIData.io_solenoid_on, 'String', ioArray(2));
            set(obj.clientGUIData.io_conveyor_enable, 'String', ioArray(3));
            set(obj.clientGUIData.io_conveyor_direction, 'String', ioArray(4));
        end
        
    end
end