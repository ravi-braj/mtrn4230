function c = detectBlocks(im,source)
    
    % Load our neural nets
    load('convnetShape.mat'); % For shapes
    load('convnetColour.mat'); % For colours
    
    % Generate block mask
    Block_BW = createBlockMask(im);
    
%     figure(1); 
%     subplot(1,3,1);
%     imshow(Block_BW);

    if (source)
        % Table
        se = strel('cube',4);
        Block_BW = imerode(Block_BW, se);
        se = strel('cube',6);
        Block_BW = imdilate(Block_BW, se);
    else
        % Conveyor
        se = strel('cube',2);
        Block_BW = imerode(Block_BW, se);
        se = strel('cube',4);
        Block_BW = imdilate(Block_BW, se);
    end
    
%     subplot(1,3,2);
%     imshow(Block_BW);
    
    %Insert Filled Image and create BlockMask
    bw_stats = regionprops('table',Block_BW,'Area','BoundingBox','FilledImage');
    idx = find(bw_stats.Area > 1000 & bw_stats.Area < 3500);
    
    BlockMask = false(size(Block_BW));
    
    for j = 1:size(idx)
        col = floor(bw_stats.BoundingBox(idx(j),1));
        row = floor(bw_stats.BoundingBox(idx(j),2));
        sz = size(bw_stats.FilledImage{idx(j)});
        if (col(1) == 0)
            col = col + 1;
        end
        
        if (row(1) == 0)
            row = row + 1;
        end
        
        BlockMask(row:(row+sz(1)-1),col:(col+sz(2)-1)) = bw_stats.FilledImage{idx(j)};
    end
    
%     subplot(1,3,3);
%     imshow(BlockMask);

    im = imadjust(im, [0, 0, 0; 0.50, 0.48, 0.47], []);
    
    stats = regionprops('table',BlockMask,'Centroid','Area','PixelList');
    inds = find(stats.Area > 1000 & stats.Area < 3600);
    n = size(inds,1);
    c = zeros(n,6);
    
    for k = 1:n
        i = inds(k);
        % Extract block center
        c(k,1) = stats.Centroid(i,1);
        c(k,2) = stats.Centroid(i,2);

        [~, i1] = max(stats.PixelList{i}(:,1));
        [~, i2] = min(stats.PixelList{i}(:,2));
        
        x1_ = stats.PixelList{i}(i1,1) - stats.PixelList{i}(i2,1);
        y1_ = stats.PixelList{i}(i1,2) - stats.PixelList{i}(i2,2);
        
%         hold on;
%         plot(stats.PixelList{i}(i1,1),stats.PixelList{i}(i1,2),'*b');
%         plot(stats.PixelList{i}(i2,1),stats.PixelList{i}(i2,2),'*m');
        
        c(k,3) = rad2deg((atan2(y1_,x1_)));
        
        % Extract a player1 grid slot
        rgbBlock1 = ExtractBlockIm(im, c(k,1), c(k,2), c(k,3), 50);
        
%         figure(2);
%         imshow(rgbBlock1);

        % Classify each the grid slot
        [colour, shape] = ClassifyBlock(rgbBlock1, ...
            convnetColour, convnetShape);

        % Update Board
        c(k,4) = colour;
        c(k,5) = shape;
    end
end

function imExtracted = ExtractBlockIm(im, x, y, angle, sideLength)

    % Initial crop to bounding box of rotated square
    xmin = x - sideLength;
    ymin = y + sideLength;
    xmax = x + sideLength;
    ymax = y - sideLength;
    rect = [xmin, ymax, abs(xmax-xmin), abs(xmax-xmin)];
    imExtracted = imcrop(im, rect);

    % Rotate image by angle
    imExtracted = imrotate(imExtracted, angle, 'crop');

    % Crop again to square dimensions
    sz = [size(imExtracted, 1), size(imExtracted, 2)];
    xCrop = (sz(2) - sideLength) / 2;
    yCrop = (sz(1) - sideLength) / 2;

    rect2 = [xCrop, yCrop, (sideLength-1), (sideLength-1)];
    imExtracted = imcrop(imExtracted, rect2);
end
