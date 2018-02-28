function Downsampler()
%Downsampler copies a .wav file to a lower bit depth.
%   Does not delete original file for data conservation.

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

switch guiObj.bitDepthNew
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
    otherwise
        set(guiObj.gui, 'Visible', 'off');
        %Continue with conversion
end

%Create new file name
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

%Use 'native' for ints and 'double' for floats. 
%'native' automatically
%makes 24 bit float files int32 and 16 bit float files int16. 'native' only
%properly works for 32 bit int files. Loading a 32 bit int file with
%'double' converts the data to a float range (+/-1). 
%Best practice is probably to load everything with 'double' and convert to
%int if necessary via function in SaveFormat.
[data, sampleRate] = audioread(fullPath, 'native');

%Convert data to appropriate int/float format
totalSound = Enums.SaveFormat.scaleForDownsample(fileInfo.BitsPerSample, data);

audiowrite(newWav, totalSound, sampleRate, 'BitsPerSample', guiObj.bitDepthNew);

delete(guiObj);
msgbox({'Conversion complete.' '.wav file saved.'});


end

