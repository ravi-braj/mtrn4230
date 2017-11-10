function plotBlocks(source) % Table = 0; Conveyor = 1;
    %ui.clientGUIData.camera_conveyor
    %ui.clientGUIData.camera_table
    

    
    %handletext = text(0,0,'','HorizontalAlignment','left','Color','g');
    %handlequiv = quiver(0,0,0,0,0,'w','linewidth',1.2);
    
    
    %%%% Jay's Test code
    if (source == 1)
        %im = imread('conv2.jpg');
        im = ui.conveyorRGB;
        [c, box, FoundBox] = detectConveyor(im);
    else
        %im = imread('orientation.jpg');
        im = ui.tableRGB;
        c = detectTable(im);
    end
    
    figure(1); imshow(im);  hold on;
    n = size(c,1);
    
    x = c(:,1); y = c(:,2); thi = deg2rad(c(:,3));
    u = cos(thi);
    v = sin(thi);
    
    for i = 1:n
        s{i} = sprintf('[C: %d,S: %d,R: %d]',c(i,4),c(i,5),c(i,6));
    end
    delete(ui.handletext)
    ui.handletext = text(x + 45,y,s,'HorizontalAlignment','left','Color','g');
    %set(handletext,'Position',[(x+45) y],'String',s)
    %plot(x,y,'*w');
    set(ui.handledot,'xdata',x,'ydata',y);
    delete(ui.handlequiv)
    if source
        ui.handlequiv = quiver(x,y,u,v,0.35,'w','linewidth',1.2);
        %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.35,'linewidth',1.2);
    else
        ui.handlequiv = quiver(x,y,u,v,0.1,'w','linewidth',1.2);
        %set(handlequiv,'xdata',x,'ydata','udata',u,'vdata',v,'AutoScaleFactor',0.1,'linewidth',1.2);
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