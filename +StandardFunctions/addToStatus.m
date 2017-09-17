function addToStatus(newOutput, screen)
%addToStatus adds newOutput to screen's statusText and updates statusWindow
%   Detailed explanation goes here

import StandardFunctions.padText

numCells = size(screen.statusText);
%disp(numCells);
numCells = numCells(1); %Restricts to number of columns
screen.statusText{numCells+1, 1} = padText(newOutput);
set(screen.statusWindow, 'Data', flip(screen.statusText));

end

