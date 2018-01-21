function BinaryToWav()
%BinaryToWave converts .f32 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.
%Does not delete binary file to prevent data loss; deletion must be done by
%user

import Enums.SaveFormat

[fileName, filePath, ~] = uigetfile('*.f32', ...
    'Select binary file');

if fileName == 0
    msgbox('Error reading file. Conversion not completed.');
    return;
end

fullPath = strcat(filePath, fileName);
[~, ~, ext] = fileparts(fullPath);

if strcmp(ext, '.F32')
    precision = '*float32';
else
    msgbox('Error reading file. Conversion not completed.');
    return;
end

willOverwrite = StandardFunctions.checkForWAV(fullPath);

if willOverwrite == 1
    msgbox('A .wav file with this name already exists. Please move or rename the existing file to prevent overwrite. Conversion cancelled.');
    return;
end

guiObj = BinaryToWavGUI();

waitfor(guiObj, 'bitDepth');

if guiObj.bitDepth == -1
    msgbox('Bit depth selected ended prematurely. Conversion cancelled.');
    return;
else
    set(guiObj.gui, 'Visible', 'off');
end

if guiObj.bitDepth == 0
    msgbox('Bit depth error. Conversion cancelled.');
    return;
end

Wavfile = erase(fullPath, ext);
Wavfile = strcat(Wavfile, '_');
Wavfile = strcat(Wavfile, num2str(guiObj.bitDepth));
Wavfile = strcat(Wavfile, 'bit');
Wavfile = strcat(Wavfile, '.wav');

binaryFile = fopen(fullPath, 'r');
totalSound = fread(binaryFile, precision);

try
    totalSound = Enums.SaveFormat.scaleForFormat(guiObj.bitDepth, totalSound);
catch
    msgbox('Scaling error. Conversion cancelled.');
    return;
end

audiowrite(Wavfile, totalSound, 195312, 'BitsPerSample', guiObj.bitDepth);
%195312 is the frequency for the TDT

fclose(binaryFile);
delete(guiObj);
%delete(fullPath); %Deletes binary file
msgbox({'Conversion complete.' '.wav file saved.'});

end

