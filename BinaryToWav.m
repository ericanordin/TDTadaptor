function BinaryToWav()
%BinaryToWave converts .f32 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.
%Does not delete binary file to prevent data loss; deletion must be done by
%user

[fileName, filePath, ~] = uigetfile('*.f32', ...
    'Select binary file');

if fileName == 0
    msgbox('Error reading file. Conversion not completed.');
    return;
end

fullPath = strcat(filePath, fileName);
[~, ~, ext] = fileparts(fullPath);

if strcmp(ext, '.F32')
    bits = 32;
    precision = '*float32';
else
    msgbox('Error reading file. Conversion not completed.');
    return;
end

Wavfile = erase(fullPath, ext);
Wavfile = strcat(Wavfile, '.wav');
disp(Wavfile);
binaryFile = fopen(fullPath, 'r');
totalSound = fread(binaryFile, precision);
audiowrite(Wavfile, totalSound, 195312, 'BitsPerSample', bits);
%195312 is the frequency for the TDT

fclose(binaryFile);
%delete(fullPath); %Deletes binary file
msgbox({'Conversion complete.' '.wav file saved.'});
end

