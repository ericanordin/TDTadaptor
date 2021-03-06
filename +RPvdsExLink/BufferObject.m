classdef BufferObject < handle & matlab.mixin.SetGetExactNames
    %BufferObject creates handle objects for passing information between
    %functions in AcquireAudio
    
    properties
        bufsPerSec; %The number of buffer chunks taken every second
        npts; %The maximum number of points that can be stored in the RPvdsEx SerialBuf
        bufpts; %The size of the half-buffer
        buffLength; %The number of seconds displayed at a time on the GUI
        displaySampleRange; %The currently displayed second range
        totalReps; %The number of times SaveBuffer and PlotBuffer have been run
        builtBuffer; %Array of buffer data
        wavePlot; %Waveform displayed on the main GUI
        specPlot; %Spectrogram displayed on the main GUI
    end
    
    methods
        function this = BufferObject(RP)
            this.bufsPerSec = 2;
            
            this.totalReps = 0;

            this.npts = RP.GetTagSize('dataout'); %Returns maximum number of accessible data points
            
            this.buffLength = 1; %1s buffer
            
            this.builtBuffer = zeros(1, this.npts*this.buffLength);
            
            % serial buffer will be divided into two buffers A & B (to prevent the risk
            % of data in the buffer being overwritten)
            this.bufpts = this.npts/2;
            
            this.displaySampleRange = 1:this.npts*this.buffLength;
            
            this.wavePlot = '';
            this.specPlot = '';
        end
    end
    
end

