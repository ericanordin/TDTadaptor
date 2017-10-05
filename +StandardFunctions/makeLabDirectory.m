function labDirectory = makeLabDirectory(labName, expNum)
%MAKELABDIRECTORY Takes the lab name and sets the location where the .wav
%file will be saved accordingly.

import GUIFiles.ExpOrContScreen

baseDirectory = 'C:\Data\';

combinedDirectory = strcat(baseDirectory, char(labName));
combinedDirectory = strcat(combinedDirectory, '\');

subfolder = '';
try
if strcmp(labName, 'Metz')
    subfolderGUI = ExpOrContScreen();
    subfolder = getExpOrCont(subfolderGUI);
    delete(subfolderGUI);
    subfolder = strcat(subfolder, '\');
else
    if strcmp(labName, 'Gibb')
        subfolder = 'Experiment';
        subfolder = strcat(subfolder, expNum);
        subfolder = strcat(subfolder, '\');
    end
end
catch ME
    delete(subfolderGUI);
    rethrow (ME);
end

labDirectory = strcat(combinedDirectory, subfolder);

end