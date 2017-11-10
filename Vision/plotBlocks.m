function plotBlocks()
    close all; clear all;
    
    source = 1; % Table = 0; Conveyor = 1;
    
    if (source)
        im = imread('conv2.jpg');
        [c, box, FoundBox] = detectConveyor(im);
    else
        im = imread('orientation.jpg');
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
    
    text(x + 45,y,s,'HorizontalAlignment','left','Color','g');
    plot(x,y,'*w');
    
    if source
        quiver(x,y,u,v,0.35,'w','linewidth',1.2);
    else
        quiver(x,y,u,v,0.1,'w','linewidth',1.2);
    end
end