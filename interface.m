classdef interface
    properties (Access = public)
        %user interface
        clientGUI
        clientGUIData
        
        % handles
        h_camConveyor
        h_camTable
        
    end
    methods
        
        %% constructor
        function obj = interface()
            obj.clientGUI = gui();
            obj.clientGUIData = guidata(obj.clientGUI);
            
            % set up plots for the handles - use the 'tag' in the GUI as
            % the handle in the plot constructor and assign to a new handle
            % the handles in the GUI are of axes type which is an
            % encompassing type whereas we need to deal with plot types 
            %(or other) which are child classes of axes
            
            %%dummy data
            x = linspace(1, 20, 100);
            y = sin(x);
            obj.h_camConveyor = plot(obj.clientGUIData.camera_conveyor, x, y);
            obj.h_camTable = plot(obj.clientGUIData.camera_table, x, y);
            
        end
        
    end
end