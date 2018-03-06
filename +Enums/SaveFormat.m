classdef SaveFormat < handle & matlab.mixin.SetGetExactNames
    %SAVEFORMAT Defines enumeration for the different enabled WAV save formats.
    enumeration
        Int32, Float24, Float16
    end
    
    properties
    end
    
    methods(Static)
        %% Function Descriptions:
        %scaleForFormat: Used in AcquireAudio for float/int
        %retrieveBitDepth: Convert SaveFormat enum to numerical bit depth
        
        %% Function Code:
        
        function sound = scaleForFormat(bitDepth, sound)
            %Converts float sound vector to int for approprate save format 
            %to convert from binary file to WAV.
            
            %Input:
            %bitDepth = enumeration format of sound
            %sound = vector of audio data
            
            %Output:
            %sound = modified audio data vector
            
            import Enums.SaveFormat
            switch bitDepth
                case SaveFormat.Float16
                    %Float; do nothing
                case SaveFormat.Float24
                    %Float; do nothing
                case SaveFormat.Int32
                    %Adjust range for int instead of float
                    %Ranges -2^31 to 2^32-1
                    sound = int32(2^31*sound);
                otherwise
                    errorStruct.identifier = 'SaveFormat:invalidBitDepthForScaling';
                    error(errorStruct);
            end
            
        end
        
        function numBit = retrieveBitDepth(enum)
            %Returns a numerical bit depth from an enum bit depth
            
            %Input:
            %enum = enumeration format of sound
            
            %Output:
            %numBit = numerical equivalent of enum
            
            import Enums.SaveFormat
            switch enum
                case SaveFormat.Int32
                    numBit = 32;
                case SaveFormat.Float24
                    numBit = 24;
                case SaveFormat.Float16
                    numBit = 16;
                otherwise
                    errorStruct.identifier = 'SaveFormat:invalidEnumInput';
                    error(errorStruct);
            end
        end
    end
    
end

