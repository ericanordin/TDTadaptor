function WebcamBuffers()%screen)
% Creates a dummy webcam analogue of the buffer system in Continuous_Acquire.
% For testing of Waveform and Spectrogram plotting.
% Build 30s or so buffer and then plot. Work on getting a rolling buffer
% later by moving start bits out and end bits in.
% Modify YData property instead of re-plotting to save time.

%import GUIFiles.RecordScreen

%clear all; clc;

% size of the entire serial buffer
npts = 200000;%48000; %sampling frequency
buffLength = 5;
builtBuffer = zeros(1, npts*buffLength); %5s buffer

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

% main looping section
for i = 0:(buffLength-1)
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
    builtBuffer(1, (1 + i*npts):(npts/2 + npts*i)) = samples1(1:npts/2);
    %PlotLoop(samples1);
    play(rec1);
    disp('Copying 1');
    
    while(curindex < bufpts)
        curindex = rec2.CurrentSample;
    end

    stop(rec2);
    disp('Stopped 2');
    disp('rec2 samples: '); disp(rec2.TotalSamples);
    curindex = 0;
    samples2 = getaudiodata(rec2)';
    builtBuffer(1, (1 + i*npts + npts/2):(npts*(i+1))) = samples2(1:npts/2);
    %PlotLoop(samples2);
    
    play(rec2);
    disp('Copying 2');
    
end
%plot(builtBuffer);
spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
colormap('gray');
