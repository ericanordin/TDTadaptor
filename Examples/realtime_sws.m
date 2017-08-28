function realtime_sws(session,dostim)
global emgstate
global stimstate
global autoemg
global tbt
emgstate=0;
autoemg=0;
%
% realtime_rem(session,dostim)
%
% Acquires data from the cscObj streams in 'session' and detects REM.
% Detection is based on theta/delta/emg.
% When detected, events are logged in cheetah and stim is optionally
% delivered (if dostim > 0)
%

%[success, data, timeStamp, channelNumber, samplingFreq, nValidSamples,...
%        nRecordsReturned, nRecordsDropped ] = NlxGetNewCSCData(cscObj);

% Begin Initialization
srate = 2000;
if nargin < 2
    dostim = 1;
end

% set the epoch in seconds to use for measuring FFT, EMG
epoch = 3;

% threshold for REM detection (corresponds to value in bottom plot)
remthresh = 0.7;
remc = 0;

% stimulation variables
stimdur = 30; % duration of each stim chunk in seconds
% nstim = 20; % total number of stim chunks to deliver
stimon = 0; % is stim on right now
stimtot = 0; % total amount of stim time
delaytostim = 30; % seconds in state before stim is triggered
numbadpoints = 8; % allow this number of below thresh points
cumstim = 0; % cumulative stim time
maxstimtime = 1200; % cumulative amount of stim (sec) to deliver


% reset the horita display
%
% % % % % % foo = [char(27) '002500000000000000'];
% % % % % % fprintf(session.ser, '%s', foo);

% get stream obj, they should be in order: 'hc' 'ctx' 'emg'
obj1 = session.obj{1};
obj2 = session.obj{2};
obj3 = session.obj{3};

% buffer for eeg and emg data.  will act like fifo
bufsize = floor(srate*epoch);
buf = zeros(1,bufsize); 
emgbuf = zeros(1,bufsize);
ctxbuf = zeros(1,bufsize);
t = (1/srate:1/srate:bufsize/srate); % time axis for eeg plot
pow = zeros(1,600); % 5 min of power measurements
pmv = zeros(1,600);
remevent = [];

% constants for theta and alpha indexing of fft 
f = myfft(zeros(1,bufsize),srate);
itheta = f>5.5 & f<10; % 5-10 Hz
idelta = f>0.5 & f<5; % 1-5 Hz
ideltastim = f>1.5 & f<5; % when stim is on avoid stim freq 0.8 Hz
iemg1 = false(1,length(f));
for i = 1:size(session.emg1,1)
    iemg1 = iemg1 | (f>=session.emg1(i,1) & f<=session.emg1(i,2));
end
iemg2 = false(1,length(f));
for i = 1:size(session.emg2,1)
    iemg2 = iemg2 | (f>=session.emg2(i,1) & f<=session.emg2(i,2));
end

%window for fft
win = hann(bufsize)';

% make figure window and axes
% figure('position', [25 52 938 1053]);
% hEEG = subplot(5,1,1, 'position', [.07 .86 .9 .1]); box on;
% set(hEEG, 'ylim', [-1e4 1e4]); 
% hEMG = subplot(5,1,2, 'position', [.07 .715 .9 .1]); box on;
% set(hEMG,'ylim',[-1e4 1e4]);
% hMV = subplot(5,1,3, 'position', [.07 .5 .9 .18]); box on;
% box on; hold on; set(gca,'xlim',[0 600]); %axis([0 600 200 2000]);
% set(hMV, 'xtick', (60:60:600), 'xticklabel', (.5:.5:5), 'xlim', [0 600]);
% set(hMV, 'ylim', [0.8 100], 'yscale', 'log'); title('EMG power')
% hFFT = subplot(5,1,4, 'position', [.07 .28 .9 .18]); box on;
% hdot = subplot(5,1,5, 'position', [.07 .05 .9 .18]); title('SWS detector')
% box on; hold on; axis([0 600 0 1]);
% set(hdot, 'xtick', (60:60:600), 'xticklabel', (.5:.5:5));
% plot(hdot, [0 600], [remthresh remthresh], 'k--')
% ixps = f<30;
% End Initialization
figg=figure('position', [525 50 1348 1023]);

hEEG = subplot(5,1,1, 'position', [.06 1.2 .9 .1]); box on;
set(hEEG, 'ylim', [-1e4 1e4]); % ylabel('HPC-EEG'); 

hEMG = subplot(5,1,2, 'position', [.06 .725 .9 .1]); box on; ylabel('EMG');

hMV = subplot(5,1,3, 'position', [.06 .5 .9 .18]);   
box on; hold on; set(gca,'xlim',[0 600]); %axis([0 600 200 2000]);
set(hMV, 'xtick', (60:60:600), 'xticklabel', (.5:.5:5), 'xlim', [0 600]);
set(hMV, 'ylim', [0.8 200], 'yscale', 'log'); ylabel('EMG power'); box on;

uicontrol(figg,'Style','checkbox',...
                'BackgroundColor',[0.95 0.95 0.95],...
                'String','MANUAL EMG',...
                'Callback',@checkbox1_Callback,...
                'Value',0,'position',[1050 630 100 30]); % checkbox1_Callback is a function
            
tbt=uicontrol(figg,'Style','togglebutton',...
                'BackgroundColor',[0.95 0.95 0.95],...
                'String','AUTO','Visible', 'Off',...
                'Callback',@togglebutton_Callback,...
                'Value',0,'position',[1050 650 100 30]);     % togglebutton_Callback is a function      
% 
% tbs=uicontrol(figg,'Style','togglebutton',...
%                 'BackgroundColor',[0.95 0.95 0.95],...
%                 'String','AUTO','Visible', 'On',...
%                 'Callback',@togglebutton_s_Callback,...
%                 'Value',0,'position',[1050 250 100 30]);     % togglebutton_Callback is a function      
%        

hFFT = subplot(5,1,4, 'position', [.06 .28 .9 .18]); box on; ylabel('Freq Power:HPC');

hdot = subplot(5,1,5, 'position', [.06 .05 .9 .18]); ylabel('SWS detector');
box on; hold on; axis([0 600 0 1]);
set(hdot, 'xtick', (60:60:600), 'xticklabel', (.5:.5:5));
plot(hdot, [0 600], [remthresh remthresh], 'k--')
ixps = f<30;

idot = 1;
nbad = 0;
stimcount = 0;
while 1
    [success, data, timestamp, ~, ~, ~, ~, ~] = NlxGetNewCSCData(obj1);
    [success, ctx, ~, ~, ~, ~, ~, ~] = NlxGetNewCSCData(obj2);
    [success, emg, ~, ~, ~, ~, ~, ~] = NlxGetNewCSCData(obj3);
    if ~success
        fprintf(1, 'Failed to get CSC data.\nExiting.\n');
        break;
    end
    % make sure length of data is okay
    ddata = double(data);
    demg = double(emg);
    dctx = double(ctx);
    len = length(data);
    if len < bufsize
        buf = [buf(len+1:end) ddata];
    elseif len == bufsize
        buf = ddata;
    else
        buf = ddata(len-bufsize+1:len);
    end
    len = length(demg);
    if len < bufsize
        emgbuf = [emgbuf(len+1:end) demg];
    elseif len == bufsize
        emgbuf = demg;
    else
        emgbuf = demg(len-bufsize+1:len);
    end
    len = length(dctx);
    if len < bufsize
        ctxbuf = [ctxbuf(len+1:end) dctx];
    elseif len == bufsize
        ctxbuf = dctx;
    else
        ctxbuf = dctx(len-bufsize+1:len);
    end
    
    % calculate FFT and power ratio of hc,ctx,emg signal
    [f,p] = myfft(buf.*win, srate);
    theta = sum(p(itheta));
    if stimon
        delta = sum(p(ideltastim))*2;
    else
        delta = sum(p(idelta));
    end
    ff = f(ixps);
    pp = p(ixps);
    pp = pp / max(pp);
    [~,p] = myfft(ctxbuf.*win,srate);
    if stimon
    pctx = sum(p(ideltastim)) / sum(p(itheta)) / 10;
    else
    pctx = sum(p(idelta)) / sum(p(itheta)) / 10;
    end
    [f,p] = myfft(emgbuf,srate);
  
    if (autoemg==1 && emgstate==1)
      pmv(idot) = 1;
    elseif (autoemg==1 && emgstate==0)
      pmv(idot) = 100;
    else
      pmv(idot) = sum(p(iemg2)) / sum(p(iemg1)) + 1;  
    end

    % calculate SWS power
    pow(idot) = delta / theta / pmv(idot) * session.scale; 
   
    %[delta/theta   pmv(idot)] % parameters must be comparable during SWS;
    %ratio of low EMG power to high EMG power; set pmv(idot) to what it is for
    %every rat; may be 1 or 10 or whetever in between
    
    %fprintf('%f\n',pow(idot));
    if pow(idot) > 1
        pow(idot) = 1;
    end
%     
%    if (stimstate==1)
%     fprintf(session.ard,'%s',session.stimpar); % turn on stimulation  
%     manualstim =1;
%    else
%      fprintf(session.ard,'%s','x'); % turn off stimulation  
%      manualstim=0;
%     end 
%     
    % do the plotting
     plot(hEEG, t, buf); ylabel('HPC-EEG');
    set(hEEG,'yaxislocation','right');
      lh=ylabel('HPC-EEG','fontsize',12);
     p=get(lh,'position');
     set(hEEG,'yaxislocation','left');
     set(lh,'position',p);

     
     plot(hEMG, t, emgbuf); ylabel('EMG');
    hold(hFFT,'off'); plot(hFFT, ff, pp); ylabel('Freq power HPC');
% rngemg=100; hold(hFFT,'on'); plot(hFFT, f(f<rngemg), p(f<rngemg)/max(p(f<rngemg)),'r');    hold(hFFT,'off');
    plot(hMV, idot, pmv(idot), 'bo', 'markerfacecolor', 'b'); ylabel('EMG power');
    htheta = plot(hdot,idot,pow(idot),'o','markerfacecolor','b'); ylabel('SWS detector');
    drawnow
    
    if dostim && cumstim < maxstimtime
        %check if in SWS and stimulate if necessary
        if pow(idot) > remthresh
            set(htheta, 'markerfacecolor', 'r'); drawnow;
            if idot > 300
                remevent(end+1) = idot-300;
            end
            if ~stimon && cumstim < maxstimtime && remc > delaytostim*2
                NlxSendCommand('-PostEvent "stimon" 0 0');
                fprintf(session.ard,'%s',session.stimpar); % turn on stimulation
                stimon = 1;
                tic;
                fprintf('Stim on at %.0f\n', timestamp(end));
            end
            remc = remc + 1;
            nbad = 0;
        else
            if nbad < numbadpoints
                nbad = nbad + 1;
                remc = remc + 1;
            else
                if stimon 
                    fprintf(session.ard,'%s','x'); % turn off stimulation
                    NlxSendCommand('-PostEvent "stimoff" 0 0');
                    fprintf('Stim off at %.0f\n', timestamp(end));
                    stimtot = stimtot + toc;
                    cumstim = cumstim + toc;
                    fprintf('%.1f %% of stim done\n', stimtot/stimdur*100);
                    stimon = 0;
                    stimcount = stimcount + 1;
                end
                remc = 0;
                nbad = 0;
            end
        end
        
        if stimon && (stimtot+toc > stimdur || cumstim+toc > maxstimtime)
            fprintf(session.ard,'%s','x'); % turn off stimulation
            NlxSendCommand('-PostEvent "stimoff" 0 0');
            fprintf('Stim off at %.0f\n', timestamp(end));
            stimon = 0;
            stimcount = stimcount + 1;
            remc = 0;
            stimtot = 0;
            cumstim = cumstim + toc;
            fprintf('Stim finished %u\n',stimcount);
        end
    end
    
    % redo dot-plot buffers if necessary
    if idot == 600
        idot = 301;
        pow = [pow(301:600) zeros(1,300)];
        delete(get(hdot, 'children'));
        plot(hdot, [0 600], [remthresh remthresh], 'k--');
        plot(hdot, pow(1:300), 'o', 'markerfacecolor', 'b');
        % htheta = plot(hdot, 300, pow(300), 'o', 'markerfacecolor', 'b');
        if ~isempty(remevent)
            plot(remevent,pow(remevent),'o','markerfacecolor','y');
            remevent = [];
        end
        pmv = [pmv(301:600) zeros(1,300)];
        delete(get(hMV, 'children'));
        plot(hMV, pmv(1:300), 'bo', 'markerfacecolor', 'b');
    else
        idot = idot + 1;
    end
    
    %send timestamp out of serial port
% % % % %     serstr = [char(27) sprintf('0028000%.0f', timestamp(end))];
% % % % %     fprintf(session.ser, '%s', serstr);
     pause(.5);
end

