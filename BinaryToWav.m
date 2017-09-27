function BinaryToWav()
%BinaryToWave converts .f32 files to .wav in the case of program crash before
%the conversion has occurred in AcquireAudio.
[fileName, filePath, ~] = uigetfile('*.f32');
fullPath = strcat(filePath, fileName);
Wavfile = fullPath(1:end-3);
Wavfile = strcat(Wavfile, 'wav');
F32file = fopen(fullPath, 'r');
totalSound = fread(F32file, '*float32');
audiowrite(Wavfile, totalSound, 195312, 'BitsPerSample', 32);
%195312 is the frequency of the TDT

fclose(F32file);
delete(fullPath);
msgbox({'Conversion complete.' '.wav file saved and .f32 file deleted'});
end

