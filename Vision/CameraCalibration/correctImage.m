function output = correctImage(inputImage, positionID)
% Calibrate webcam images based on saved calibration profile
% 
% output = CORRECTIMAGE(inputImage, positionID) reads an RGB image
% 'inputImage' from either the table or conveyor and returns an RGB
% image 'output'
% positionID = 'table' or 'conveyor' 

if  strcmp('table',positionID)
    tempParam = load('cameraParamsTable.mat');
    params = tempParam.cameraParamsTable;
elseif strcmp('conveyor',positionID)
    tempParam = load('conveyorParams.mat');
    params = tempParam.conveyorParams;
else
    disp('positionID outside of range.');
end
tic;
output = undistortImage(inputImage,params, 'Outputview', 'same');
toc;
figure(1);
subplot(1,2,1);
imshow(inputImage);
title('Original');
subplot(1,2,2);
imshow(output);
title('Corrected');

end
