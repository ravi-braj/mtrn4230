function tableState = detectTable(im)
    im(1:225,:,[1, 1, 1]) = 0;
    tableState = detectBlocks(im,1);
    
    Origin.x = 800; Origin.y = 22;
    ReachableRadius = 832;
    
    Dist = sqrt((tableState(:,1) - Origin.x).^2 + (tableState(:,2) - Origin.y).^2);
    Dist(Dist <= ReachableRadius) = 1;  % reachable
    Dist(Dist > ReachableRadius) = 0;   % not reachable
    tableState(:,6) = Dist;
end