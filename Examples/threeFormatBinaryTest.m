%{
pathI32 = 'C:\Users\erica.nordin\testI32.I32';
fnoise32 = fopen(pathI32, 'w');

pathF24 = 'C:\Users\erica.nordin\testF24.F24';
fnoise24 = fopen(pathF24, 'w');

pathF16 = 'C:\Users\erica.nordin\testF16.F16';
fnoise16 = fopen(pathF16, 'w');
%}

pathF32 = 'C:\Users\erica.nordin\testF32.F32';
fnoise32 = fopen(pathF32, 'w');

pathI32 = 'C:\Users\erica.nordin\testI32.wav';

pathF24 = 'C:\Users\erica.nordin\testF24.wav';

pathF16 = 'C:\Users\erica.nordin\testF16.wav';

recObj = audiorecorder;
record(recObj, 3);
pause(3);
s = getaudiodata(recObj);

fwrite(fnoise32, s, 'float32');
fclose(fnoise32);

binaryFile = fopen(pathF32, 'r');
totalSound = fread(binaryFile, '*float32');
intSound = int32(2^31*totalSound);
pause(0.01);

audiowrite(pathI32, intSound, recObj.SampleRate, 'BitsPerSample', ...
    32);
audiowrite(pathF24, totalSound, recObj.SampleRate, 'BitsPerSample', ...
    24);
audiowrite(pathF16, totalSound, recObj.SampleRate, 'BitsPerSample', ...
    16);

audiowrite('C:\Users\erica.nordin\testF32.wav', totalSound, recObj.SampleRate, 'BitsPerSample', ...
    32);

fclose(binaryFile);

%{
fwrite(fnoise32, s, 'int32');
fclose(fnoise32);

fwrite(fnoise24, s, 'float24');
fclose(fnoise24);

fwrite(fnoise16, s, 'float16');
fclose(fnoise16);
%}