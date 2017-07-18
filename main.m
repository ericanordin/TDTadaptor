function main()
%MAIN Runs the show.
    %To do:
    %Import nameType from EntryScreen. If auto, go through LabScreen and
    %RatScreen; if manual, jump to RecordScreen.
    %Save pathway so that they don't have to go through many folders on
    %next manual selection.
    %Import chosenLab from LabScreen to determine naming method.
    %Import ratID, dayID, cohortID from RatScreen to determine naming
    %method.
    %Export chosenLab, ratID, dayID, cohortID to setNameAuto; import
    %filePath.
    %Export startingPathway to setNameManual; import filePath.
    
import Enums.*
import GUIFiles.*

% The same GUI objects are used until the program is closed so that the
% user doesn't have to constantly redo the procedure from opening the
% program.

running = 1;
entryScr = EntryScreen();

%Names for screens not initially created are initialized to
%an empty string so that isobject returns 0 instead of crashing the
%program. The exist function doesn't work on objects.
labScr = '';
ratScr = '';
recordScr = ''; 

%labScr = LabScreen();
%ratScr = RatScreen();
%recordScr = RecordScreen();
disp('Past constructors');

getNameType(entryScr);

%while (running == 1)

if entryScr.nameType == NamingMethod.Auto
    disp('In Auto-if');
    checkExistence = isobject(labScr);
    if checkExistence == 0
        labScr = LabScreen();
    end
    checkExistence = isobject(ratScr);
    if checkExistence == 0
        ratScr = RatScreen();
    end
   %Go through labScr and ratScr steps 
else
    disp('Skipped Auto-if');
end

checkExistence = isobject(recordScr);
if checkExistence == 0
    recordScr = RecordScreen();
end

%end

%To prevent resources from being used unnecessarily, use the exist function
%to determine whether or not to construct a GUI.

end

