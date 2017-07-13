function filePath = setNameManual(~,~,startingPathway)
%SETNAMEMANUAL Allows the user to enter the file name manually via dialog box. 
%Main saves the pathway from previous rats to take the user to the deepest 
%recent directory. 
%To do:
%Write basic function
%Enable 'go back'
%Text disappears on click
%Enable warning if file name already exists
%Make function pause before fullfile command until LocalName has been
%executed.
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
filePath = fullfile(directory, localName, fileType);
disp(filePath);

    function LocalName(~,~)
        localName = get(nameFileField, 'String');
    end

end

