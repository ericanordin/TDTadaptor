function filePath = setNameAuto( labDirectory, labName, ratID, dayID, cohortID )
%SETNAMEAUTO Imports information to determine the save location for the recording.

import Enums.LabName
%import StandardFunctions.makeLabDirectory;

if strcmp(labName, 'Gibb')
    %Use Metz naming convention
    %Place holder until other information is received
    dateFormat = 'yyyy-mm-dd';
    saveDate = datestr(date, dateFormat);
    timeFormat = 'HH-MM';
    saveTime = datestr(now, timeFormat);
    
    filePath = strcat(labDirectory, 'ID');
    filePath = strcat(filePath, ratID);
    filePath = strcat(filePath, 'P');
    filePath = strcat(filePath, dayID);
    filePath = strcat(filePath, 'Ex');
    filePath = strcat(filePath, cohortID);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, saveDate);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, 'T');
    filePath = strcat(filePath, saveTime);
    filePath = strcat(filePath, '.wav');
    
    
else %Metz, Euston, and Other use same naming convention
    
    dateFormat = 'yyyy-mm-dd';
    saveDate = datestr(date, dateFormat);
    timeFormat = 'HH-MM';
    saveTime = datestr(now, timeFormat);
    
    filePath = strcat(labDirectory, 'R');
    filePath = strcat(filePath, ratID);
    filePath = strcat(filePath, 'D');
    filePath = strcat(filePath, dayID);
    filePath = strcat(filePath, 'C');
    filePath = strcat(filePath, cohortID);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, saveDate);
    filePath = strcat(filePath, '_');
    filePath = strcat(filePath, 'T');
    filePath = strcat(filePath, saveTime);
    filePath = strcat(filePath, '.wav');
    
end

end

