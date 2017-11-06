function [json, blocks] = Pattern_Generator (seed, nblocks, allocate_row, t_deck)
% [json, blocks] = Pattern_Generator
% [json, blocks] = Pattern_Generator (seed)
% [json, blocks] = Pattern_Generator (seed, num_blocks)
% [json, blocks] = Pattern_Generator (seed, num_blocks, row)
% [json, blocks] = Pattern_Generator (seed, num_blocks, row, deck)
%
% Seed is the random number generator seed. Default = 42.
% num_blocks is the number of block to be allocated. Default = random.
% row is the direction to allocate, 0 to allocate column, 1 for row. Default = random. 
% Deck is an array of Block that is in the deck for colour and shape. 
% Deck need to have more block then requested block. Default = random

close all;
dbstop if error;
%%  Init
    ncol = 9;
    nrow = 9;
    nblock_max = 6;
    % Get random number generator seed
    if nargin < 1
        seed = 42;
    end
    rng (seed);
    % Get number of blocks in layer 1
    if nargin < 2
        nblocks = randi ([1, nblock_max]);
    end
    % Determine the direction
    if nargin < 3
        allocate_row = randi ([0 1]);
    end
    
     % Make sure the number of blocks is less or equal to nblock_max
    nblocks = mod (nblocks-1, nblock_max) + 1;   
    
    % Preallocate total number of blocks
    blocks (1 : nblocks) = Block;
    
    % Allocate order of getting block from deck
    if nargin >= 4
        deck_perm = randperm(nblocks);
        t_deck = deck(deck_perm);
    else
        t_deck(1:nblocks) = Block;
        shape_colour = zeros(6,6);
        % Reseed to make layer 1 generation consistant independed of number of layers
        rng (seed);
        % Randomly allocate shape and colour
        for it = 1 : nblocks
            while 1
                t_shape = randi ([1, 6]);
                t_colour = randi ([1, 6]);
                if (shape_colour(t_shape, t_colour) < 3)
                    t_deck(it).shape = t_shape;
                    t_deck(it).colour = t_colour;
                    shape_colour (t_shape, t_colour) = shape_colour(t_shape, t_colour) + 1;
                    break;
                end
            end
        end
    end

    % Preallocate total number of blocks
    blocks (1 : nblocks) = Block;
    
    % Reseed to make layer 1 generation consistant independed of number of layers
    rng (seed); 
    
    % Generate col and row of the block just previous to the starting block
    col_offset = 0;
    row_offset = 0;
    if (allocate_row)
        row_offset = nblocks-1;
    else
        col_offset = nblocks-1;
    end
    start_col = randi ([1, ncol-col_offset])-1;
    start_row = randi ([1, nrow-row_offset])-1;
    
%%  Layer 1
    for it = 1 : nblocks
        if allocate_row
            t_row = start_row + it;
            t_col = start_col + 1;
        else
            t_row = start_row + 1;
            t_col = start_col + it;
        end
        
        if nargin >= 4
            
        else
            
        end
        blocks(it).row = t_row;
        blocks(it).column = t_col;
        blocks(it).shape = t_deck(it).shape;
        blocks(it).colour = t_deck(it).colour;
    end
    json = jsonencode(blocks);
end
