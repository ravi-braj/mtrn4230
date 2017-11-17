% Test Conveyor vision using live Conveyor feed
% written by Jay Motwani
% Last updated 14 November 2017

coveyorObj = webcam(2); % coveyor
%Set Resolutions to the 1600x1200 if available
coveyorObj.Resolution = '1600x1200';

while(1)
    % Iterate evey 10 seconds for vision block detection to Process
    coveyorRGB = snapshot(coveyorObj);
    figure(25);
    imshow(coveyorRGB);
    detectCoveyor(coveyorRGB);
    pause(10);
end