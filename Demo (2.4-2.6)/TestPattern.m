string = Pattern_Generator(100,10,1);
value = jsondecode(string);
StartBoard = zeros(9,9,2);
Board = StartBoard;

for i = 1:length(value)
    row = 10-value(i).row;
    column = value(i).column;
    
    switch (value(i).shape)
            case 'circle'
                shape = 3;
            case 'square'
                shape = 1;
            case 'diamond'
                shape = 2;
            case 'cross'
                shape = 5;
            case 'star'
                shape = 6;
            case 'club'
                shape = 4;
            otherwise
                shape = 0;
    end
        
    switch (value(i).colour)
            case 'red'
                colour = 1;
            case 'yellow'
                colour = 3;
            case 'blue'
                colour = 5;
            case 'green'
                colour = 4;
            case 'purple'
                colour = 6;
            case 'orange'
                colour = 2;  
            otherwise
                colour = 0;
    end
    Board(column,row,:) = [colour,shape];
end

DisplayQwirkleBoard(Board);
Visualise_Pattern(string);