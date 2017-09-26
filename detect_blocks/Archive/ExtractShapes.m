function [c,b] = ExtractShapes(I)
    % This function runs a thresholding operation for each possible color
    % block. It then extracts block properties (x,y,color) for any face up
    % shapes. It then returns c, an array of block properties and b, a BW
    % image isolating each faceup block.
    
    c = []; b = zeros(size(I,1),size(I,2));
    
    BW_Red = createRedMask(I);
    [c1,n] = ProcessMask(BW_Red, 1);
    if n > 0
        c = vertcat(c,c1);
    end
        
    BW_Orange = createOrangeMask(I);
    [c2,n] = ProcessMask(BW_Orange, 2);
    if n > 0
        c = vertcat(c,c2);
    end
    
    BW_Yellow = createYellowMask(I);
    [c3,n] = ProcessMask(BW_Yellow, 3);
    if n > 0
        c = vertcat(c,c3);
    end
    
    BW_Green = createGreenMask(I);
    [c4,n] = ProcessMask(BW_Green, 4);
    if n > 0
        c = vertcat(c,c4);
    end
    
    BW_Blue = createBlueMask(I);
    [c5,n] = ProcessMask(BW_Blue, 5);
    if n > 0
        c = vertcat(c,c5);
    end
        
    BW_Purple = createPurpleMask(I);
    [c6,n] = ProcessMask(BW_Purple, 6);
    if n > 0
        c = vertcat(c,c6);
    end 
    
    b = BW_Red | BW_Orange | BW_Yellow | BW_Green | BW_Blue | BW_Purple;
    b(1:250,:) = 0;
end

function [c_i,n] = ProcessMask(mask, colorID)
    % This extracts and sets block properties c_i from a single given masked 
    % colour of image. It also returns an isolated mask b_i for each faceup 
    % block.

    mask(1:250,:) = 0; % Crop top of image
    stats = regionprops('table',mask,'Centroid','Area');
    IdxList = find(stats.Area > 400);    % Must be big enough to be a shape
    n = numel(IdxList);
    
    if (n > 0)
        c_i = zeros(numel(IdxList),7);    % Create empty blocks array
        c_i(:,1:2) = stats.Centroid(IdxList,:);   % Fill centers
        c_i(:,4) = colorID;   % Set color
        c_i(:,6) = 1; % Face up
    else
        c_i = [];
    end
end