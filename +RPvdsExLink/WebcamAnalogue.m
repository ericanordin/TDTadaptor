function WebcamAnalogue(screen)
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

x = 1:npts*buffLength;

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
    end
    
    if totalReps == 0
        wavePlot = plot(x, builtBuffer, 'Parent', screen.waveformAxes);
        
        title('Waveform');
        xlabel('Seconds');
        ylabel('Scaled Amplitude (+/-1 is Max)');
        
        %figure(2);
        [~, f, t, p] = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
        specPlot = imagesc(t, f, 10*log10(p+eps), 'Parent', screen.spectrogramAxes);%log10(abs(s)));
        
        ylim([0 80000]);
        %specAxes = specFig.CurrentAxes;
        %yScale = get(specAxes, 'YTick');
        yScale = get(screen.spectrogramAxes, 'YTick');
        yScale = yScale./1000;
        set(screen.spectrogramAxes, 'Ydir', 'Normal', 'YTickLabel', yScale);
        
        title('Spectrogram');
        xlabel('Seconds');
        ylabel('Frequency (kHz)');
        specDB = colorbar;
        ylabel(specDB, 'dB');
        colormap('gray');
        
    else
        x = x +(npts*buffLength);
        
        %figure(1);
        wavePlot.YData = builtBuffer;
        wavePlot.XData = x;
        
        %figure(2);
        [~, ~, ~, p] = spectrogram(builtBuffer, 1024, 256, [], npts, 'yaxis');
        specPlot.CData = 10*log10(p+eps);
        specPlot.XData = specPlot.XData + buffLength;
    end
    
    
    %figure(1);
    %waveAxes = waveFig.CurrentAxes;
    xScale = get(screen.spectrogramAxes, 'XTick');
    xScale = xScale./npts;
    set(screen.spectrogramAxes,'XTickLabel', xScale);
    
    figure(2);
    xlim([totalReps*buffLength (totalReps+1)*buffLength]);% 0 80000]);
    
    pause(0.001); %Necessary for plot to appear on each iteration
end
toc;
end

