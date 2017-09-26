function c_out = ExtractOrientation(c_in,s_stats,i_stats,c_stats, Im)    
    % This function calculates the orientation for all shape blocks and any
    % inverted blocks which are not in a cluster
    
    c_out = c_in;
    c_tmp = c_in;
    c_tmp(:,1:2) = floor(c_tmp(:,1:2)); % Converting to pixel frame so no float values
    
    %%
    % Size variables
    szi = size(i_stats,1);
    szc = size(c_tmp,1);
    sz = szc - szi;
    szf = size(c_stats.FilledImage,1);
    
    %%
    % Create image with all blocks filled in (blocks with shapes are not solid)
    I = zeros(size(Im,1),size(Im,2),szf);
    
    for n = 1:szf
        x0 = floor(c_stats.BoundingBox(n,2));
        y0 = floor(c_stats.BoundingBox(n,1));
        ix = 0:size(c_stats.FilledImage{n},1)-1;
        iy = 0:size(c_stats.FilledImage{n},2)-1;
        I(x0+ix,y0+iy,n) = c_stats.FilledImage{n}; 
    end
    
    %%
    % Data associate all shape blocks that are inside a cluster 
    i1 = [];
    i2 = [];
    
    % Generate index list according to data association
    for k = 1:sz    % Check faceup blocks
        for j = 1:szf   % Against clusters
            % checks if a center is anywhere inside a cluster based on index state (1 or 0)
            if (I(c_tmp(k,2),c_tmp(k,1),j)) 
                i1(end+1) = j;
                i2(end+1) = k;
            end
        end
    end
    
    % Assign the stats of the cluster to all blocks within
    t_stats = c_stats(i1,:);
    
    % Overwrite the centers data with actual centers (not cluster center)
    t_stats.Centroid(:,1) = c_in(i2,1); 
    t_stats.Centroid(:,2) = c_in(i2,2);
    
    % Concatenate the original shapes list with the clustered shapes list
    s_stats = vertcat(s_stats, t_stats);
    
    % Sort by x position (because that is the order they are saved in the c list)
    [s, s_idx] = sort(s_stats.Centroid(:,1));
    s_stats = s_stats(s_idx,:);
    
    %% 
    %Calculate angles for unclustered inverted blocks then shape blocks
    sz_i = size(i_stats,1);
    sz_s = size(s_stats,1);
    
    angle_i = findAngle(i_stats,sz_i);
    angle_s = findAngle(s_stats,sz_s);
    
    %%
    %Record all angles found back into original c list. Shapes first then inverted
    c_out(1:sz_s,3) = angle_s(:);
    c_out((end - sz_i + 1):end,3) = angle_i(:);  % Set orientation   
end

%%
% Calculates angles for a set of region props data given
function theta = findAngle(stats, sz)
    theta = zeros(1,sz);
    
    for i = 1:sz
        %Sort to find largest Y points
        [sortedY,sortingIndicesY] = sort(stats.Extrema{i}(:,2),'descend');
        
        y2 = stats.Extrema{i}(sortingIndicesY(1),2);
        y1 = stats.Extrema{i}(sortingIndicesY(3),2);
        x2 = stats.Extrema{i}(sortingIndicesY(1),1);
        x1 = stats.Extrema{i}(sortingIndicesY(3),1);
        
        theta(i) = -atan((y2-y1)/(x2-x1));   %Find angle in Radians
    end
    
    theta = theta';
end