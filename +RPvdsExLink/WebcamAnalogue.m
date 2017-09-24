function WebcamAnalogue(screen)
import StandardFunctions.addToStatus;
% For attempting the version in which the graphs reset with a new
% buffer after a specified amount of repetitions.

%Set up to plot to screen axes

%import GUIFiles.RecordScreen

%clear all; clc;

%delete(findall(0, 'Type', 'figure'));

recordObj = get(screen, 'recordObj');
%get(recordObj); %Variables are appearing correctly, but the program doesn't
%accept the following calls:
%waitfor(recordObj, recordObj.recordStatus, 1);
%waitfor(recordObj, recordStatus, 1);

% size of the entire serial buffer
npts = 200000; %sampling frequency
buffLength = 2; %2s buffer
buffReps = ceil(recordObj.recordTime/buffLength); 
%Rounds up if not divisible by buffLength
builtBuffer = zeros(1, npts*buffLength);

% serial buffer will be divided into two buffers A & B (to prevent the risk
% of data in the buffer being overwritten)
bufpts = npts/2;

rec1 = audiorecorder(npts, 24, 1);
rec2 = audiorecorder(npts, 24, 1);

%recordObj = get(screen, 'recordObj');
%waitfor(recordObj, recordStatus, 1);

% begin acquiring
curindex = rec1.CurrentSample;

%waveFig = figure(1);
%set(waveFig, 'Name', 'Waveform');

%specFig = figure(2);
%set(specFig, 'Name', 'Spectrogram (Modified)');

displaySampleRange = 1:npts*buffLength;
%addToStatus('Recording...', screen);
%pause(0.00001);
% main looping section
tic;
for totalReps = 0:(buffReps-1)
    disp('New rep');
    for chunkSecond = 0:(buffLength-1)
        
        record(rec1);
        
        while(curindex < bufpts)
            curindex = rec1.CurrentSample;
        end
        
        
        record(rec2); %Start new recording as quickly as possible to minimize
        %intermittent data loss.
        
        stop(rec1);
        
        curindex = 0;
        
        %record captures extra samples before it has time to stop
        %Won't be a problem using TDT buffer
        samples1 = getaudiodata(rec1)';
        builtBuffer(1, (1 + chunkSecond*npts):(npts/2 + npts*chunkSecond)) = samples1(1:npts/2);
        
        while(curindex < bufpts)
            curindex = rec2.CurrentSample;
        end
        
        stop(rec2);
        
        curindex = 0;
        samples2 = getaudiodata(rec2)';
        builtBuffer(1, (1 + chunkSecond*npts + npts/2):(npts*(chunkSecond+1))) = samples2(1:npts/2);
        
        %Update remaining seconds
        decrementTime(screen);
    end
    
    
    
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
end
toc;
%screen.PressStartStop();
stopRecord(screen);
end

