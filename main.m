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
    %Determine file save locations for various labs
    %Make while loop stop when RecordScreen is closed.
    
import Enums.*
import GUIFiles.*
import StandardFunctions.*

% The same GUI objects are used until the program is closed so that the
% user doesn't have to constantly redo the procedure from opening the
% program.

global running;
running = 1;
firstRun = 1;
entryScr = EntryScreen();

%Names for screens not initially created are initialized to
%an empty string so that isobject returns 0 instead of crashing the
%program. The exist function doesn't work on objects.
labScr = '';
ratScr = '';
recordScr = RecordScreen();
set(recordScr.guiF, 'visible', 'off');
%recordScr = ''; 

%labScr = LabScreen();
%ratScr = RatScreen();

%set(recordScr.guiF, 'visible', 'off');
%disp('Past constructors');

nameType = getNameType(entryScr);

while (running == 1)
%if firstRun == 1
%    set(entryScr.guiF, 'visible', 'on');
%end
if nameType == NamingMethod.Auto
    %disp('In Auto-if');
    if firstRun == 1
    checkExistence = isobject(labScr);
    if checkExistence == 0
        labScr = LabScreen();
    else
        set(labScr.guiF, 'visible', 'on');
    end
    labName = getLabName(labScr);
    
    %Location of next two lines may change based on directory requests.
    labDirectory = makeLabDirectory(labName);
    set(recordScr, 'startingPathway', labDirectory);
    
    %disp(recordScr.startingPathway);
    end
    
    checkExistence = isobject(ratScr);
    if checkExistence == 0
        ratScr = RatScreen();
    else
        set(ratScr.guiF, 'visible', 'on');
    end
    [rat, day, cohort] = getRatData(ratScr);
    autoName = setNameAuto(labDirectory, labName, rat, day, cohort);
    set(recordScr, 'fileName', autoName);
    set(recordScr.fileNameEditable, 'String', autoName);
%else
    %disp('Skipped Auto-if');
else
    set(recordScr, 'fileName', recordScr.startingPathway);
    set(recordScr.fileNameEditable, 'String', recordScr.startingPathway);
end

set(recordScr.guiF, 'visible', 'on');

%waitfor New Recording button to trigger appropriate function
%waitfor(recordScr); %Prevents program from closing during development stages.
%Will be replaced by while loop.

waitForNew(recordScr);
firstRun = 0;
set(recordScr.guiF, 'visible', 'off');
end

%To prevent resources from being used unnecessarily, use the exist function
%to determine whether or not to construct a GUI.
delete(findall(0, 'Type', 'figure'));
end

function quitOnClose()
    global running;
    running = 0;
end


