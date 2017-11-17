function tableState = detectTable(im)
    % This function takes in a 1200 x 1600 image and runs the preliminary
    % masking operations for the table camera before passing the function 
    % to lower level block classification. The classification is run to 
    % identify all blocks on the table. The result is returned in a matrix 
    % with columns x,y,orient,colour,shape,reachability by number of blocks.
    % written by Daniel Castillo
    % Last updated 12 November 2017
    
    %%
    %Mask out top section (robot resting region off table)
    im(1:225,:,[1, 1, 1]) = 0;
    
    %Call lower level block classifier
    tableState = detectBlocks(im,1);
    
    %% 
    %Detect reachability of all blocks
    Origin.x = 800; Origin.y = 22;
    ReachableRadius = 832;
    
    Dist = sqrt((tableState(:,1) - Origin.x).^2 + (tableState(:,2) - Origin.y).^2);
    Dist(Dist <= ReachableRadius) = 1;  % reachable
    Dist(Dist > ReachableRadius) = 0;   % not reachable
    tableState(:,6) = Dist;
end