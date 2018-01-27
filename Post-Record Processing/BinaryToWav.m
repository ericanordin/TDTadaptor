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

if strcmp(ext, '.F32') %Confirms binary file
    precision = '*float32';
else
    msgbox('Error reading file. Conversion not completed.');
    return;
end

guiObj = BinaryToWavGUI();

waitfor(guiObj, 'bitDepth');

switch guiObj.bitDepth
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
        %Proceed with conversion
end

% Name new audio file
Wavfile = erase(fullPath, ext);
Wavfile = strcat(Wavfile, '_');
Wavfile = strcat(Wavfile, num2str(guiObj.bitDepth));
Wavfile = strcat(Wavfile, 'bit');
Wavfile = strcat(Wavfile, '.wav');

willOverwrite = StandardFunctions.checkForWAV(Wavfile);

if willOverwrite == 1
    msgbox('A .wav file with this name already exists. Please move or rename the existing file to prevent overwrite. Conversion cancelled.');
    delete(guiObj);
    return;
end

%Load data:
binaryFile = fopen(fullPath, 'r');
totalSound = fread(binaryFile, precision);

try %Scale for float/int
    totalSound = Enums.SaveFormat.scaleForFormat(guiObj.bitDepth, totalSound);
catch
    msgbox('Scaling error. Conversion cancelled.');
    fclose(binaryFile);
    delete(guiObj);
    return;
end

audiowrite(Wavfile, totalSound, 195312, 'BitsPerSample', guiObj.bitDepth);
%195312 is the frequency for the TDT

fclose(binaryFile);
delete(guiObj);
msgbox({'Conversion complete.' '.wav file saved.'});

end

