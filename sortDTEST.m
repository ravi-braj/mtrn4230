im = imread('sortDeckTest.jpg');
% hold on;
% figure(1);
% hold on;
% imshow(im);
pieces = detectTable(im);
%plot(pieces(:,1),1200 - pieces(:,2),'+b');
pieces = pieces(find(pieces(:,1)<=1120),:);
pieces = pieces(find(pieces(:,1)>=488),:);
M = mode(pieces);
checkingColour = M(4);
checkingShape =  M(5);
