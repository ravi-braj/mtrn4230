function [centroid, orientation] = box(scan)
    scan = imread('img1.jpg');
    [bw, rgb] = BoxConveyorMask(scan);
    %deleting values that are not around the conveyor
    bw(707:1200,:) = 0;
    bw(:,1:577) = 0;
    bw(:,1162:1600) = 0;

    bw = bwareaopen(bw,30000); %make this value smaller if the box is disappears
    bw = imfill(bw,'holes');
    info = regionprops(bw, 'all');
    centroid = cat(1,info.Centroid)
    orientation = cat(1,info.Orientation)
    imshow(bw);
    hold on;
    plot(centroid(:,1),centroid(:,2),'g+')
end
