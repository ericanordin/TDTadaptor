classdef Recording < handle & matlab.mixin.SetGetExactNames
    %RECORDING Stores the details of the recording to prevent circular
    %dependency issues between RecordScreen and AcquireAudio.
    %   Detailed explanation goes here
    
    properties
        recordStatus; %1 = recording; 0 = not recording
        wavName;
        recordTime;
        bitDepth;
        continuous; %Boolean expression of whether the recording is continuous.
        %recordObj.recordTime is disabled when it is 1 and enabled when it is 0.
        %webcam; %Dummy audio recorder
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = 'C:\testing.wav';
            this.recordTime = 10;
            this.continuous = 0;
            this.bitDepth = 32;
            %this.webcam = audiorecorder(48000, 16, 1); %Webcam dummy audio source
            %Actual microphone will be 80000 Hz.
        end
        
        %function start(recObj)
        %    record(recObj.webcam);
        %end

    end
    
end

