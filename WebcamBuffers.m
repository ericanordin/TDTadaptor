function WebcamBuffers()%screen)
% Creates a dummy webcam analogue of the buffer system in Continuous_Acquire.
% For testing of Waveform and Spectrogram plotting.

%import GUIFiles.RecordScreen

%clear all; clc;

% size of the entire serial buffer
npts = 48000;

% serial buffer will be divided into two buffers A & B (to prevent the risk
% of data in the buffer being overwritten)
fs = npts; %Returns sampling frequency
bufpts = npts/2;
t=(1:bufpts)/fs;

rec1 = audiorecorder(npts, 16, 1);
rec2 = audiorecorder(npts, 16, 1);

%recordObj = get(screen, 'recordObj');
%waitfor(recordObj, recordStatus, 1);

% begin acquiring
curindex = rec1.CurrentSample;
disp(['Current buffer index: ' num2str(curindex)]);

%record(rec1);

% main looping section
for i = 1:5
    record(rec1);
    disp('Recording 1');

    while(curindex < bufpts)
        curindex = rec1.CurrentSample;
    end
    stop(rec1);
    disp('Stopping 1');
    
    record(rec2);
    disp('Recording 2');
    
    samples1 = getaudiodata(rec1);
    PlotLoop(samples1);
    disp('Copying 1');
    
    while(curindex > bufpts)
        curindex = rec2.CurrentSample;
    end

    stop(rec2);
    disp('Stopping 2');
    
    samples2 = getaudiodata(rec2);
    disp('Copying 2');
    
end
