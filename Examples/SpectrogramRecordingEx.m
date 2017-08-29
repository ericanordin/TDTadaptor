rec = audiorecorder(48000, 16, 1);
recordblocking(rec, 0.5); %Records for 5 seconds
%or record(rec); stop(rec);
%record(rec);
samples = getaudiodata(rec);
disp(samples);
numSamples = rec.TotalSamples;
spectrogram(samples, 256, 4, [], numSamples, 'yaxis');
colormap('gray');