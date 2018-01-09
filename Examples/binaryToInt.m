binaryFile = fopen('F:\Ultrasonic\testBinary.F32', 'r');
totalSound = fread(binaryFile, '*float32');
%addToStatus('Saving...', screen);
pause(0.01);
if strcmp(isI, 'I')
    %Save as int. Convert to relevant range.
    %try
    disp('In Int conversion');
    switch bitDepth
        case 16
        %Ranges -32768 to +32767
        totalSound = int16(32767*totalSound);
        disp('16bit');
        case 32
        %Ranges -2^31 to 2^32-1
        totalSound = int32(2^31*totalSound);
        disp('32bit');
        otherwise
            %addToStatus('Invalid .wav format. Conversion cancelled; .F32 file saved.');
            
%errorStruct.identifier = 'Recording:invalidWavFormat';
          %error(errorStruct);
    end
    %catch ME
     %   rethrow ME;
    %end
end
    
audiowrite('F:\Ultrasonic\testConvert.wav', totalSound, 195312, 'BitsPerSample', ...
    bitDepth);

fclose(binaryFile);