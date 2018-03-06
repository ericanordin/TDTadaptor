function BinaryToWav()
%BinaryToWav converts .f32 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.
%Users are offered the choice for the bit depth of the WAVE file identical
%to the choices offered in the primary recording program
%Does not delete binary file to prevent data loss; deletion must be 
%performed by user
%NOTE: This program assumes sampling frequency of 195312 from RX6 processor. 
%MATLAB cannot read the sampling frequency from the binary file.

import Enums.SaveFormat

[fileName, filePath, ~] = uigetfile('*.f32', ...
    'Select binary file');

if fileName == 0 %Binary file select window closed
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
    case -1 %Figure  closed before selection
        msgbox('Bit depth selection ended prematurely. Conversion cancelled.');
        delete(guiObj);
        return;
    case 0 %Program didn't wait for bitDepth to change
        msgbox('Bit depth error. Conversion cancelled.');
        delete(guiObj);
        return;
    otherwise
        set(guiObj.gui, 'Visible', 'off');
        %Proceed with conversion
end

% Name new audio file. Appends bit depth to the end of the file.
% Eg if file.F32 is selected for saving as 16-bit, the new file will be
% named file_16bit.wav
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
    totalSound = Enums.SaveFormat.scaleForFormat(guiObj.enum, totalSound);
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

