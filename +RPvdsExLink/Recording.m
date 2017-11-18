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
        bitDepth; %32 or 16 bit recording
        binaryFormat; %Storage format
        valuePrecision; %Specifies data type for MATLAB functions
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = 'C:\'; %Users\erica.nordin\Documents\MATLAB\TDT_development\SavedAudio\testing.wav';
            this.recordTime = 12*60;
            this.continuous = 0;
            this.bitDepth = 32;
            this.binaryFormat = 'F32';
            this.valuePrecision = 'float32';
        end
        
        function updateBitVariables(recordObj, bitValue)
            try
            switch bitValue
                case 32
                    recordObj.bitDepth = 32;
                    recordObj.binaryFormat = 'F32';
                    recordObj.valuePrecision = 'float32';
                case 16
                    recordObj.bitDepth = 16;
                    recordObj.binaryFormat = 'I16';
                    recordObj.valuePrecision = 'int16';
                otherwise
                    errorStruct.identifier = 'Recording:invalidBitDepth';
                    error(errorStruct);
            end
            catch ME
                rethrow ME;
            end
            
        end
    end
    
end

