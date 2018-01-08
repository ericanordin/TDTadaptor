function SaveBuffer(RP, curindex, buffObj, fnoise, screen)
%SAVEBUFFER Takes in and save information through the microphone
%   Used to prevent redundancy in the for/while loops in AcquireAudio

recordObj = get(screen, 'recordObj');
import StandardFunctions.addToStatus

chunkRep = 0;
while chunkRep < buffObj.buffLength*buffObj.bufsPerSec    
    % wait until done writing A
    while(curindex < buffObj.bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05); %May be unnecessary
    end
    
    % read segment A
    %See pdf pg 58 for ReadRagVEX
    %May only be able to store data in 16-bit or 32-bit
    %noise = RP.ReadTagVEX('dataout', 0, buffObj.bufpts, ...
    %    recordObj.readFormat, recordObj.readFormat, 1);
    noise = RP.ReadTagVEX('dataout', 0, buffObj.bufpts, ...
        recordObj.readFormat, recordObj.readFormat, 1);
    if buffObj.totalReps == 0
        %disp('In first rep check');
        gettingSound = 0;
        %Check that the microphone is getting input
        %disp(noise);
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
            %Throw error
        end
    end
    %fwrite(fnoise, noise, recordObj.valuePrecision);
    Recording.scaleAndSave(fnoise, noise, recordObj);
    
    buffObj.builtBuffer(1, (1 + chunkRep*buffObj.bufpts):(buffObj.bufpts + buffObj.bufpts*chunkRep)) = noise(1:buffObj.bufpts);
    %disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);
    %pdf pg 66: SendSrcFile. May be necessary for .wav
    
    chunkRep = chunkRep + 1;
    % checks to see if the data transfer rate is fast enough
    curindex = RP.GetTagVal('index');
    %disp(['Current buffer index: ' num2str(curindex)]);
    if(curindex < buffObj.bufpts)
        warning('Transfer rate is too slow');
        addToStatus('Warning: Transfer rate is too slow', screen);
    end
    
    % wait until start writing A
    while(curindex > buffObj.bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05); %May be unnecessary
    end
    
    % read segment B
    
    %noise = RP.ReadTagVEX('dataout', buffObj.bufpts, buffObj.bufpts, ...
    %    recordObj.readFormat, recordObj.readFormat, 1);
    noise = RP.ReadTagVEX('dataout', buffObj.bufpts, buffObj.bufpts, ...
        recordObj.readFormat, recordObj.readFormat, 1);
    %fwrite(fnoise, noise, recordObj.valuePrecision);
    Recording.scaleAndSave(fnoise, noise, recordObj);
    buffObj.builtBuffer(1, (1 + chunkRep*buffObj.bufpts):(buffObj.bufpts + buffObj.bufpts*chunkRep)) = noise(1:buffObj.bufpts);
    %disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);
    
    chunkRep = chunkRep + 1;
    
    % make sure we're still playing A
    curindex = RP.GetTagVal('index');
    %disp(['Current index: ' num2str(curindex)]);
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

