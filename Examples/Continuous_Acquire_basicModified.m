% One-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

close all; clear all; clc;

addpath('C:\TDT\ActiveX\ActXExamples\Matlab');

% filePath - set this to wherever the examples are stored
filePath = 'C:\Users\erica.nordin\Documents\MATLAB\TDT_development\SavedAudio\';

RP = TDTRP('C:\TDT\ActiveX\ActXExamples\RP_files\Continuous_Acquire.rcx', 'RX6');

% size of the entire serial buffer
npts = RP.GetTagSize('dataout');  

% serial buffer will be divided into two buffers A & B
fs = RP.GetSFreq();
%disp('fs: ');
%disp(fs);
%fs = floor(fs)
bufpts = npts/2; 
t=(1:bufpts)/fs;

wavPath = strcat(filePath, 'example.wav');
filePath = strcat(filePath, 'fnoise.F32');
fnoise = fopen(filePath,'w');
%disp(fnoise);
    
% begin acquiring
RP.SoftTrg(1);
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);

% main looping section
for i = 1:3  

    % wait until done writing A
    while(curindex < bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end

    % read segment A
    noise = RP.ReadTagVEX('dataout', 0, bufpts, 'F32', 'F32', 1);
    %audiowrite(filePath, noise, fs);
    disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);

    % checks to see if the data transfer rate is fast enough
    curindex = RP.GetTagVal('index');
    disp(['Current buffer index: ' num2str(curindex)]);
    if(curindex < bufpts)
        warning('Transfer rate is too slow');
    end

    % wait until start writing A 
    while(curindex > bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05);
    end

    % read segment B
    noise = RP.ReadTagVEX('dataout', bufpts, bufpts, 'F32', 'F32', 1);
    disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);

    % make sure we're still playing A 
    curindex = RP.GetTagVal('index');
    disp(['Current index: ' num2str(curindex)]);
    if(curindex > bufpts)
        warning('Transfer rate too slow');
    end

end

fclose(fnoise);

%totalData = textscan(filePath, '%f32');
toot = fopen(filePath, 'r');
totalData = fread(toot);
audiowrite(wavPath, totalData, floor(fs), 'BitsPerSample', 32);

fclose(toot);

% stop acquiring
RP.SoftTrg(2);
RP.Halt;

% plots the last npts data points
%plot(t,noise);
%axis tight;