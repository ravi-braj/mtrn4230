function [c_out,shapeStats,invertedStats,clusterStats] = ExtractInverted(c_in,I,shape_mask)
    c_out = c_in;
    
    BW_blocks = createBlockMask(I);

    BW_blocks(shape_mask) = 0;
        
    BW_blocks(1:250,:) = 0; % Crop top of image
    
    stats = regionprops('table',BW_blocks,'Centroid','Area','Extrema','FilledImage','BoundingBox');
    
    IdxList = find(stats.Area > 2200 & stats.Area < 3000);    % Must be big enough to be a block but not too big to be multiple blocks
    invertedStats = stats(IdxList,:);
    
    % Either a shape by itself, or a large cluster of blocks
    IdxList_S = find(stats.Area > 1000 & stats.Area < 2200);
    shapeStats = stats(IdxList_S,:);
    
    IdxList_C = find(stats.Area>3000);
    clusterStats = stats(IdxList_C,:);
    
    n = numel(IdxList);
    
    if (n > 0)
        c_tmp = zeros(numel(IdxList),7);    % Create empty blocks array
        c_tmp(:,1:2) = stats.Centroid(IdxList,:);   % Fill centers
        c_tmp(:,4) = 0;   % Set color as inverted
        c_tmp(:,5) = 0;   % Set shape as inverted
        c_tmp(:,6) = 2; % Face up
        c_out = vertcat(c_in,c_tmp);
    end
end