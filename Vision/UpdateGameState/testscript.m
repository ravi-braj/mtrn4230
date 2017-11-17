% Calls an instance of updateGameState to test its operation on an input
% RGB image 1200x1600
% written by Daniel Castillo
% Last updated 8 November 2017

im = imread('img4.jpg');
[Player1,Player2] = updateGameState(im)

figure(4)
DisplayChoices(Player1);
figure(5)
DisplayChoices(Player2);