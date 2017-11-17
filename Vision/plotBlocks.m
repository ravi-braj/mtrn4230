function plotBlocks(source) % Table = 0; Conveyor = 1;
    % Plot Block position, quivers and c matrix on gui.fig
    % written by Jay Motwani and Daniel Castillo
    % Last updated 10 November 2017
    
    global ui;
    c = [];
    
    % Conveyor Image Processing
    if (source == 1) 
        %im = imread('conv2.jpg');
        im = ui.conveyorRGB;
        if(ui.findNewBlocks)
            [ui.playGame.motionMaker.blocks, box, FoundBox] = detectConveyor(im);
            ui.findNewBlocks = 0;
            c = ui.playGame.motionMaker.blocks;
        end
    elseif (source == 0) % Table Image Processig
        %im = imread('orientation.jpg');
        if (ui.plotted ~= 1)
            im = ui.tableRGB;
            c = detectTable(im);
            ui.plotted = 1;
        end
    end
    
    
    % Produce string and angle data to display properties of blocks using
    % text and quivers
    if (~isempty(c))
        n = size(c,1);

        x = c(:,1); y = c(:,2); thi = deg2rad(c(:,3));
        u = cos(thi);
        v = sin(thi);

        for i = 1:n
            s{i} = sprintf('[C: %d,S: %d,R: %d]',c(i,4),c(i,5),c(i,6));
        end

        % Plotting for Conveyor on gui
        if (source == 1)
            %delete(ui.hquivconveyor);
            %delete(ui.htextconveyor);
            
            % Blocks Text Plotting for Conveyor
            ui.htextconveyor = text(ui.clientGUIData.camera_conveyor, x + 45,y,s,'HorizontalAlignment','left','Color','g');
            hold(ui.clientGUIData.camera_conveyor,'on');
            
            % Blocks Quiver Plotting for Conveyor
            ui.hquivconveyor = quiver(ui.clientGUIData.camera_conveyor,x,y,u,v,0.35,'w','linewidth',1.2);
            set(ui.h_plotConveyor,'xdata',x,'ydata',y);
            %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.35,'linewidth',1.2);
            hold(ui.clientGUIData.camera_conveyor,'off');
        elseif (source == 0) % Plotting for Table on gui
            %delete(ui.hquivtable);
            %delete(ui.htexttable);
            hold(ui.clientGUIData.camera_table,'on');
            
            % Blocks Text Plotting for Table
            ui.htexttable = text(ui.clientGUIData.camera_table, x + 45,y,s,'HorizontalAlignment','left','Color','g');
            
            % Blocks Quiver Plotting for Table
            ui.hquivtable = quiver(ui.clientGUIData.camera_table,x,y,u,v,0.1,'w','linewidth',1.2);
            hold(ui.clientGUIData.camera_table,'off');
            set(ui.h_plotTable,'xdata',x,'ydata',y);
            %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.1,'linewidth',1.2);
        end
        
    end
    
end