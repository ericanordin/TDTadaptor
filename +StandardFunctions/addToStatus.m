function addToStatus(newOutput, screen)
%addToStatus adds newOutput to screen's statusText and updates statusWindow

import StandardFunctions.padText

numCells = size(screen.statusText);
numCells = numCells(1); %Restricts to number of columns
screen.statusText{numCells+1, 1} = padText(newOutput);
set(screen.statusWindow, 'Data', flip(screen.statusText));

end

