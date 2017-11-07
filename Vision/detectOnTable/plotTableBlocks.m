function plotTableBlocks()
    close all; clear all;
    im = imread('orientation.jpg');
    
    c = detectOnTable(im);
    
    figure(1); imshow(im);  hold on;
    n = size(c,1);
    
    for i = 1:n
        x = c(i,1); y = c(i,2); thi = deg2rad(c(i,3));
        u = 15*cos(thi);
        v = 15*sin(thi);
        
        plot(x,y,'*k');
        quiver(x,y,u,v,'k');
    end
end