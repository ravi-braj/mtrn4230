    %%Display Game Interface
    %Positon Vector [bottomleftcornerX bottomleftcornerY width height]
    BoardVector = [0.21 ,0.1, 0.585, 0.585];
    P1Vector = [0.1, 0.1, 0.1, 0.6];
    P2Vector = [0.8, 0.1, 0.1, 0.6];
    
    figure(1);hold on;
    subplot('Position',BoardVector)
    DisplayQwirkleBoard(Board);
    titletext = sprintf('Qwirkle Game!!\n(Press Q to quit)\nLeftClick to Move\nRightClick to SWAP');
    title(titletext);
    
    subplot('Position',P1Vector)
    DisplayChoices(P1GamePieces);
    titletext = sprintf('Player 1 has %d Points\n %s',P1TotalScore,P1Action);
    title(titletext);
    
    subplot('Position',P2Vector);
    DisplayChoices(P2GamePieces);
    titletext = sprintf('Player 2 has %d Points\n %s',P2TotalScore,P2Action);
    title(titletext);
    pause(0.000000001);