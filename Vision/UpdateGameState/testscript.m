im = imread('img4.jpg');
[Player1,Player2] = updateGameState(im)

figure(4)
DisplayChoices(Player1);
figure(5)
DisplayChoices(Player2);