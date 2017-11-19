function BinaryToWav()
%BinaryToWave converts .f32/.i16 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.

[fileName, filePath, ~] = uigetfile({'*.i16', '*.f32'}, 'Select binary file');

fullPath = strcat(filePath, fileName);
[~, ~, ext] = fileparts(fullPath);
info = audioinfo(fullPath);

Wavfile = fullPath(1:end-3);
Wavfile = strcat(Wavfile, 'wav');
binaryFile = fopen(fullPath, 'r');
totalSound = fread(binaryFile, ['*' ext]);
audiowrite(Wavfile, totalSound, info.sampleRate, 'BitsPerSample', info.BitsPerSample);

fclose(binaryFile);
delete(fullPath); %Deletes binary file
msgbox({'Conversion complete.' '.wav file saved and binary file deleted'});
end

