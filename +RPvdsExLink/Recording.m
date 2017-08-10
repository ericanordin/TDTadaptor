classdef Recording < handle & matlab.mixin.SetGetExactNames
    %RECORDING Stores the details of the recording to prevent circular
    %dependency issues between RecordScreen and Continuous_Acquire.
    %   Detailed explanation goes here
    
    properties
        recordStatus; %1 = recording; 0 = not recording
        wavName;
        recordTime;
        bitDepth;
        continuous; %Boolean expression of whether the recording is continuous.
        %recordObj.recordTime is disabled when it is 1 and enabled when it is 0.
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = '';
            this.recordTime = 600;
            this.continuous = 0;
            this.bitDepth = 32;
        end

    end
    
end

