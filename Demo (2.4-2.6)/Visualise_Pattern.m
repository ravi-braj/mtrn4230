function Visualise_Pattern (json)
    blocks = jsondecode(json);
    nblocks = size(blocks);
    ncol = 9;
    nrow = 9;
    fig1 = figure ();
    axe1 = axes (fig1);
    col_row1 = robotics.BinaryOccupancyGrid (ncol, nrow, 1);
    hold (axe1, 'on');
    
    for it = 1 : nblocks
        switch (blocks(it).shape)
            case 'circle'
                shape = 'o';
            case 'square'
                shape = 'square';
            case 'diamond'
                shape = 'diamond';
            case 'cross'
                shape = '+';
            case 'star'
                shape = '*';
            case 'club'
                shape = 'x';
            otherwise
                shape = '.'
        end
        switch (blocks(it).colour)
            case 'red'
                colour = 'red';
            case 'yellow'
                colour = 'yellow';
            case 'blue'
                colour = 'blue';
            case 'green'
                colour = 'green';
            case 'purple'
                colour = 'white';
            case 'orange'
                colour = [1, 0.5, 0];  
            otherwise
                colour = [1, 1, 1];
        end
        col_row1.setOccupancy ([blocks(it).column, blocks(it).row], 1);

        line1 = plot (axe1, blocks(it).column-0.5, blocks(it).row-0.5);
        line1.Marker = shape;
        line1.MarkerSize = 15;
        if strcmp(blocks(it).shape, 'cross') || strcmp(blocks(it).shape, 'club')
            line1.LineWidth = 5;
        end
        line1.Color = colour;
        line1.MarkerFaceColor = colour;
    end
    plt1 = col_row1.show;
    plt1.Parent = axe1;
    uistack(plt1,'bottom');
    axe1.XTick = [1:1:ncol];
    axe1.XGrid = 'on';
    axe1.YTick = [1:1:nrow];
    axe1.YGrid = 'on';
    axe1.XLabel.String = 'col';
    axe1.YLabel.String = 'row';
    title ('Desired Pattern (purple = white)');
end