function [c_out] = ReExtractInverted(c_in, I) 
    %This function deletes any already captured blocks from the BW image.
    %Whatever remains is assumed to be only inverted blocks
    %Extract all remaining singular blocks and fit a grid to any remaining clusters

    I(1:250,:) = 255; % Crop top of image
    [BW, ~ ] = createBlockMask(I);
    
    %remove all known blocks from image.
    eliminationMask = createEliminationMask(c_in, size(BW));
    BW = BW & eliminationMask;
    
    stats = regionprops('table',BW,'Centroid', 'BoundingBox');
    
    wSingle = stats.BoundingBox(:, 3) > 40 & stats.BoundingBox(:, 4) > 10;
    hSingle = stats.BoundingBox(:, 4) > 40 & stats.BoundingBox(:, 4) > 10;
    wMulti = stats.BoundingBox(:, 3) > 40*2 & stats.BoundingBox(:, 4) > 10;
    hMulti = stats.BoundingBox(:, 4) > 40*2 & stats.BoundingBox(:, 4) > 10;
    
    % extract any standalone inverted blocks (after removing known shapes)
    singles = find(wSingle | hSingle); 
    % extract any remainingly clusters (after removing known shapes)
    clusters = find(wMulti | hMulti);
    %remove any clusters (multis) from the singles set
    singles(ismember(singles, clusters)) = [];

    %%
    %Process singles
    cs = zeros(length(singles), 7); % create new c_matrix for singles
    cs(:, 6) = 2;   % set to inverted
    
    %extract out the single block parameters:
    for i = 1:length(singles)
        s_bounds = stats.BoundingBox(singles(i), :);
        centers = [s_bounds(1) + s_bounds(3)/2, s_bounds(2) + s_bounds(4)/2];
        cs(i, 1:2) = centers;
        
        %assign orientation to be same as closest other block:
        distances = sqrt( (c_in(:, 1) - centers(1)).^2 + (c_in(:, 2) - centers(2)).^2 );
        cs(i, 3) = c_in( distances == min(distances), 3);
    end
    
    %%
    %Process clusters
    cm = zeros(1, 7);   % create new c_matrix for clusters
    
    %extract out the cluster block parameters:
    for i = 1:length(clusters)
        c_bounds = stats.BoundingBox(clusters(i), :);
        centroid = [c_bounds(1) + c_bounds(3)/2, c_bounds(2) + c_bounds(4)/2];
        
        % Calculate expected number of blocks in the cluster
        clusterWidth = round(c_bounds(3) / 50);
        clusterHeight = round(c_bounds(4) / 50);
        numClusters = clusterWidth * clusterHeight;
        
        % Assign centers to blocks inside the cluster in a grid format
        x = linspace(c_bounds(1) + 20, c_bounds(1) + c_bounds(3) - 20, clusterWidth)';
        y = linspace(c_bounds(2) + 20, c_bounds(2) + c_bounds(4) - 20, clusterHeight)';
        
        x = repmat(x, 1, clusterHeight);
        x = reshape(x, [numel(x), 1]);
        y = repmat(y, clusterWidth, 1);
        
        % Save blocks generated from this cluster iteration into cTmp
        cTmp = zeros(numClusters, 7);
        distances = sqrt( (c_in(:, 1) - centroid(1)).^2 + (c_in(:, 2) - centroid(2)).^2 );
        cTmp(:, 3) = c_in( distances == min(distances), 3);
        cTmp(:, 1:2) = [x y];
        
        % Concatenate any blocks generated from this cluster iteration onto cm
        cm = [cm; cTmp];
    end
    
    cm = cm(2:end, :);  %eliminate first row (which was added initially to avoid an error)
    cm(:, 6) = 2;   % set all blocks added to inverted

    %%
    % concatenate the original clist, singles clist and clusters clist
    c_out = [c_in; cs; cm];
end

%%
function mask = createEliminationMask(c_in, sz)

    mask = true(sz);
    singleBlock = false(50, 50);    %approximate size of a block
    
    % Generate mask for all known blocks
    for i = 1:size(c_in, 1)
        sbRotated = imrotate(singleBlock, rad2deg(c_in(i, 3)));
        
        x = round(c_in(i, 2));
        y = round(c_in(i, 1));
        w = round(size(sbRotated, 1) / 2);
        
        % Deal with case where sbRotated has odd number of elements:
        if mod(size(sbRotated), 2) == 1
            mask( (x - w):(x + w - 2) , (y - w):(y + w - 2) ) = sbRotated;
        else 
            mask( (x - w):(x + w - 1) , (y - w):(y + w - 1) ) = sbRotated;
        end
    end
end
