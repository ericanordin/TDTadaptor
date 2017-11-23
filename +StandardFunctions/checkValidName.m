function checkValidName(filePath, displayField, errorColor)
%checkValidName checks whether a file with the same name and location
%exists.
%   The displayField is coloured red if recording will overwrite an
%   existing file, if the file name does not end in .wav, if it is not
%   saving to a drive, or the file is unnamed after the directory.

if length(filePath) < 4
    set(displayField, 'BackgroundColor', errorColor);
    return;
end

[~,~,ext] = fileparts(filePath);
directoryPrefix = filePath(2:3);
preWav = filePath(end-4);
numFolders = length(strfind(filePath, '\'));
nameNoExt = erase(filePath, ext);
binaryName = [nameNoExt, '.F32'];

validName = strcmp(ext, '.wav') && strcmp(directoryPrefix, ':\') ...
    && ~strcmp(preWav, '\') && numFolders >= 2;

if exist(filePath, 'file') == 2 || exist(binaryName, 'file') == 2 || ~validName
    %Prevent overwrite or invalid path
    set(displayField, 'BackgroundColor', errorColor);
else
    set(displayField, 'BackgroundColor', 'white');
end

end

