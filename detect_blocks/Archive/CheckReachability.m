function c_out = CheckReachability(c_in)
    c_out = c_in;
    
    Origin.x = 800; Origin.y = 22;
    ReachableRadius = 823;
    
    Dist = sqrt((c_in(:,1) - Origin.x).^2 + (c_in(:,2) - Origin.y).^2);  
    Dist(Dist <= ReachableRadius) = 1;  % reachable
    Dist(Dist > ReachableRadius) = 0;   % not reachable
    c_out(:,7) = Dist;
end