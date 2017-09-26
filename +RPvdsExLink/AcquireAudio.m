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

try
%Change this once all files have been stored in their final location
RP = TDTRP('C:\Ultrasonic Recording Program\AcquireAudio.rcx', 'RX6');
%{
RP = TDTRP(...
    'C:\Users\erica.nordin\OneDrive\Documents\Fall 2017 NSERC\Ultrasonic files\TDT\Continuous_AcquireRX6modified.rcx',...
    'RX6');
%}
catch ME
    addToStatus('TDT not connected', screen);
    rethrow(ME);
end

buffObj = BufferObject(RP);

if recordObj.continuous == 0
    buffReps = ceil(recordObj.recordTime/buffObj.buffLength);
end

fs = RP.GetSFreq(); %Returns sampling frequency

filePathF32 = recordObj.wavName(1:end-3);
filePathF32 = [filePathF32 'F32'];

fnoise = fopen(filePathF32, 'w');

%% Acquisition

% begin acquiring
RP.SoftTrg(1); %Software trigger 1 allows buffer to intake info from AdcIn
curindex = RP.GetTagVal('index');
%disp(['Current buffer index: ' num2str(curindex)]);

try
% main looping section
if recordObj.continuous == 1
    while recordObj.recordStatus == 1
        SaveBuffer(RP, curindex, buffObj, fnoise, screen);
        PlotBuffer(screen, buffObj, recordObj.continuous);
    end
else
    while buffObj.totalReps <= buffReps -1
        %for buffObj.totalReps = 0:(buffReps-1)
        
        %fwrite(fnoise, [1 2 3], 'float32');
        SaveBuffer(RP, curindex, buffObj, fnoise, screen);
        PlotBuffer(screen, buffObj, recordObj.continuous);
        if recordObj.recordStatus == 0
            screen.timeRemaining = 0;
            set(screen.timeChangingDisplay, 'String', screen.timeRemaining);
            break
        end
        
        %end
        buffObj.totalReps = buffObj.totalReps + 1;
        
    end
    stopRecord(screen);
end
catch
    disp('Caught error');
    rethrow(ME);
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
delete(buffObj);
addToStatus('Saved successfully', screen);
enableNew(screen);

