function PlotBuffer(screen, buffObj, continuous)
%PlotBuffer Plots the saved buffer to the GUI
if buffObj.totalReps == 0
    buffObj.wavePlot = plot(buffObj.displaySampleRange, buffObj.builtBuffer, 'Parent', screen.waveformAxes);
    
    title(screen.waveformAxes, 'Waveform');
    xlabel(screen.waveformAxes, 'Seconds');
    ylabel(screen.waveformAxes, 'Scaled Amplitude (+/-1 is Max)');
    
    %figure(2);
    [~, f, t, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot = imagesc(t, f, 10*log10(p+eps), 'Parent', screen.spectrogramAxes);%log10(abs(s)));
    
    ylim([0 80000]);
    %specAxes = specFig.CurrentAxes;
    %yScale = get(specAxes, 'YTick');
    yScale = get(screen.spectrogramAxes, 'YTick');
    yScale = yScale./1000;
    set(screen.spectrogramAxes, 'Ydir', 'Normal', 'YTickLabel', yScale);
    
    title(screen.spectrogramAxes, 'Spectrogram');
    xlabel(screen.spectrogramAxes, 'Seconds');
    ylabel(screen.spectrogramAxes, 'Frequency (kHz)');
    specDB = colorbar;
    ylabel(specDB, 'dB');
    colormap('gray');
    
else
    buffObj.displaySampleRange = buffObj.displaySampleRange +(buffObj.npts*buffObj.buffLength);
    
    %figure(1);
    buffObj.wavePlot.YData = buffObj.builtBuffer;
    buffObj.wavePlot.XData = buffObj.displaySampleRange;
    
    %figure(2);
    [~, ~, ~, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot.CData = 10*log10(p+eps);
    buffObj.specPlot.XData = buffObj.specPlot.XData + buffObj.buffLength;
end

%screen.waveformAxes.XAxis.Exponent = 0;


xScaleWave = get(screen.waveformAxes, 'XTick');
xScaleWave = xScaleWave./buffObj.npts;
set(screen.waveformAxes,'XTickLabel', xScaleWave);

%figure(1);
%waveAxes = waveFig.CurrentAxes;


%{
    xScaleSpec = get(screen.spectrogramAxes, 'XTick');
    xScaleSpec = xScaleSpec./npts;
    set(screen.spectrogramAxes,'XTickLabel', xScaleSpec);
%}
%figure(2);
xlim([buffObj.totalReps*buffObj.buffLength (buffObj.totalReps+1)*buffObj.buffLength]);% 0 80000]);

pause(0.001); %Necessary for plot to appear on each iteration

if continuous == 1
    buffObj.totalReps = buffObj.totalReps + 1;
end
end

