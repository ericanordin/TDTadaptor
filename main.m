function main()
%MAIN Runs the show for the ultrasonic recording program.

import Enums.*
import GUIFiles.*
import StandardFunctions.*
import RPvdsExLink.*

% The same LabScreen, RatScreen, and RecordScreen GUI objects are reused 
% until the program is closed so that it can reuse data entered by the 
% user and the PC isn't forced to repeatedly open GUIs.
% LabScreen and RatScreen are created inside RecordScreen.

recordScr = RecordScreen();

while (recordScr.running == 1)
    import StandardFunctions.checkValidName;
    
    %Resets the wav file name to the directory of the most recent rat.
    setFileName(recordScr, recordScr.startingPathway);
    set(recordScr.fileNameEditable, 'String', recordScr.startingPathway);
    checkValidName(recordScr.startingPathway, recordScr.fileNameEditable, recordScr.errorColor);
    
    waitForChange(recordScr);
end

%Program termination
delete(recordScr);
delete(findall(0, 'Type', 'figure'));
%Due to modifications in the 'close' command for figures, they must be
%explicitly deleted instead of closed.
end

