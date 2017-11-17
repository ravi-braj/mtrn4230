%%The Game_Interface is the front end of the game
%%Shows how the players can move and swap pieces with the board

% Author: Ken Le
% Last updated 15 November 2017

global ui; %%Variable used to store all the states of the game

%%Display Game Interface
%Positon Vector [bottomleftcornerX bottomleftcornerY width height]
%%Moving The plots to the correct position
BoardVector = [0.21 ,0.1, 0.585, 0.585];
P1Vector = [0.1, 0.1, 0.1, 0.6];
P2Vector = [0.8, 0.1, 0.1, 0.6];

%%Board is displayed in the middle
figure(10);hold on;
subplot('Position',BoardVector)
DisplayQwirkleBoard(ui.Board);
titletext = sprintf('Qwirkle Game!!\n');
title(titletext);

%%PLAYER 1 pieces is displayed
subplot('Position',P1Vector)
DisplayChoices(ui.P1GamePieces);
titletext = sprintf('Player 1 has %d Points\n %s',ui.P1TotalScore,ui.P1Action);
title(titletext);

%%PLAYER 2 pieces is displayed
subplot('Position',P2Vector);
DisplayChoices(ui.P2GamePieces);
titletext = sprintf('Player 2 has %d Points\n %s',ui.P2TotalScore,ui.P2Action);
title(titletext);
pause(0.001);