function PlotBuffer(screen, displaySampleRange, builtBuffer, buffLength, npts, totalReps, continuous)
%PlotBuffer Plots the saved buffer to the GUI
    if totalReps == 0
        wavePlot = plot(displaySampleRange, builtBuffer, 'Parent', screen.waveformAxes);
        
        title(screen.waveformAxes, 'Waveform');
        xlabel(screen.waveformAxes, 'Seconds');
        ylabel(screen.waveformAxes, 'Scaled Amplitude (+/-1 is Max)');
        
        %figure(2);
        [~, f, t, p] = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
        specPlot = imagesc(t, f, 10*log10(p+eps), 'Parent', screen.spectrogramAxes);%log10(abs(s)));
        
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
        displaySampleRange = displaySampleRange +(npts*buffLength);
        
        %figure(1);
        wavePlot.YData = builtBuffer;
        wavePlot.XData = displaySampleRange;
        
        %figure(2);
        [~, ~, ~, p] = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
        specPlot.CData = 10*log10(p+eps);
        specPlot.XData = specPlot.XData + buffLength;
    end
    
    %screen.waveformAxes.XAxis.Exponent = 0;
    
    
    xScaleWave = get(screen.waveformAxes, 'XTick');
    xScaleWave = xScaleWave./npts;
    set(screen.waveformAxes,'XTickLabel', xScaleWave);
    
    %figure(1);
    %waveAxes = waveFig.CurrentAxes;
    
    
    %{
    xScaleSpec = get(screen.spectrogramAxes, 'XTick');
    xScaleSpec = xScaleSpec./npts;
    set(screen.spectrogramAxes,'XTickLabel', xScaleSpec);
    %}
    %figure(2);
    xlim([totalReps*buffLength (totalReps+1)*buffLength]);% 0 80000]);
    
    pause(0.001); %Necessary for plot to appear on each iteration
    
    if continuous == 1
        totalReps = totalReps + 1;
    end
end

