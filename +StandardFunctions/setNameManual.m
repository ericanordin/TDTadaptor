function [filePath, startingPathway] = setNameManual(startingPathway)
%SETNAMEMANUAL Allows the user to enter the file name manually via dialog box. 
%Main saves the pathway from previous rats to take the user to the deepest 
%recent directory. 
%To do:
%Enable 'go back'
%Enable warning if file name already exists
%File saving

import StandardFunctions.ClearText;
disp('In setNameManual');
disp(startingPathway);
fileType = '.wav';
localName = '';

directory = uigetdir(startingPathway);
startingPathway = directory;
nameFileWindow = figure('Name', 'Name Your .wav File', 'Position',...
    [200 700 300 300], 'NumberTitle', 'off', 'ToolBar', 'none', ...
    'WindowKeyPressFcn', @TabShortcut, 'MenuBar', 'none');
uicontrol('Style', 'text', 'String',... 
    'Click the box or press tab, type in the local file name, and press Enter to continue',...
    'Position', [20 170 260 100]);
nameFileField = uicontrol('Style', 'edit', 'String', 'Name_of_file',...
    'Position', [20 100 200 100], 'Callback', @LocalName, ...
    'ButtonDownFcn', @ClearText, 'Enable', 'inactive');

uicontrol('Style', 'text', 'Position', [220 100 80 100], 'String',...
    fileType);
uiwait(gcf); %Pauses program until the local file name has been entered.
nameWithDesignation = strcat(localName, fileType);
filePath = fullfile(directory, nameWithDesignation);
disp(filePath);
close(nameFileWindow);

    function LocalName(~,~)
        %import StandardFunctions.ClearText;
        %ClearText(nameFileField);
        %set(nameFileField, 'String', '');
        
        localName = get(nameFileField, 'String');
        uiresume(gcbf);
    end

    function TabShortcut(~, eventdata)
        import StandardFunctions.ClearText;
       if strcmp(eventdata.Key, 'tab')
           ClearText(nameFileField);
       end
    end
    %function ClearText(~,~)
     
    %disp('Internal ClearText'); 
    %end

end

