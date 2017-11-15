% Test Conveyor vision using live Conveyor feed
% written by Jay Motwani
% Last updated 14 November 2017

coveyorObj = webcam(2); % coveyor
%Set Resolutions to the 1600x1200 if available
coveyorObj.Resolution = '1600x1200';

while(1)
    coveyorRGB = snapshot(coveyorObj);
    figure(25);
    imshow(coveyorRGB);
    detectCoveyor(coveyorRGB);
    pause(10);
end