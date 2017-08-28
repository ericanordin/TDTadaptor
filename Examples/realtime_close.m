function realtime_close(session)
%
% realtime_close(session)
%
% Closes the open data streams, serial ports and closes the connection
% to the cheetah realtime server
%
% 'sesssion' is the structure containing all the info



for i = 1:length(session.obj)
    success = NlxCloseStream(session.obj{i});
    if ~success
        fprintf(1, 'Failed to close %s.\n', session.obj{i});
    else
        fprintf(1, 'Closed  %s.\n', session.obj{i});
    end
end

% if strcmp(session.ser.status, 'open')
%     fprintf(1, 'Closing serial port...\n');
%     fclose(session.ser);
% end

if strcmp(session.ard.status, 'open')
    fprintf(1, 'Closing arduino port...\n');
    fclose(session.ard);
end

success = NlxDisconnectFromServer();
if success ~= 1
    fprintf(1, 'Failed to disconnect from server.\n');
else
    fprintf(1, 'Disconnected from server.\nExiting.\n');
end