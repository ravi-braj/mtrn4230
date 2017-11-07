function tableState = detectTable(im)
    im(1:225,:,[1, 1, 1]) = 0;
    tableState = detectBlocks(im,1);
end