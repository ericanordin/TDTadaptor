function checkOverwrite(filePath, displayField, errorColor)
%checkOverwrite checks whether a file with the same name and location
%exists.
%   The displayField is coloured red if recording will overwrite an
%   existing file, if the file name does not end in .wav, if it is not
%   saving to a drive, or the file is unnamed after the directory.

fileDesignation = filePath(end-3:end);
directoryPrefix = filePath(2:3);
preWav = filePath(end-4);
validName = strcmp(fileDesignation, '.wav') && strcmp(directoryPrefix, ':\') ...
    && ~strcmp(preWav, '\');

if exist(filePath, 'file') == 2 || ~validName
    %Prevent overwrite or invalid path
    set(displayField, 'BackgroundColor', errorColor);
else
    set(displayField, 'BackgroundColor', 'white');
end

end

