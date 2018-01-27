%Ultrasonic_Recording_Interface
%Directly on computer:
mcc -e -d 'C:\Ultrasonic Recording Program' -o Ultrasonic_Recording_Interface main.m
%At home:
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\Ultrasonic_Recording_Interface' -o Ultrasonic_Recording_Interface main.m

%BinaryToWav
%Directly on computer:
mcc -e -d 'C:\Ultrasonic Recording Program' -o BinaryToWav BinaryToWav.m
%At home:
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\BinaryToWav' -o BinaryToWav BinaryToWav.m

%Downsampler
%At home: 
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\Downsampler' -o DownsamplerForWAVs Downsampler.m

%convertWav32to24Bit:
%At home:
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\32 to 24 Bit Converter' -o Converter_32_to_24_Bit convertWav32to24Bit.m