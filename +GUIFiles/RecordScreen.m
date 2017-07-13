classdef RecordScreen < GUIFiles.GUI
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %To do:
    %Design GUI
    %Enable 'go back' option
    %Disable 'New Recording' button when actively recording or saving.
    
    
    properties
        guiF;
        fileName; %The name of the recording
        fileNameButton; %Push button that opens saving GUI
        fileNameEditable; %Edit field that displays the fileName and allows 
        %the user to edit it when clicked.
        continuous; %Boolean expression of whether the recording is continuous.
        %recordTime is disabled when it is 1 and enabled when it is 0.
        bitDepth;
        scaling;
        advancedButton; %Displays advanced options
        startRecord;
        stopRecord;
        timeRemaining;
        statusWindow;
        waveformDisplay; %Shows the waveform corresponding to the real-time
        %recording.
        spectrogramDisplay; %Shows the spectrogram corresponding to the
        %real-time recording.
        newRecord; %Brings user back to EntryScreen.
    end
    
    methods
        function this = RecordScreen()
            
        end
        
        function display(guiobj)
        end
    end
    
end

