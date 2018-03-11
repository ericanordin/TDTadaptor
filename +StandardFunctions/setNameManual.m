function [filePath, startingPathway] = setNameManual(startingPathway)
%SETNAMEMANUAL Allows the user to enter the file name manually via dialog box.
%Main saves the pathway from previous rats to take the user to the deepest
%recent directory.

import StandardFunctions.ClearText;
fileType = '.wav';
localName = '';

directory = uigetdir(startingPathway);

try
    if directory == 0
        errorStruct.identifier = 'setNameManual:callCanceled';
        error(errorStruct);
    else
        nameFileWindow = figure('Name', 'Name Your .wav File', 'Position',...
            [400 300 300 300], 'NumberTitle', 'off', 'ToolBar', 'none', ...
            'MenuBar', 'none', 'CloseRequestFcn', @HideWindow);
        
        uicontrol('Style', 'text', 'String',...
            'Type in the local file name and press Enter to continue',...
            'Position', [20 170 260 100]);
        
        nameFileField = uicontrol('Style', 'edit',...
            'Position', [20 100 200 100], 'Callback', @LocalName);
        
        uicontrol('Style', 'text', 'Position', [220 100 80 100], 'String',...
            fileType);
        
        uicontrol(nameFileField); %Places cursor on nameFileField
        try
            uiwait(gcf); %Pauses program until the local file name has been entered.
            if strcmp(localName, 'CANCEL')
                errorStruct.identifier = 'setNameManual:callCanceled';
                error(errorStruct);
            else
                startingPathway = directory; %Maintains pathway for future use.
                nameWithDesignation = strcat(localName, fileType);
                filePath = fullfile(startingPathway, nameWithDesignation);
                close(nameFileWindow); %Closes the window
            end
        catch ME
            rethrow ME;
        end
        
    end
catch ME
    rethrow(ME);
end

    function LocalName(~,~)
        %Sets the local file name to the contents of nameFileField
        localName = get(nameFileField, 'String');
        uiresume(gcbf);
    end

    function HideWindow(~,~)
        set(nameFileWindow, 'visible', 'off');
        localName = 'CANCEL';
        uiresume(gcbf);
    end
end

