function AcquireAudio(screen)
%See ActiveX Reference Manual (pdf pg 86) for information about the example template.

% One-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

%% Set Up
import GUIFiles.RecordScreen
import RPvdsExLink.*
import StandardFunctions.addToStatus
import Enums.SaveFormat

recordObj = get(screen, 'recordObj');
if ~exist(screen.startingPathway, 'dir')
    mkdir(screen.startingPathway);
end

try
    RP = TDTRP('C:\Ultrasonic Recording Program\AcquireAudio.rcx', 'RX6');
    
catch ME
    addToStatus('RX6 not connected', screen);
    rethrow(ME);
end

buffObj = BufferObject(RP);

if recordObj.continuous == 0
    buffReps = ceil(recordObj.recordTime/buffObj.buffLength);
end

fs = RP.GetSFreq(); %Returns sampling frequency

[directory, local, ~] = fileparts(recordObj.wavName);
binaryFilePath = [directory '\' local];
binaryFilePath = [binaryFilePath '.' recordObj.binaryFormat];

fnoise = fopen(binaryFilePath, 'w');

%% Acquisition

% Begin acquiring
RP.SoftTrg(1); %Software trigger 1 allows buffer to intake info from AdcIn
curindex = RP.GetTagVal('index');

try
    % main looping section
    if recordObj.continuous == 1
        while recordObj.recordStatus == 1
            SaveBuffer(RP, curindex, buffObj, fnoise, screen);
            PlotBuffer(screen, buffObj, recordObj.continuous);
        end
    else
        while buffObj.totalReps <= buffReps -1
            SaveBuffer(RP, curindex, buffObj, fnoise, screen);
            PlotBuffer(screen, buffObj, recordObj.continuous);
            if recordObj.recordStatus == 0
                screen.timeRemaining = 0;
                set(screen.timeChangingDisplay, 'String', screen.timeRemaining);
                break
            end
            
            buffObj.totalReps = buffObj.totalReps + 1;
            
        end
        stopRecord(screen);
    end
catch ME
    disp('Caught error');
    rethrow(ME);
end

%% Post-Acquisition

RP.SoftTrg(2); %Stop acquiring
RP.Halt; %Stops processing chain

fclose(fnoise);

%Conversion from .f32 to .wav
binaryFile = fopen(binaryFilePath, 'r');
totalSound = fread(binaryFile, ['*' recordObj.valuePrecision]);
addToStatus('Saving...', screen);
pause(0.01);

try
    totalSound = Enums.SaveFormat.scaleForFormat(recordObj.bitDepth, totalSound);
catch ME
    addToStatus('Invalid .wav format. Conversion cancelled; .F32 file saved.');
    rethrow ME;
end

audiowrite(recordObj.wavName, totalSound, floor(fs), 'BitsPerSample', ...
    recordObj.bitDepth);

fclose(binaryFile);
delete(binaryFilePath);
delete(buffObj);
addToStatus('Saved successfully', screen);
enableNew(screen);

