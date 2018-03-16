%Commands to run from the master TDTadaptor directory to compile
%various executables. Save location varies based on where the TDTadaptor 
%directory is locally stored.

%Ultrasonic_Recording_Interface
%On ultrasonic recording PC:
mcc -e -d 'C:\Ultrasonic Recording Program' -o Ultrasonic_Recording_Interface main.m
%At home:
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\Ultrasonic_Recording_Interface' -o Ultrasonic_Recording_Interface main.m

%BinaryToWav
%On ultrasonic recording PC:
mcc -e -d 'C:\Ultrasonic Recording Program' -o BinaryToWav BinaryToWav.m
%At home:
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\BinaryToWav' -o BinaryToWav BinaryToWav.m

%Downsampler
%At home: 
mcc -e -d 'G:\Fall 2017 Co-op\TDTadaptor\Executables and Key Files\Downsampler' -o DownsamplerForWAVs Downsampler.m
