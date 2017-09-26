%% Perform shape matching against labels
function c_out = MatchShapes(c_in,BW)
    c_out = c_in;
    
    load('Labels1.mat');
    load('T_Features.mat');
    load('T_Points.mat');
    %load('T_BW.mat');
    
    sz_T = size(T_Features,2);
    stats = regionprops('table',BW,'Area','BoundingBox');
    IdxList = find(stats.Area > 400);    % Must be big enough to be a shape
    shapeBounds = stats.BoundingBox(IdxList,:);
    
    x1 = shapeBounds(:,1)' - 10; x2 = x1 + shapeBounds(:,3)' + 10;
    y1 = shapeBounds(:,2)' - 10; y2 = y1 + shapeBounds(:,4)' + 10;
    
    %% Extract features and feature points from shape mask
    I_Points = detectSURFFeatures(BW);
    I_Features = extractFeatures(BW,I_Points);
    
    sz = size(c_in,1);
    vote = zeros(6,sz);
    
    %% iterate through training images and perform matching
    for k = 1:sz_T
        matchedFeatures = matchFeatures(I_Features, T_Features{k});
        matchedPoints_I = I_Points.Location(matchedFeatures(:, 1), :);
        matchedPoints_T = T_Points{k}(matchedFeatures(:,2),:);
        
        X = matchedPoints_I(:,1); Y = matchedPoints_I(:,2);
        for i = 1:size(x1,2)  % iterate through shapeBounds
            matchIdx{i} = find((X > x1(i)) & (X < x2(i)) & (Y > y1(i)) & (Y < y2(i)));
        end
   
        for j = 1:sz    % Iterate through all blocks
            vote(:,j) = vote(:,j) + castVote(matchedPoints_T(matchIdx{j},:),Labels(k,:));
        end
        
        % plot result
        %showMatchedFeatures(BW, T_BW{k}, matchedPoints_I, ...
        %    matchedPoints_T, 'montage');
    end
       
    %% pick a solution based on matched votes
    [tmp,ID] = max(vote);
    c_out(:,5) = ID';   % Set shape to highest vote
end
%% Scoring function to count number of matches to a label type
function vote = castVote(points, labels)
    vote = zeros(6,1);
    X = points(:,1); Y = points(:,2);
    
    %% Square(1) Label Check
    if (~isempty(labels.square{1}))
        vote(1) = checkShapeLabel(X,Y,labels.square{1});
    end
    %% Diamond(2) Label Check
    if (~isempty(labels.diamond{1}))
        vote(2) = checkShapeLabel(X,Y,labels.diamond{1});
    end
    %% Circle(3) Label Check
    if (~isempty(labels.circle{1}))
        vote(3) = checkShapeLabel(X,Y,labels.circle{1});
    end
    %% Club(4) Label Check
    if (~isempty(labels.club{1}))
        vote(4) = checkShapeLabel(X,Y,labels.club{1});
    end
    %% Cross(5) Label Check
    if (~isempty(labels.cross{1}))
        vote(5) = checkShapeLabel(X,Y,labels.cross{1});
    end
    %% Star(6) Label Check
    if (~isempty(labels.star{1}))
        vote(6) = checkShapeLabel(X,Y,labels.star{1});
    end
end

%% Checks how many of P(X,Y) are inside the region of a given shape label
function score = checkShapeLabel(X,Y,Shape)
    score = 0;
    
    x1 = Shape(:,1)' - 10; x2 = x1 + Shape(:,3)' + 10;
    y1 = Shape(:,2)' - 10; y2 = y1 + Shape(:,4)' + 10;

    for i = 1:size(x1)
        idxList = find((X > x1(i)) & (X < x2(i)) & (Y > y1(i)) & (Y < y2(i)));
        score = score + numel(idxList);
    end
end