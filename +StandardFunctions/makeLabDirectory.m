function labDirectory = makeLabDirectory( labName )
%MAKELABDIRECTORY Takes the lab name and sets the location where the .wav
%file will be saved accordingly.
%This may need to change to take cohortID or other information to divide
%into subfolders.

%To do:
%Integrate enum to string conversion

labDirectory = strcat('C:\', char(labName));
labDirectory = strcat(labDirectory, '\');


end

