function SaveBuffer(RP, curindex, buffObj, fnoise, screen)
%SAVEBUFFER Takes in and saves information through the microphone
%   Used to prevent redundancy in the for/while loops in AcquireAudio
%   This is a double-buffering function. Data is stored in a buffer halfway
%   through and the buffer is saved while the next buffer is written to,
%   prevening overwrite.
%   For details on ReadTagVEX see TDT's ActiveX Reference Manual pg 50 (pdf pg 58).

recordObj = get(screen, 'recordObj');
import StandardFunctions.addToStatus

chunkRep = 0; %Tracks how many buffer sections have been saved

while chunkRep < buffObj.buffLength*buffObj.bufsPerSec    
    while(curindex < buffObj.bufpts) %Wait until section A of buffer is complete        
        curindex = RP.GetTagVal('index');
        pause(.05);
    end
    
    %Read segment A
    noise = RP.ReadTagVEX('dataout', 0, buffObj.bufpts, ...
        recordObj.readFormat, recordObj.readFormat, 1);
    if buffObj.totalReps == 0
        gettingSound = 0;
        %Check that the microphone is getting input on first buffer
        for bufferPoint = 1:length(noise)
            if noise(bufferPoint) < 0.01 || noise(bufferPoint) > 0.02
                %When the microphone is turned off but the buffer is
                %running, it outputs junk data within the 0.01-0.02 range.
                %Any actual sound should produce data outside of this
                %range.
                gettingSound = 1;
                break;
            end
        end
        if gettingSound == 0
            addToStatus('Microphone not connected', screen);
            error('No sound');
        end
    end
    fwrite(fnoise, noise./recordObj.reductionFactor, recordObj.valuePrecision); 
    %Write section A to binary file
    
    buffObj.builtBuffer(1, (1 + chunkRep*buffObj.bufpts):(buffObj.bufpts + buffObj.bufpts*chunkRep)) = noise(1:buffObj.bufpts);
    %Adds buffer data to growing vector for waveform and spectrogram
    %display
    
    chunkRep = chunkRep + 1;
    
    % checks to see if the data transfer rate is fast enough
    curindex = RP.GetTagVal('index');

    if(curindex < buffObj.bufpts)
        addToStatus('Warning: Transfer rate is too slow', screen);
    end
    
    while(curindex > buffObj.bufpts) %Wait until section B is complete
        curindex = RP.GetTagVal('index');
        pause(.05); 
    end
    
    %Read segment B
    noise = RP.ReadTagVEX('dataout', buffObj.bufpts, buffObj.bufpts, ...
        recordObj.readFormat, recordObj.readFormat, 1);
    
    fwrite(fnoise, noise./recordObj.reductionFactor, recordObj.valuePrecision);
    %Write section B to binary file
    
    buffObj.builtBuffer(1, (1 + chunkRep*buffObj.bufpts):(buffObj.bufpts + buffObj.bufpts*chunkRep)) = noise(1:buffObj.bufpts);
    %Adds buffer data to growing vector for waveform and spectrogram
    %display
    
    chunkRep = chunkRep + 1;
    
    
    curindex = RP.GetTagVal('index');
    
    % Check that section B has not begun recording before writing completed
    if(curindex > buffObj.bufpts)
        warning('Transfer rate too slow');
        addToStatus('Warning: Transfer rate is too slow', screen);
    end
    
    if screen.recordObj.continuous == 0
        decrementTime(screen);
    else
        incrementTime(screen);
    end
end

end

