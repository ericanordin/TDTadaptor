function Downsampler()
%Downsampler copies a .wav file to a lower bit depth.
%   For data conservation, does not delete original file.

import Enums.SaveFormat

[fileName, filePath, ~] = uigetfile('*.wav', ...
    'Select file to downsample');

if fileName == 0
    msgbox('Error reading file. Conversion not completed.');
    return;
end

fullPath = strcat(filePath, fileName);
[~, ~, ext] = fileparts(fullPath);

fileInfo = audioinfo(fullPath);
%audioinfo does not detect whether the data is int or float. If the
%conversion depends on this, the data must be loaded before the gui.

guiObj = DownsamplerGUI(fileInfo.BitsPerSample);

waitfor(guiObj, 'guiComplete', 1);
if isnumeric(guiObj.enumNew) %Error stimulating premature exit
    switch guiObj.enumNew
        case -3
            msgbox('The file is already at the lowest bit depth (16 bit) and cannot be converted.');
            delete(guiObj);
            return;
        case -2
            msgbox('Input bit depth not recognized. Conversion cancelled.');
            delete(guiObj);
            return;
        case -1
            msgbox('Bit depth selection ended prematurely. Conversion cancelled.');
            delete(guiObj);
            return;
        case 0
            msgbox('Bit depth error. Conversion cancelled.');
            delete(guiObj);
            return;
    end
    %else Continue with conversion
end

% Name new audio file. Appends bit depth to the end of the file.
% Eg if file.wav is selected for saving as 16-bit, the new file will be
% named file_16bit.wav
newWav = erase(fullPath, ext);
newWav = strcat(newWav, '_');
newWav = strcat(newWav, num2str(guiObj.bitDepthNew));
newWav = strcat(newWav, 'bit');
newWav = strcat(newWav, '.wav');

willOverwrite = StandardFunctions.checkForWAV(newWav);

if willOverwrite == 1
    msgbox('A .wav file with this name already exists. Please move or rename the existing file to prevent overwrite. Conversion cancelled.');
    delete(guiObj);
    return;
end

% 'native' automatically loads 24 bit float files as int32 values and 16 bit
% float files as int16. 'native' only properly works for 32 bit int files.
% Loading a 32 bit int file with 'double' converts the data to a float
% range (+/-1). My solution was to load everything with 'double' and make
% appropriate output conversions from float to int if necessary.
[data, sampleRate] = audioread(fullPath, 'double');

%Convert data to appropriate int/float format for output
totalSound = SaveFormat.scaleForFormat(guiObj.enumNew, data);

audiowrite(newWav, totalSound, sampleRate, 'BitsPerSample', guiObj.bitDepthNew);

delete(guiObj);
msgbox({'Conversion complete.' '.wav file saved.'});


end

