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
        %Metz divides subjects into Experimental and Control subfolders
        %Opens GUI to select Experimental/Control
        subfolderGUI = ExpOrContScreen();
        subfolder = getExpOrCont(subfolderGUI);
        delete(subfolderGUI);
        subfolder = strcat(subfolder, '\');
    else
        if strcmp(labName, 'Gibb')
            %Gibb divides subjects into Experiment # subfolders
            subfolder = 'Experiment';
            subfolder = strcat(subfolder, expNum);
            subfolder = strcat(subfolder, '\');
        end
    end
    %Labs that do not have a modifying section in this function save files 
    %directly into the lab folder.
catch ME
    if exist(subfolderGUI, 1)
        delete(subfolderGUI);
    end
    rethrow (ME);
end

labDirectory = strcat(combinedDirectory, subfolder);

end