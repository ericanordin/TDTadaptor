function PlotBuffer(screen, buffObj, continuous)
%PlotBuffer Plots the saved buffer to the GUI as a waveform and spectrogram

if buffObj.totalReps == 0
    %Initial set-up
    
    %Waveform
    hold(screen.waveformAxes, 'on');
    buffObj.wavePlot = plot(buffObj.displaySampleRange, buffObj.builtBuffer,...
        'Parent', screen.waveformAxes, 'Color', 'b');
    hold(screen.waveformAxes, 'off');
    
    %Spectrogram
    hold(screen.spectrogramAxes, 'on');
    [~, f, t, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot = imagesc(t, f, 10*log10(p+eps), 'Parent', screen.spectrogramAxes);
    hold(screen.spectrogramAxes, 'off');
    
    specDB = colorbar;
    ylabel(specDB, 'dB');
    colormap('gray');
    
else
    %Shift range to display
    buffObj.displaySampleRange = buffObj.displaySampleRange +(buffObj.npts*buffObj.buffLength);
    
    %Change waveform data displayed
    buffObj.wavePlot.YData = buffObj.builtBuffer;
    buffObj.wavePlot.XData = buffObj.displaySampleRange;
    
    %Change spectrogram data displayed
    [~, ~, ~, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot.CData = 10*log10(p+eps);
    buffObj.specPlot.XData = buffObj.specPlot.XData + buffObj.buffLength;
end

%Set waveform x-tick to seconds
xScaleWave = get(screen.waveformAxes, 'XTick');
xScaleWave = xScaleWave./buffObj.npts;
set(screen.waveformAxes,'XTickLabel', xScaleWave);

%Set x-axis to show previous second of data
xlim([buffObj.totalReps*buffObj.buffLength (buffObj.totalReps+1)*buffObj.buffLength]);

pause(0.001); %Necessary for plot to appear on each iteration
end

