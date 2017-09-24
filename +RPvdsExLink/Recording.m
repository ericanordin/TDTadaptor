classdef Recording < handle & matlab.mixin.SetGetExactNames
    %RECORDING Stores the details of the recording to prevent circular
    %dependency issues between RecordScreen and AcquireAudio.
    %   Detailed explanation goes here
    
    properties
        recordStatus; %1 = recording; 0 = not recording
        wavName;
        recordTime;
        continuous; %Boolean expression of whether the recording is continuous.
        %recordObj.recordTime is disabled when it is 1 and enabled when it is 0.
        %webcam; %Dummy audio recorder
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = 'C:\Users\erica.nordin\Documents\MATLAB\TDT_development\SavedAudio\testing.wav';
            this.recordTime = 2;
            this.continuous = 0;
        end
    end
    
end

