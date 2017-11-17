function [Output] = isEmptyBoundary(X,Y,Board)
%%Check if the X,Y position on the board
%%is either Empty/Boundary = 1 or Full = 0;
% Author: Ken Le
% Last updated 15 November 2017

Empty = 1;
Full = 0;

Output = Empty;
    if (X>=1 && X<=9) && (Y>=1 && Y<=9)
        if Board(X,Y,1) ~= 0
            Output = Full;
        end
    end
end