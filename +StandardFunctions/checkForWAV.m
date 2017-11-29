function wavExists = checkForWAV(filePath)
%checkForWAV determines whether a .wav file with the same name exists in
%the directory
%   wavExists = 1 means the .wav exists and making a .wav file would
%   overwrite the existing file.
%   wavExists = 0 means the .wav file does not exist and the recording is
%   safe.

[~,~,ext] = fileparts(filePath);
if strcmp(ext, '.wav')
    wavName = filePath;
else
    wavName = erase(filePath, ext);
    wavName = [wavName, '.wav'];
end

if exist(wavName, 'file') == 2
    wavExists = 1;
else
    wavExists = 0;
end

end

