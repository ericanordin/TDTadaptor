classdef SaveFormat < handle & matlab.mixin.SetGetExactNames
    %SAVEFORMAT Defines enumeration for the different enabled WAV save formats.
    enumeration
        Int32, Float24, Float16
    end
    
    properties
    end
    
    methods(Static)
        function sound = scaleForFormat(bitDepth, sound)
            %Adjusts between float and int for approprate save format for
            %conversion from binary file to WAV.
            switch bitDepth
                case 16
                    %Float; do nothing
                case 24
                    %Float; do nothing
                case 32
                    %Adjust range for int instead of float
                    %Ranges -2^31 to 2^32-1
                    sound = int32(2^31*sound);
                otherwise
                    errorStruct.identifier = 'SaveFormat:invalidBitDepthForScaling';
                    error(errorStruct);
            end
            
        end
        
        function soundReduced = scaleForDownsample(bitDepthLoaded, sound)
            %Adjusts between float and int for approprate save format for
            %downsampling to a lower bit depth WAV.
            switch bitDepthLoaded
                case 16
                    %Float; do nothing
                case 24
                    %Float; do nothing
                case 32
                    %Convert int (-2^31 to 2^32-1) to float (-1 to +1)
                    sound = double(sound);
                    soundReduced = sound./2^31;
                otherwise
                    errorStruct.identifier = 'SaveFormat:invalidBitDepthForDownsampling';
                    error(errorStruct);
            end
        end
    end
    
end

