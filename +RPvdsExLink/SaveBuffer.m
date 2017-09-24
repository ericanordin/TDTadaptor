function SaveBuffer(RP, curindex, buffObj, fnoise, screen)
%SAVEBUFFER Takes in and save information through the microphone
%   Used to prevent redundancy in the for/while loops in AcquireAudio

import StandardFunctions.addToStatus
for chunkSecond = 0:(buffObj.buffLength-1)
    
    % wait until done writing A
    while(curindex < buffObj.bufpts)
        curindex = RP.GetTagVal('index');
        pause(.05); %May be unnecessary
    end
    
    % read segment A
    %See pdf pg 58 for ReadRagVEX
    %May only be able to store data in 16-bit or 32-bit
    noise = RP.ReadTagVEX('dataout', 0, buffObj.bufpts, 'F32', 'F32', 1);
    fwrite(fnoise,noise,'float32');
    buffObj.builtBuffer(1, (1 + chunkSecond*buffObj.npts):(buffObj.npts/2 + buffObj.npts*chunkSecond)) = noise(1:buffObj.npts/2);
    %disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);
    %pdf pg 66: SendSrcFile. May be necessary for .wav
    
    
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
    
    noise = RP.ReadTagVEX('dataout', buffObj.bufpts, buffObj.bufpts, 'F32', 'F32', 1);
    fwrite(fnoise,noise,'float32');
    buffObj.builtBuffer(1, (1 + chunkSecond*buffObj.npts):(buffObj.npts/2 + buffObj.npts*chunkSecond)) = noise(1:buffObj.npts/2);
    %disp(['Wrote ' num2str(fwrite(fnoise,noise,'float32')) ' points to file']);
    
    % make sure we're still playing A
    curindex = RP.GetTagVal('index');
    %disp(['Current index: ' num2str(curindex)]);
    if(curindex > buffObj.bufpts)
        warning('Transfer rate too slow');
        addToStatus('Warning: Transfer rate is too slow', screen);
    end
    decrementTime(screen);
end

end

