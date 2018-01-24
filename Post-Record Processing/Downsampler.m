function Downsampler()
%Downsampler copies a .wav file to a lower bit depth.
%   Does not delete original file for data conservation.

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

%disp(fileInfo.BitsPerSample);
%guiObj = 0;
%try
%    disp('tried');
guiObj = DownsamplerGUI(fileInfo.BitsPerSample);
%catch
  %  msgbox('Input bit depth not recognized. Conversion cancelled.');
   % delete(guiObj);
 %   return;
%end

waitfor(guiObj, 'bitDepthNew');

switch guiObj.bitDepthNew
    case 16
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
end

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

[data, sampleRate] = audioread(fullPath, 'native');

%Convert data to appropriate int/float format
totalSound = scaleForDownsample(fileInfo.BitsPerSample, data);

audiowrite(Wavfile, totalSound, sampleRate, 'BitsPerSample', guiObj.bitDepthNew);

delete(guiObj);
msgbox({'Conversion complete.' '.wav file saved.'});


end

