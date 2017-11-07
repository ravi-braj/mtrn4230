    global ui;
    
    %%Display Game Interface
    %Positon Vector [bottomleftcornerX bottomleftcornerY width height]
    BoardVector = [0.21 ,0.1, 0.585, 0.585];
    P1Vector = [0.1, 0.1, 0.1, 0.6];
    P2Vector = [0.8, 0.1, 0.1, 0.6];
    
    figure(10);hold on;
    subplot('Position',BoardVector)
    DisplayQwirkleBoard(ui.Board);
    titletext = sprintf('Qwirkle Game!!\n(Press Q to quit)\nLeftClick to Move\nRightClick to SWAP');
    title(titletext);
    
    subplot('Position',P1Vector)
    DisplayChoices(ui.P1GamePieces);
    titletext = sprintf('Player 1 has %d Points\n %s',ui.P1TotalScore,ui.P1Action);
    title(titletext);
    
    subplot('Position',P2Vector);
    DisplayChoices(ui.P2GamePieces);
    titletext = sprintf('Player 2 has %d Points\n %s',ui.P2TotalScore,ui.P2Action);
    title(titletext);
    pause(0.000000001);