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
        reductionFactor; %What number to divide the values by to get them within +/-1
        readFormat; %Format that data is read from the buffer
        %readPrecision; %Precision that data is read from the buffer
        
    end
    
    methods
        function this = Recording()
            this.recordStatus = 0;
            this.wavName = 'C:\';
            this.recordTime = 12*60;
            this.continuous = 0;
            this.bitDepth = 32;
            this.binaryFormat = 'F32';
            this.valuePrecision = 'float32';
            this.reductionFactor = 10; %Values range +/-10 during entry
            this.readFormat = 'F32';
            %this.readPrecision = 'float32';
        end
        
        function updateBitVariables(recordObj, bitValue)
            import Enums.SaveFormat
            try
                switch bitValue
                    case SaveFormat.Int32
                        recordObj.bitDepth = 32;
                    case SaveFormat.Float24
                        recordObj.bitDepth = 24;
                    case SaveFormat.Float16
                        recordObj.bitDepth = 16;
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

