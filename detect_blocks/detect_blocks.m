% Your block detection.
function C = detect_blocks(I)
    % You may store your results in matrix as shown below.
    %    X    Y    Theta Colour Shape Upper_surface     1 = Reachable
    %                                             		0 = Not reachable
    % c = [685, 690, 0.1,  1,  1,    1,          1                ;  % First block.
    %      200, 200, 0.2,  1,  2,    1,          0                ]; % Second block.

    % Extract faceup block masks + faceup block parameters (x,y,color,inverted=0) 
    [C,BW] = ExtractShapes(I);
    
    % Perform shape matching and set shape parameter to blocks
    if size(C,1) > 0
        % C (non-inverted only) is currently ordered by colour (1-6 then 0).
        % Before running orientation extraction (uses regionProps extents) the
        % order needs to be by X-Centers (to match shapeStats indexing)
        C = orderByPosition(C);
        C = MatchShapes(C,BW);
    end
    
    % Extract facedown block parameters (x,y,color,shape=0,inverted=1)
    [C,shapeStats,invStats,clustStats] = ExtractInverted(C,I,BW);
    
    %check if c list is currently empty. If it is we add a temporary block:
    if numel(C) == 0
        C = zeros(1, 7);    % add one temp block to avoid errors in ReExtractInverted
        C(1:2) = 100;   % any center initialiser for temp block
    else
        % Set orientation for all blocks currently found based on regionProps extents
        C = ExtractOrientation(C,shapeStats,invStats,clustStats,I);
    end
    
    %Extract inverted blocks within clusters and set their parameters
    C = ReExtractInverted(C, I);
    
    % Set reachability based on centers
    C = CheckReachability(C);
    
    % Change coordinate frame. Specification requires origin at bottom left
    % hand corner. Currently it is at top left hand corner.
    C(:,2) = size(I,1) - C(:,2);
end