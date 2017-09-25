function PlotBuffer(screen, buffObj, continuous)
%PlotBuffer Plots the saved buffer to the GUI
if buffObj.totalReps == 0
    hold(screen.waveformAxes, 'on');
    buffObj.wavePlot = plot(buffObj.displaySampleRange, buffObj.builtBuffer,...
        'Parent', screen.waveformAxes, 'Color', 'b');
    hold(screen.waveformAxes, 'off');

    hold(screen.spectrogramAxes, 'on');
    [~, f, t, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot = imagesc(t, f, 10*log10(p+eps), 'Parent', screen.spectrogramAxes);%log10(abs(s)));
    hold(screen.spectrogramAxes, 'off');

    specDB = colorbar;
    ylabel(specDB, 'dB');
    colormap('gray');
    
else
    buffObj.displaySampleRange = buffObj.displaySampleRange +(buffObj.npts*buffObj.buffLength);
    
    buffObj.wavePlot.YData = buffObj.builtBuffer;
    buffObj.wavePlot.XData = buffObj.displaySampleRange;
    
    [~, ~, ~, p] = spectrogram(buffObj.builtBuffer, 1024, 256, [], buffObj.npts, 'yaxis');
    buffObj.specPlot.CData = 10*log10(p+eps);
    buffObj.specPlot.XData = buffObj.specPlot.XData + buffObj.buffLength;
end

xScaleWave = get(screen.waveformAxes, 'XTick');
xScaleWave = xScaleWave./buffObj.npts;
set(screen.waveformAxes,'XTickLabel', xScaleWave);

xlim([buffObj.totalReps*buffObj.buffLength (buffObj.totalReps+1)*buffObj.buffLength]);% 0 80000]);

pause(0.001); %Necessary for plot to appear on each iteration

if continuous == 1
    buffObj.totalReps = buffObj.totalReps + 1;
end
end

