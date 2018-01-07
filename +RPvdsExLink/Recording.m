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
            import Enums.SaveFormat
            try
            switch bitValue
                case SaveFormat.Int32
                    recordObj.bitDepth = 32;
                    recordObj.binaryFormat = 'I32';
                    recordObj.valuePrecision = 'int32';
                case SaveFormat.Float24
                    recordObj.bitDepth = 24;
                    recordObj.binaryFormat = 'F24';
                    recordObj.valuePrecision = 'float24';
                case SaveFormat.Float16
                    recordObj.bitDepth = 16;
                    recordObj.binaryFormat = 'F16';
                    recordObj.valuePrecision = 'float16';
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

