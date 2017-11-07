function [x,y,theta,valid] = CorrectBlock(im)
    valid = true;
    
    %im = imread('orientation.jpg');
    
    % Generate block mask
    Block_BW = createBlockMask(im);
    Block_BW(:,1:1085) = 0;
    Block_BW(:,1200:end) = 0;
    Block_BW(1:640,:) = 0;
    Block_BW(760:end,:) = 0;
    %figure(1); imshow(Block_BW);
    
    %Insert Filled Image and create BlockMask
    bw_stats = regionprops('table',Block_BW,'Area','BoundingBox','FilledImage');
    [~, idx] = max(bw_stats.Area);
    
    BlockMask = false(size(Block_BW));
    
    if (bw_stats.Area(idx) > 1500) && (bw_stats.Area(idx) < 3000)
        
        col = floor(bw_stats.BoundingBox(idx,1));
        row = floor(bw_stats.BoundingBox(idx,2));
        sz = size(bw_stats.FilledImage{idx});
        if (col(1) == 0)
            col = col + 1;
        end
        
        if (row(1) == 0)
            row = row + 1;
        end
        
        BlockMask(row:(row+sz(1)-1),col:(col+sz(2)-1)) = bw_stats.FilledImage{idx};
    end
    
    %figure(2); imshow(BlockMask);
    
    if (any(BlockMask(:)))
        
        stats = regionprops('table',BlockMask,'Centroid','Area','PixelList');
        [~, Idx] = max(stats.Area);

        % Extract block center
        x = stats.Centroid(Idx, 1);
        y = stats.Centroid(Idx, 2);

        % Extract block orientation
        [~, i1] = max(stats.PixelList{1}(:,1));
        [~, i2] = min(stats.PixelList{1}(:,2));
        x_ = abs(stats.PixelList{1}(i1,1) - stats.PixelList{1}(i2,1));
        y_ = abs(stats.PixelList{1}(i1,2) - stats.PixelList{1}(i2,2));
        theta = rad2deg(atan2(y_,x_));
    else
        x = []; y = []; theta = []; valid = false;
    end
end