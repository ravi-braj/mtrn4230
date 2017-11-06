classdef Block
    properties
        row = 0, column = 0, shape='inverted', colour='inverted'
    end

    methods
        function val = shape_value (this)
            % Return the corresponding value of shape string
            val = this.shape_to_val(this.shape);
        end

        function val = colour_value (this)
            % Return the corresponding value of colour string
            val = this.colour_to_val(this.colour);
        end

        function this = set.colour (this, val)
            if (ischar(val))
                val = this.colour_to_val (val);
            end
            if val <= 0
                this.colour = 'inverted';
                return;
            end
            val = mod (val-1,6)+1;
            switch (val)
                case 1
                    this.colour = 'red';
                case 2
                    this.colour = 'orange';
                case 3
                    this.colour = 'yellow';
                case 4 
                    this.colour = 'green';
                case 5
                    this.colour = 'blue';
                case 6
                    this.colour = 'purple';
            end
        end

        function this = set.shape (this, val)
            if (ischar(val))
                val = this.shape_to_val (val);
            end
            if val <= 0
                this.shape = 'inverted';
                return;
            end
            val = mod (val-1, 6)+1;
            switch (val)
                case 1
                    this.shape = 'square';
                case 2
                    this.shape = 'diamond';
                case 3
                    this.shape = 'circle';
                case 4
                    this.shape = 'club';
                case 5
                    this.shape = 'cross';
                case 6
                    this.shape = 'star';
            end
        end

        function this = set.row (this, val)
            this.row = mod (val-1,9)+1;
        end

        function this = set.column (this, val)
            this.column = mod(val-1,9)+1;
        end
    end
    
    methods (Static, Access=private)
        function val = shape_to_val (shape)
            switch (shape)
                case 'square'
                    val = 1;
                case 'diamond'
                    val = 2;
                case 'circle'
                    val = 3;
                case 'club'
                    val = 4;
                case 'cross'
                    val = 5;
                case 'star'
                    val = 6;
                otherwise
                    val = 0;
            end
        end
        
        function val = colour_to_val (colour)
            switch (colour)
                case 'red'
                    val = 1;
                case 'orange'
                    val = 2;
                case 'yellow'
                    val = 3;
                case 'green'
                    val = 4';
                case 'blue'
                    val = 5;
                case 'purple'
                    val = 6;
                otherwise
                    val = 0;
            end
        end 
    end
end