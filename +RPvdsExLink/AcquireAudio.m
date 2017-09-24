function AcquireAudio(screen)
%See ActiveX Reference Manual (pdf pg 86) for information about the example template.

% One-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

%May have to add ActXExamples to path
%screen is RecordScreen object. Function uses get to receive Recording
%object.

%% Set Up
import GUIFiles.RecordScreen
import RPvdsExLink.*
import StandardFunctions.addToStatus

%May need actxcontrol() call to use ActiveX methods

recordObj = get(screen, 'recordObj');

%Change this once all files have been stored in their final location
RP = TDTRP(...
    'C:\Users\erica.nordin\OneDrive\Documents\Fall 2017 NSERC\Ultrasonic files\TDT\Continuous_AcquireRX6modified.rcx',...
    'RX6');

% size of the entire serial buffer
npts = RP.GetTagSize('dataout'); %Returns maximum number of accessible data points

fs = RP.GetSFreq(); %Returns sampling frequency
buffLength = 2; %2s buffer
if recordObj.continuous == 0
    buffReps = ceil(recordObj.recordTime/buffLength); 
end
%Rounds up if not divisible by buffLength
builtBuffer = zeros(1, npts*buffLength);

% serial buffer will be divided into two buffers A & B (to prevent the risk
% of data in the buffer being overwritten)
bufpts = npts/2;

displaySampleRange = 1:npts*buffLength;


filePathF32 = recordObj.wavName(1:end-3);
filePathF32 = [filePathF32 'F32'];

fnoise = fopen(filePathF32, 'w');

%% Acquisition

% begin acquiring
RP.SoftTrg(1); %Software trigger 1 allows buffer to intake info from AdcIn
curindex = RP.GetTagVal('index');
%disp(['Current buffer index: ' num2str(curindex)]);

% main looping section
if recordObj.continuous == 1
    while recordObj.recordStatus == 1
        [RP, fnoise] = SaveBuffer(RP, curindex, bufpts, fnoise, screen);
    end
else
    for i = 1:recordObj.recordTime
        %fwrite(fnoise, [1 2 3], 'float32');
        [RP, fnoise] = SaveBuffer(RP, curindex, bufpts, fnoise, screen);
        if recordObj.recordStatus == 0
            screen.timeRemaining = 0;
            set(screen.timeRemainingDisplay, 'String', screen.timeRemaining);
            break
        end
        decrementTime(screen);
    end
    stopRecord(screen);
end

%% Post-Acquisition


RP.SoftTrg(2); %Stop acquiring
RP.Halt; %Stops processing chain

fclose(fnoise);

F32Complete = fopen(filePathF32, 'r');
totalSound = fread(F32Complete, '*float32');
addToStatus('Saving...', screen);
audiowrite(recordObj.wavName, totalSound, floor(fs), 'BitsPerSample', 32);

fclose(F32Complete);
delete(filePathF32);
addToStatus('Saved successfully', screen);
enableNew(screen);

