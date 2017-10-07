% wrapper class for the Qwirkle GUI data
% designed to stop globals being passed around everywhere. Instead just
% pass an 'Qwirkle' object to access all your handles.
% written by Jay Motwani
% last edited 26 September 2017

%purpose, description, inputs, outputs, auther, date modified

classdef qwirkle < handle
    properties (Access = public)
                    %handles
            h_plotBoard;
            h_plotBox;
            
            loadBox;
        
    end
    methods
        % Constructor
        function obj = qwirkle()
            %INTERFACE constructs an interface 
            %sets default values for the gui. Starts gui and attempts to
            %connect client.
            
            
            %handles
            h_plotBoard
            h_plotBox
            
            loadBox = 0;
        end
        
    end
        
end