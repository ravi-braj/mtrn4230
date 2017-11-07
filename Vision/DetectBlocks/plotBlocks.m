function plotBlocks()
    close all; clear all;
    im = imread('orientation.jpg');
    
    c = detectTable(im)
    %[c, box, FoundBox] = detectConveyor(im)
    
    figure(1); imshow(im);  hold on;
    n = size(c,1);
    
    for i = 1:n
        x = c(i,1); y = c(i,2); thi = deg2rad(c(i,3));
        u = 30*cos(thi);
        v = 30*sin(thi);
        
        plot(x,y,'*w');
        quiver(x,y,u,v,'w','linewidth',1,'MaxHeadSize',50);
        s = sprintf('[C: %d,S: %d,R: %d]',c(i,4),c(i,5),c(i,6));
        text(x + 35,y,s,'HorizontalAlignment','left')
    end
end