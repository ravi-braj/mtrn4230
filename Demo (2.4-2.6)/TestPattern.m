%%This function is used to demonstrate part 2.4-2.6 of Asst 4
%%Initilizing all the variables
StartBoard = zeros(9,9,2);
Board = StartBoard;

%%Using a counter the number of moves made
counter = 1;
%%Using a toggle to alternate the vertical/horizontal placement of
%%generated pieces from the pattern Generator
toggle = 1;
while(1)
    %%Alternate the toggle after each loop
    toggle = 1-toggle;
    %%Generate JSON FILE
    string = Pattern_Generator(randi([1 100],1),randi([6],1),toggle);
    %2.5 - READING JSON AND CONVERTING TO BOARD DISPLAY
    value = jsondecode(string);
    %%Checking each block in the decoded JSON FILE
    for i = 1:length(value)
        %Store Positions
        row(i) = 10-value(i).row;
        column(i) = value(i).column;
        %Store Shape
        switch (value(i).shape)
                case 'circle'
                    shape(i) = 3;
                case 'square'
                    shape(i) = 1;
                case 'diamond'
                    shape(i) = 2;
                case 'cross'
                    shape(i) = 5;
                case 'star'
                    shape(i) = 6;
                case 'club'
                    shape(i) = 4;
                otherwise
                    shape(i) = 0;
        end
        %Store Colour
        switch (value(i).colour)
                case 'red'
                    colour(i) = 1;
                case 'yellow'
                    colour(i) = 3;
                case 'blue'
                    colour(i) = 5;
                case 'green'
                    colour(i) = 4;
                case 'purple'
                    colour(i) = 6;
                case 'orange'
                    colour(i) = 2;  
                otherwise
                    colour(i) = 0;
        end
        %Check if the move is valid using the awesome QWIRKLEAI code
        Valid = isMoveValid([colour(i),shape(i)],column(i),row(i),Board);
        if (Valid == true || counter == 1)
            Board(column(i),row(i),:) = [colour(i),shape(i)];
        else
            disp('MOVE IS INVALID');
        end
    end
    %DISPLAYBOARD
    DisplayQwirkleBoard(Board);
    %GIVEN SAMPLE CODE DISPLAY TO VERIFY
    Visualise_Pattern(string);
    %%Click to continue with the loop
    pause();
    disp('Choice Number');
    disp(counter);
    counter = counter +1;
end