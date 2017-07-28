function filePath = setNameAuto( labDirectory, labName, ratID, dayID, cohortID )
%SETNAMEAUTO Imports information to determine the save location for the recording.
%To do:
%Write basic function for Metz
<<<<<<< HEAD
=======
%Enable warning if file name already exists
%Refactor: Move in call to makeLabDirectory
>>>>>>> 172275cbc54d7a77051960a05d1ef5fa591679f3

import Enums.LabName

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

