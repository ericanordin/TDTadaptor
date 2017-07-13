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
entryScr = EntryScreen();
labScr = LabScreen();
ratScr = RatScreen();
recordScr = RecordScreen();



end

