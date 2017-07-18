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
disp('Past constructors');
a = get(recordScr); 
%get returns the handle of the object with the properties, but the
%properties are all empty.
%Currently, I believe that the problem might be that the values in the
%constructor are not being copied into the properties. When it is made a
%subclass of handle, which was a solution for a forum poster, it does not
%solve the problem.
v = a.startingPathway;
%v = get(recordScr, 'startingPathway');
%v = get.startingPathway(recordScr);
disp(v);
%disp(get.bitDepth(recordScr));
%close(recordScr.guiF);
%labFig = get.guiF(labScr);
%set(entryScr.guiF, 'visible', 'off');
%ready = input('Type 1 if ready');
%if ready == 1
%    disp('Got in ready');
%    %open labFig;
%end
    



%To prevent resources from being used unnecessarily, use the exist function
%to determine whether or not to construct a GUI.

end

