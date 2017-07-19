function main()
%Enable exit in CloseProgram for each GUI before compiling.

%MAIN Runs the show.
    %To do:
    %Determine file save locations for various labs
    
import Enums.*
import GUIFiles.*
import StandardFunctions.*

% The same GUI objects are used until the program is closed so that the
% user doesn't have to constantly redo the procedure from opening the
% program.

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

nameType = getNameType(entryScr);

while (running == 1)
if nameType == NamingMethod.Auto
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
else
    set(recordScr, 'fileName', recordScr.startingPathway);
    set(recordScr.fileNameEditable, 'String', recordScr.startingPathway);
end

set(recordScr.guiF, 'visible', 'on');

waitForNew(recordScr);
firstRun = 0;
set(recordScr.guiF, 'visible', 'off');
end

delete(findall(0, 'Type', 'figure'));
end

