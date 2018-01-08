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
        IorF; %Int or Float .wav file
        
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
            this.reductionFactor = 10; %Values range +/-10 during entry
            this.readFormat = 'F32';
            %this.readPrecision = 'float32';
            this.IorF = 'F';
        end
        
        function updateBitVariables(recordObj, bitValue)
            import Enums.SaveFormat
            try
            switch bitValue
                case SaveFormat.Int32
                    recordObj.bitDepth = 32;
                    %recordObj.binaryFormat = 'I32';
                    %recordObj.valuePrecision = 'int32';
                    recordObj.IorF = 'I';
                    
                case SaveFormat.Float24
                    recordObj.bitDepth = 24;
                    %recordObj.binaryFormat = 'F24';
                    %recordObj.valuePrecision = 'float24';
                    recordObj.IorF = 'F';
                case SaveFormat.Float16
                    recordObj.bitDepth = 16;
                    %recordObj.binaryFormat = 'F16';
                    %recordObj.valuePrecision = 'float16';
                    recordObj.IorF = 'F';
                otherwise
                    errorStruct.identifier = 'Recording:invalidBitDepth';
                    error(errorStruct);
            end
            %disp(recordObj.bitDepth);
            %disp(recordObj.IorF);
            catch ME
                rethrow ME;
            end
            
        end
        
        %{
        function scaleAndSave(fnoise, noise, recordObj)
           scaledNoise = noise./recordObj.reductionFactor;
           switch recordObj.valuePrecision
               case 'int32'
                   scaledNoise = int32(2^31*scaledNoise);
               case 'float24'
                   %Do nothing
                   %scaledNoise = 
               case 'float16'
                   %Do nothing
               otherwise
                   %Throw error
           end
            fwrite(fnoise, scaledNoise, recordObj.valuePrecision);
        end
        %}
    end
    
end

