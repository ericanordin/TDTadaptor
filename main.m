function main()
%MAIN Runs the show for the ultrasonic recording program.

%Make any cancellation step in Auto-name reset to original lab name
%Phase out generalHideWindow
%Fix glitch with repeated lab attempts and premature exit (see
%LabScreen->getLabName)

import Enums.*
import GUIFiles.*
import StandardFunctions.*
import RPvdsExLink.*

% The same LabScreen, RatScreen, and RecordScreen GUI objects are used 
% until the program is closed so that the user doesn't have to 
% constantly redo the procedure from opening the program.

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
end

