function filePath = setNameAuto( labDirectory, labName, ratID, dayID, cohortID )
%SETNAMEAUTO Imports information to determine the save location for the recording.
%To do:
%Write basic function for Metz
%Enable warning if file name already exists

import Enums.LabName

if strcmp(labName, 'Metz')
    %Use Metz naming convention
    
else %Gibb and Euston use same naming convention
filePath = strcat(labDirectory, 'R');
filePath = strcat(filePath, ratID);
filePath = strcat(filePath, 'D');
filePath = strcat(filePath, dayID);
filePath = strcat(filePath, 'C');
filePath = strcat(filePath, cohortID);

end


end

