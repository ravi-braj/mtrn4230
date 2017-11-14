coveyorObj = webcam(1); % coveyor
%Set Resolutions to the 1600x1200 if available
coveyorObj.Resolution = '1600x1200';

while(1)
    coveyorRGB = snapshot(coveyorObj);
    figure(23);
    imshow(coveyorRGB);
    detectCoveyor(coveyorRGB);
    pause(10);
end