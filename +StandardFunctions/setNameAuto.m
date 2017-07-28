function filePath = setNameAuto( labDirectory, labName, ratID, dayID, cohortID )
%SETNAMEAUTO Imports information to determine the save location for the recording.
%To do:
%Differentiate for labs
%Determine subfolders

import Enums.LabName
import StandardFunctions.makeLabDirectory;

if strcmp(labName, 'Metz')
    %Use Metz naming convention
    %Place holder until other information is received
    dateFormat = 'yyyy-mm-dd';
    saveDate = datestr(date, dateFormat);
    timeFormat = 'hh-mm';
    saveTime = datestr(now, timeFormat);
    
    filePath = strcat(labDirectory, 'R');
    filePath = strcat(filePath, ratID);
    filePath = strcat(filePath, 'D');
    filePath = strcat(filePath, dayID);
    filePath = strcat(filePath, 'C');
    filePath = strcat(filePath, cohortID);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, saveDate);
    filePath = strcat(filePath, 'T');
    filePath = strcat(filePath, saveTime);
    filePath = strcat(filePath, '.wav');    
    
    
else %Gibb, Euston, and Other use same naming convention
    
    dateFormat = 'yyyy-mm-dd';
    saveDate = datestr(date, dateFormat);
    timeFormat = 'hh-mm';
    saveTime = datestr(now, timeFormat);
    
    filePath = strcat(labDirectory, 'R');
    filePath = strcat(filePath, ratID);
    filePath = strcat(filePath, 'D');
    filePath = strcat(filePath, dayID);
    filePath = strcat(filePath, 'C');
    filePath = strcat(filePath, cohortID);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, saveDate);
    filePath = strcat(filePath, 'T');
    filePath = strcat(filePath, saveTime);
    filePath = strcat(filePath, '.wav');
    
end

end

