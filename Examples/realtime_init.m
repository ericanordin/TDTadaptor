function session = realtime_init(rat)
%
% session = realtime_init(rat)
%
% Initializes cheetah realtime and opens data streams.  Also opens arduino
% serial port and com1 for timestamp.
% 
% rat is number of rat (determines which streams to use)
%
% returns structure session which contains serial port and stream info
%

switch rat
    case 11
        session.obj = {'HPC2'; 'CTX2'; 'EMG1'};
        session.scale = 0.7; %set is to 70 to catch all sws (may catch few REM)
        session.emg1 = [20 40];
        session.emg2 = [300 400];
        session.stimpar = 'sf12;a255;';  
 
    case 12
        session.obj = {'HPC2'; 'CTX2'; 'EMG1'};
        session.scale = 0.8;
        session.emg1 = [15 30];
        session.emg2 = [100 200];
        session.stimpar = 'sf12;a255;'; % for SWS
     
    case 13
        session.obj = {'HPC1'; 'CTX3'; 'EMG2'};
        session.scale = 0.7;
        session.emg1 = [20 40];
        session.emg2 = [300 400];
        session.stimpar = 'sf12;a255;';
     
    case 14
        session.obj = {'HPC2'; 'CTX2'; 'EMG2'};
        session.scale = 0.7;
        session.emg1 = [20 40];
        session.emg2 = [300 400];
        session.stimpar = 'sf12;a255;';
%      case 5
%          % EMG calibrated
%          % everything is calibrated
%         session.obj = {'HPC2'; 'PFC1'; 'EMG1'};% others not proper
%         session.scale = 0.47; %set is to 70 to catch all sws (may catch few REM)
%          session.emg1 = [20 40];
%         session.emg2 = [200 400];
%         session.stimpar = 'sf0.5;a48;';  % Calibrated
    otherwise

end

server = '142.66.96.116'; % IP of cheetah-ep1161
appName = 'EEG analysis';

fprintf('Connecting to server: %s\n', server);
success = NlxConnectToServer(server);
if success ~= 1
    fprintf('Failed to connect to server.\nExiting.\n');
    return;
else
    fprintf('Connected successfully\n');
end

fprintf('Setting application name: %s\n', appName);
success = NlxSetApplicationName('EEG analysis');
if success ~= 1
    fprintf('Could not set application name, continuing...\n');
end

fprintf('Getting list of Cheetah objects...\n');
[success, cheetahObjects, ~] = NlxGetCheetahObjectsAndTypes;
if success ~= 1
    fprintf(1, 'Failed to get list. Exiting.\n');
    NlxDisconnectFromServer();
    return;
end

nObj = length(cheetahObjects);
for i = 1:length(session.obj)
    fprintf('Finding object %s ...\n', session.obj{i});
    iCSC = 1;
    while iCSC <= nObj && ~strcmp(session.obj{i}, char(cheetahObjects(iCSC)))
        iCSC = iCSC + 1;
    end
    if iCSC > nObj
        fprintf(1, 'Could not find %s. Exiting.\n', session.obj{i});
        NlxDisconnectFromServer();
        return;
    end
    
    fprintf(1, 'Found %s, opening stream...\n', session.obj{i});
    success = NlxOpenStream(cheetahObjects(iCSC));
    if ~success
        fprintf(1, 'Could not open stream.\n');
    end
end

% fprintf(1, '\nOpening serial port...\n');
% session.ser = serial('com1');
% fopen(session.ser);
% if ~strcmp(session.ser.status,'open')
%     fprintf(1, 'Could not open serial port.\n');
% end
% 
fprintf(1, '\nOpening arduino serial port...\n');
session.ard = serial('com3','baudrate',115200);
fopen(session.ard);
if ~strcmp(session.ard.status,'open')
    fprintf(1, 'Could not open arduino serial port.\n');
 end