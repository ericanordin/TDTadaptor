function filePath = setNameManual(~,~,startingPathway)
%SETNAMEMANUAL Allows the user to enter the file name manually via dialog box. 
%Main saves the pathway from previous rats to take the user to the deepest 
%recent directory. 
%To do:
%Enable 'go back'
%Text disappears on click
%Enable warning if file name already exists
%File saving
disp('In setNameManual');
disp(startingPathway);
fileType = '.wav';
localName = '';

directory = uigetdir(startingPathway);
nameFileWindow = figure('Name', 'Name Your .wav File', 'Position',...
    [200 700 300 300], 'NumberTitle', 'off', 'ToolBar', 'none');
nameFileField = uicontrol('Style', 'edit', 'String', 'Name_of_file',...
    'Position', [20 100 200 100], 'Callback', @LocalName);
uicontrol('Style', 'text', 'Position', [220 100 80 100], 'String',...
    fileType);
uiwait(gcf); %Pauses program until the local file name has been entered.
nameWithDesignation = strcat(localName, fileType);
filePath = fullfile(directory, nameWithDesignation);
disp(filePath);

    function LocalName(~,~)
        localName = get(nameFileField, 'String');
        uiresume(gcbf);
    end

end

