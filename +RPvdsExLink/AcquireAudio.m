function AcquireAudio(screen)
%Interfaces with processor to record audio
%   Based off of example code "Continuous Acquire" provided by TDT.
%   For details on the example see TDT's ActiveX Reference Manual pg 78 (pdf pg 86).

%% Set Up
import GUIFiles.RecordScreen
import RPvdsExLink.*
import StandardFunctions.addToStatus
import Enums.SaveFormat

recordObj = get(screen, 'recordObj'); 

if ~exist(screen.startingPathway, 'dir')
    %Create save location directory if it does not exist.
    mkdir(screen.startingPathway);
end

try
    RP = TDTRP('C:\Ultrasonic Recording Program\AcquireAudio.rcx', 'RX6');
    %Connect to processor via AcquireAudio.rcx circuit
    
catch ME
    addToStatus('RX6 not connected', screen);
    rethrow(ME);
end

buffObj = BufferObject(RP);

if recordObj.continuous == 0
    %Buffers are recorded until the record time has elapsed.
    %buffReps reports how many buffers are needed for the record time, 
    %dependent on the length of the buffer.
    buffReps = ceil(recordObj.recordTime/buffObj.buffLength);
end

fs = RP.GetSFreq(); %Returns sampling frequency

%Name binary file.
%Audio data is stored as a growing binary file during recording and
%converted to a WAVE file after recording stops.
[directory, local, ~] = fileparts(recordObj.wavName);
binaryFilePath = [directory '\' local];
binaryFilePath = [binaryFilePath '.' recordObj.binaryFormat];

fnoise = fopen(binaryFilePath, 'w'); %Open binary file for writing

%% Acquisition

% Begin acquiring
RP.SoftTrg(1); %Software trigger 1 allows buffer to intake info from AdcIn
curindex = RP.GetTagVal('index');

try
    % main looping section
    if recordObj.continuous == 1
        %Continue recording until the user presses Stop
        while recordObj.recordStatus == 1
            SaveBuffer(RP, curindex, buffObj, fnoise, screen);
            PlotBuffer(screen, buffObj, recordObj.continuous);
            
            buffObj.totalReps = buffObj.totalReps + 1;
        end
    else
        %Record until timer runs out
        while buffObj.totalReps <= buffReps -1
            SaveBuffer(RP, curindex, buffObj, fnoise, screen);
            PlotBuffer(screen, buffObj, recordObj.continuous);
            if recordObj.recordStatus == 0
                %User pressed Stop. Stop recording early.
                screen.timeRemaining = 0;
                set(screen.timeChangingDisplay, 'String', screen.timeRemaining);
                break
            end
            
            buffObj.totalReps = buffObj.totalReps + 1;
            
        end
        stopRecord(screen);
    end
catch ME
    addToStatus('Error during recording.', screen);
    rethrow(ME);
end

%% Post-Acquisition

RP.SoftTrg(2); %Stop acquiring
RP.Halt; %Stops processing chain

fclose(fnoise); %Close binary file

%Conversion from .f32 to .wav
binaryFile = fopen(binaryFilePath, 'r'); %Open binary file for reading
totalSound = fread(binaryFile, ['*' recordObj.valuePrecision]);
addToStatus('Saving...', screen);
pause(0.01);

try
    totalSound = Enums.SaveFormat.scaleForFormat(recordObj.bitDepth, totalSound);
    %Binary saves data as float values. scaleForFormat adjusts for
    %float/int based on the chosen bit depth.
catch ME
    addToStatus('Invalid .wav format. Conversion cancelled; .F32 file saved.',screen);
    rethrow ME;
end

audiowrite(recordObj.wavName, totalSound, floor(fs), 'BitsPerSample', ...
    recordObj.bitDepth); %Write WAVE file

fclose(binaryFile); %Close binary file
delete(binaryFilePath); %Binary file not deleted once WAVE file has been saved.
delete(buffObj);
addToStatus('Saved successfully', screen);
enableNew(screen);

