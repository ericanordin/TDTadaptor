function WebcamBuffers()%screen)
% Creates a dummy webcam analogue of the buffer system in Continuous_Acquire.
% For testing of Waveform and Spectrogram plotting.
% Build 30s or so buffer and then plot. Work on getting a rolling buffer
% later by moving start bits out and end bits in.
% Modify YData property instead of re-plotting to save time.
% Must fix spectrogram axis problem (contents of spectrogram are
% disappearing).

%import GUIFiles.RecordScreen

%clear all; clc;

% size of the entire serial buffer
npts = 200000;%48000; %sampling frequency
buffLength = 5; %5s buffer
builtBuffer = zeros(1, npts*buffLength); 

% serial buffer will be divided into two buffers A & B (to prevent the risk
% of data in the buffer being overwritten)
bufpts = npts/2;
%t=(1:bufpts)/npts;

rec1 = audiorecorder(npts, 16, 1);
rec2 = audiorecorder(npts, 16, 1);

%recordObj = get(screen, 'recordObj');
%waitfor(recordObj, recordStatus, 1);

% begin acquiring
curindex = rec1.CurrentSample;
disp(['Current buffer index: ' num2str(curindex)]);

%record(rec1);
waveFig = figure(1);
set(waveFig, 'Name', 'Waveform');
specFig = figure(2);
set(specFig, 'Name', 'Spectrogram');

% main looping section
tic;
for second = 0:(buffLength-1)
    
    record(rec1);
    disp('Recording 1');

    while(curindex < bufpts)
        curindex = rec1.CurrentSample;
    end

    
    record(rec2); %Start new recording as quickly as possible to minimize
    %intermittent data loss.
    disp('Recording 2');
    
    stop(rec1);
    
    curindex = 0;
    disp('Stopped 1');
    disp('rec1 samples: '); disp(rec1.TotalSamples);
    %rec1 captures extra samples before it has time to stop
    %Won't be a problem using TDT buffer
    
    
    samples1 = getaudiodata(rec1)';
    builtBuffer(1, (1 + second*npts):(npts/2 + npts*second)) = samples1(1:npts/2);
    %PlotLoop(samples1);
    %play(rec1);
    disp('Copying 1');
    
    while(curindex < bufpts)
        curindex = rec2.CurrentSample;
    end

    stop(rec2);
    disp('Stopped 2');
    disp('rec2 samples: '); disp(rec2.TotalSamples);
    curindex = 0;
    samples2 = getaudiodata(rec2)';
    builtBuffer(1, (1 + second*npts + npts/2):(npts*(second+1))) = samples2(1:npts/2);
    %PlotLoop(samples2);
    
    %play(rec2);
    disp('Copying 2');
    
end
toc;

%Raw:
%{
figure(1);
wavePlot = plot(builtBuffer);
figure(2);


specPlot = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
%}


%hold on;
%axis([0 buffLength 0 80000]); 
%colormap('gray');
%get(wavePlot);
%get(specPlot);

%Somewhat normalized:
%dB are represented somewhat higher than they are originally.
[s, f, t] = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
figure(1);
hold on;
axis([0 buffLength 0 80000]);
spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');

hold off;
figure(2);
hold on;
imagesc(t, f, log10(abs(s)));
set(gca, 'Ydir', 'Normal');
axis([0 buffLength 0 80000]);
colorbar;
hold off;
end

