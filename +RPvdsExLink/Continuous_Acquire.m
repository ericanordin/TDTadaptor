function Continuous_Acquire(filePath)
%See ActiveX Reference Manual (pdf pg 86) for information about the example template.

% One-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

close all; clear all; clc;

% filePath - set this to wherever the examples are stored
%filePath = 'C:\TDT\ActiveX\ActXExamples\Matlab\';

%May need actxcontrol() call to use ActiveX methods

%Change this once all files have been stored in their final location
RP = TDTRP(...
    'C:\Users\erica.nordin\OneDrive\Documents\Fall 2017\Ultrasonic files\TDT\Continuous_AcquireRX6',...
    'RX6');

% size of the entire serial buffer
npts = RP.GetTagSize('dataout'); %Returns maximum number of accessible data points 

% serial buffer will be divided into two buffers A & B (to prevent the risk
% of data in the buffer being overwritten)
fs = RP.GetSFreq(); %Returns sampling frequency
bufpts = npts/2; 
t=(1:bufpts)/fs;

filePath = strcat(filePath, 'fnoise.F32'); %Change this for .wav
fnoise = fopen(filePath,'w');
    
% begin acquiring
RP.SoftTrg(1); %Software trigger 1 allows buffer to intake info from AdcIn
curindex = RP.GetTagVal('index');
disp(['Current buffer index: ' num2str(curindex)]);

% main looping section
for i = 1:10  %10 seconds. Change to a while loop for continuous record, 
    %and take an argument to determine time. May require separate function
    %for if/else to separate while and for loops.
    %Use recordStatus to break out of while loop. Move it out of
    %RecordScreen to avoid circular dependency.

    % wait until done writing A
    while(curindex < bufpts) 
        curindex = RP.GetTagVal('index');
        pause(.05); %May be unnecessary
    end

    % read segment A
    %See pdf pg 58 for ReadRagVEX
    %May only be able to store data in 16-bit or 32-bit
    noise = RP.ReadTagVEX('dataout', 0, bufpts, 'F32', 'F32', 1);
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
        pause(.05); %May be unnecessary
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

% stop acquiring
RP.SoftTrg(2);
RP.Halt; %Stops processing chain

% plots the last npts data points
plot(t,noise);
axis tight;