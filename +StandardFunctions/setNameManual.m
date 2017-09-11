function [filePath, startingPathway] = setNameManual(filePath, startingPathway)
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

try
directory = uigetdir(startingPathway);
catch
    
end
if directory == 0
    disp('Successfully skipped');
else
    startingPathway = directory; %Maintains pathway for future use.
    
    
    nameFileWindow = figure('Name', 'Name Your .wav File', 'Position',...
        [200 700 300 300], 'NumberTitle', 'off', 'ToolBar', 'none', ...
        'MenuBar', 'none', 'CloseRequestFcn', @HideWindow);
    
    uicontrol('Style', 'text', 'String',...
        'Type in the local file name and press Enter to continue',...
        'Position', [20 170 260 100]);
    
    nameFileField = uicontrol('Style', 'edit',...
        'Position', [20 100 200 100], 'Callback', @LocalName);
    
    uicontrol('Style', 'text', 'Position', [220 100 80 100], 'String',...
        fileType);
    
    uicontrol(nameFileField); %Places cursor on nameFileField
    
    uiwait(gcf); %Pauses program until the local file name has been entered.
    
    nameWithDesignation = strcat(localName, fileType);
    filePath = fullfile(startingPathway, nameWithDesignation);
    disp(filePath);
    close(nameFileWindow); %Closes the window
    
end

    function LocalName(~,~)
        %Sets the local file name to the contents of nameFileField
        
        %import StandardFunctions.ClearText;
        %ClearText(nameFileField);
        %set(nameFileField, 'String', '');
        
        localName = get(nameFileField, 'String');
        uiresume(gcbf);
    end

    function HideWindow(~,~)
        import StandardFunctions.generalHideWindow;
        generalHideWindow(nameFileWindow);
        %disp('In HideWindow');
        %set(nameFileWindow, 'visible', 'off'); %Makes window invisible
        %exit;
    end
%{
function TabShortcut(~, eventdata)
        
        import StandardFunctions.ClearText;
       if strcmp(eventdata.Key, 'tab')
           ClearText(nameFileField);
       end
    end
%}
%function ClearText(~,~)

%disp('Internal ClearText');
%end

end

