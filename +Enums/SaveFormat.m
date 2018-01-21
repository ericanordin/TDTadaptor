classdef SaveFormat < handle & matlab.mixin.SetGetExactNames
    %SAVEFORMAT Defines enumeration for the different enabled WAV save formats.
    enumeration
        Int32, Float24, Float16
    end
    
    properties
    end
    
    methods(Static)
        function sound = scaleForFormat(bitDepth, sound)
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
                    errorStruct.identifier = 'Recording:invalidWavFormat';
                    error(errorStruct);
            end
            
        end
    end
    
end

