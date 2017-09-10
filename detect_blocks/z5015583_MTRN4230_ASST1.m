% An example of how your function will be called, and what it should
% output.
% image_file_path is the absolute path to the image that you should
% process. This should be used to read in the file.
% image_file_name is just the name of the image. This should be written to
% the output file.
% output_file_path is the absolute path to the file where you should output
% the name of the file as well as the blocks that you have detected.
% program_folder is the folder that your function is running in.
function z5015583_MTRN4230_ASST1(image_file_path, image_file_name, ...
    output_file_path, program_folder)
    
    im = imread(image_file_path);
    blocks = detect_blocks(im);
    write_output_file(blocks, image_file_name, output_file_path);
end

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

function write_output_file(blocks, image_file_name, output_file_path)

    fid = fopen(output_file_path, 'w');

    fprintf(fid, 'image_file_name:\n');
    fprintf(fid, '%s\n', image_file_name);
    fprintf(fid, 'rectangles:\n');
    fprintf(fid, ...
            [repmat('%f ', 1, size(blocks, 2)), '\n'], blocks');

    % Please ensure that you close any files that you open. If you fail to do
    % so, there may be a noticeable decrease in the speed of your processing.
    fclose(fid);
end