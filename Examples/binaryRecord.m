fnoise = fopen('G:\TDT\test.I16', 'w');
recorder = audiorecorder(195312, 16, 1, 1);
record(recorder, 3);
pause(3);
samples = getaudiodata(recorder);
fwrite(fnoise, samples, 'int16');
fclose(fnoise);