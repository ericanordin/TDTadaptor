function checkValidName(filePath, displayField, errorColor)
%checkValidName checks whether a file with the same name and location
%exists.
%   The displayField is coloured red if recording will overwrite an
%   existing file, if the file name does not end in .wav, if it is saving 
%   directly to a drive (potential write permission problems), the file 
%   is unnamed after the directory, or the save location does not begin 
%   with a drive.

if length(filePath) < 4 %Saving in drive, not directory
    set(displayField, 'BackgroundColor', errorColor);
    return;
end

[~,localName,ext] = fileparts(filePath);
directoryPrefix = filePath(2:3);
numFolders = length(strfind(filePath, '\'));
nameNoExt = erase(filePath, ext);
binaryName = [nameNoExt, '.F32'];

%If ext != '.wav', the file is not the proper format.
%If directoryPrefix != ':\', a drive has not been selected.
%If localName == '\', the file does not have a local name.
%If numFolders <2, the file is in a drive, not a subfolder.
validName = strcmp(ext, '.wav') && strcmp(directoryPrefix, ':\') ...
    && ~strcmp(localName, '\') && numFolders >= 2;

if StandardFunctions.checkForWAV(filePath) || ...
        exist(binaryName, 'file') == 2 || ~validName
    %Prevent overwrite or invalid path
    set(displayField, 'BackgroundColor', errorColor);
else
    set(displayField, 'BackgroundColor', 'white');
end

end

