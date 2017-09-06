rec = audiorecorder(48000, 16, 1);
recordblocking(rec, 2); %Records for 5 seconds
%or record(rec); stop(rec);
%record(rec);
samples = getaudiodata(rec);
disp(samples);
numSamples = rec.TotalSamples;
[~, f, t, p] = spectrogram(samples, 256, 4, [], numSamples, 'yaxis');
figure(1);
%[~, f, t, p] = spectrogram(samples, 256, 4, [], numSamples, 'yaxis');
specPlot = imagesc(t, f, 10*log10(p+eps));
%specPlot.PropertyList;
%buff = specPlot.YData;
colormap('gray');
