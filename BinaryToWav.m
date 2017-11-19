function BinaryToWav()
%BinaryToWave converts .f32/.i16 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.

[fileName, filePath, ~] = uigetfile({'*.i16;*.f32', ...
    'Binary Files(*.i16, *.f32)'}, 'Select binary file');

fullPath = strcat(filePath, fileName);
[~, ~, ext] = fileparts(fullPath);
disp(ext);
if strcmp(ext, '.I16')
    bits = 16;
    precision = '*int16';
else
    if strcmp(ext, 'F32')
        bits = 32;
        precision = '*float32';
    else
        %disp('Compare not working');
        msgbox('Error reading file. Conversion not completed.');
        quit;
    end
end

Wavfile = fullPath(1:end-3);
Wavfile = strcat(Wavfile, 'wav');
disp(Wavfile);
binaryFile = fopen(fullPath, 'r');
totalSound = fread(binaryFile, precision);
audiowrite(Wavfile, totalSound, 195312, 'BitsPerSample', bits);
%195312 is the frequency for the TDT

fclose(binaryFile);
delete(fullPath); %Deletes binary file
msgbox({'Conversion complete.' '.wav file saved and binary file deleted'});
end

