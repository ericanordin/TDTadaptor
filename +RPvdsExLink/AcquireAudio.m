function AcquireAudio(screen)
%See ActiveX Reference Manual (pdf pg 86) for information about the example template.

% One-channel continuous acquire example using a serial buffer
% This program writes to the buffer once it has cyled halfway through
% (double-buffering)

%% Set Up
import GUIFiles.RecordScreen
import RPvdsExLink.*
import StandardFunctions.addToStatus

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

%dataType = Data buffer
%{
dataType = RP.GetTagType('dataout');

switch dataType
    case 68
        addToStatus('Data Type: Data Buffer', screen);
    case 73
        addToStatus('Data Type: Integer', screen);
    case 78
        addToStatus('Data Type: Logical', screen);
    case 83
        addToStatus('Data Type: Float(Single)', screen);
    case 80
        addToStatus('Data Type: Coefficient Buffer', screen);
    case 65
        addToStatus('Data Type Undefined', screen);
    otherwise
        addToStatus('Problem reading data type', screen);
end
%}

[directory, local, ~] = fileparts(recordObj.wavName);
binaryFilePath = [directory '\' local];
%binaryFilePath = recordObj.wavName(1:end-3);
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
if strcmp(recordObj.IorF, 'I')
    %Save as int. Convert to relevant range.
    try
    switch recordObj.bitDepth
        case 16
        %Ranges -32768 to +32767
        totalSound = int16(32767*totalSound);
        case 32
        %Ranges -2^31 to 2^32-1
        totalSound = int32(2^31*totalSound);
        
        otherwise
            addToStatus('Invalid .wav format. Conversion cancelled; .F32 file saved.');
            errorStruct.identifier = 'Recording:invalidWavFormat';
            error(errorStruct);
    end
    catch ME
        rethrow ME;
    end
end
    
audiowrite(recordObj.wavName, totalSound, floor(fs), 'BitsPerSample', ...
    recordObj.bitDepth);

fclose(binaryFile);
delete(binaryFilePath);
delete(buffObj);
addToStatus('Saved successfully', screen);
enableNew(screen);

