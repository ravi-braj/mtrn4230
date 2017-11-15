function plotBlocks(source) % Table = 0; Conveyor = 1;
    % Plot Block position, quivers and c matrix on gui.fig
    % written by Jay Motwani and Daniel Castillo
    % Last updated 10 November 2017

    
    global ui;
    c = [];
    
    if (source == 1)
        %im = imread('conv2.jpg');
        im = ui.conveyorRGB;
        if(ui.findNewBlocks)
            [ui.playGame.motionMaker.blocks, box, FoundBox] = detectConveyor(im);
            ui.findNewBlocks = 0;
            c = ui.playGame.motionMaker.blocks;
        end
    elseif (source == 0)
        %im = imread('orientation.jpg');
        if (ui.plotted ~= 1)
            im = ui.tableRGB;
            c = detectTable(im);
            ui.plotted = 1;
        end
    end
    
    
    %figure(1); imshow(im);  hold on;
    if (~isempty(c))
        n = size(c,1);

        x = c(:,1); y = c(:,2); thi = deg2rad(c(:,3));
        u = cos(thi);
        v = sin(thi);


        for i = 1:n
            s{i} = sprintf('[C: %d,S: %d,R: %d]',c(i,4),c(i,5),c(i,6));
        end


        %set(handletext,'Position',[(x+45) y],'String',s)
        %plot(x,y,'*w');


        if (source == 1)
            %delete(ui.hquivconveyor);
            %delete(ui.htextconveyor);
            ui.htextconveyor = text(ui.clientGUIData.camera_conveyor, x + 45,y,s,'HorizontalAlignment','left','Color','g');
            hold(ui.clientGUIData.camera_conveyor,'on');
            ui.hquivconveyor = quiver(ui.clientGUIData.camera_conveyor,x,y,u,v,0.35,'w','linewidth',1.2);
            set(ui.h_plotConveyor,'xdata',x,'ydata',y);
            %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.35,'linewidth',1.2);
            hold(ui.clientGUIData.camera_conveyor,'off');
        elseif (source == 0)
            %delete(ui.hquivtable);
            %delete(ui.htexttable);
            hold(ui.clientGUIData.camera_table,'on');
            ui.htexttable = text(ui.clientGUIData.camera_table, x + 45,y,s,'HorizontalAlignment','left','Color','g');
            ui.hquivtable = quiver(ui.clientGUIData.camera_table,x,y,u,v,0.1,'w','linewidth',1.2);
            hold(ui.clientGUIData.camera_table,'off');
            set(ui.h_plotTable,'xdata',x,'ydata',y);
            %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.1,'linewidth',1.2);
        end
        
    end
    
    %%%%Daniel's Test Code
%     close all; clear all;
%     if (source)
%         im = imread('conv2.jpg');
%         [c, box, FoundBox] = detectConveyor(im);
%     else
%         im = imread('orientation.jpg');
%         c = detectTable(im);
%     end
%     
%     figure(1); imshow(im);  hold on;
%     n = size(c,1);
%     
%     x = c(:,1); y = c(:,2); thi = deg2rad(c(:,3));
%     u = cos(thi);
%     v = sin(thi);
%     
%     for i = 1:n
%         s{i} = sprintf('[C: %d,S: %d,R: %d]',c(i,4),c(i,5),c(i,6));
%     end
%     
%     text(x + 45,y,s,'HorizontalAlignment','left','Color','g');
%     plot(x,y,'*w');
%     
%     if source
%         quiver(x,y,u,v,0.35,'w','linewidth',1.2);
%     else
%         quiver(x,y,u,v,0.1,'w','linewidth',1.2);
%     end
end