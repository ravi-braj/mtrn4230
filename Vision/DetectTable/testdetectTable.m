% Test Table vision using live Table feed
% written by Jay Motwani
% Last updated 14 November 2017

tableObj = webcam(1); % table
%Set Resolutions to the 1600x1200 if available
tableObj.Resolution = '1600x1200';

while(1)
    tableRGB = snapshot(tableObj);
    figure(23);
    imshow(tableRGB);
    detectTable(tableRGB);
    pause(10);
end