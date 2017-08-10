classdef Recording < handle & matlab.mixin.SetGetExactNames
    %RECORDING Stores the details of the recording to prevent circular
    %dependency issues between RecordScreen and Continuous_Acquire.
    %   Detailed explanation goes here
    
    properties
        recordStatus;
        wavName;
        recordTime;
        bitDepth;
        continuous;
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = '';
            this.recordTime = 0;
            this.continuous = 0;
            this.bitDepth = 32;
        end

    end
    
end

