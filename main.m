function main()
%MAIN Runs the show.
    %To do:
    %Update UML
    
    %Before compiling:
    %Change filepaths in Continuous_Acquire
    %Enable exit in CloseProgram for each GUI
    
import Enums.*
import GUIFiles.*
import StandardFunctions.*
import RPvdsExLink.*

% The same GUI objects are used until the program is closed so that the
% user doesn't have to constantly redo the procedure from opening the
% program.

running = 1;
%firstRun = 1;
%entryScr = EntryScreen();

%Names for screens not initially created are initialized to
%an empty string so that isobject returns 0 instead of crashing the
%program. The exist function doesn't work on objects.
%labScr = '';
%ratScr = '';

recordScr = RecordScreen();
%set(recordScr.guiF, 'visible', 'off');

%nameType = getNameType(entryScr);

while (running == 1)
    import StandardFunctions.checkValidName;
%if nameType == NamingMethod.Auto

%else
%Resets the wav file name to the directory of the most recent rat.
   setFileName(recordScr, recordScr.startingPathway); 
   set(recordScr.fileNameEditable, 'String', recordScr.startingPathway);
   checkValidName(recordScr.startingPathway, recordScr.fileNameEditable, recordScr.errorColor);
   
%end

%set(recordScr.guiF, 'visible', 'on');

%Continuous_Acquire(recordScr);
%Might put Continuous_Acquire here; dependent upon recordStatus and
%filePath

waitForNew(recordScr);
%disp('New while loop rendition');
%firstRun = 0;
%set(recordScr.guiF, 'visible', 'off');

end

delete(findall(0, 'Type', 'figure'));
end

