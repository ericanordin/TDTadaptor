classdef RecordScreen < GUIFiles.GUI
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %To do:
    %Enable 'go back' option
    %Disable 'New Recording' button when actively recording or saving.
    %Disable Time Remaining when continuous=1
    %Find out how scaling factor applies
    
    
    properties
        guiF;
        fileName; %The name of the recording
        fileNameButton; %Push button that opens saving GUI
        fileNameEditable; %Edit field that displays the fileName and allows 
        %the user to edit it when clicked.
        startingPathway; %What location to open the dialog box at when 
        %fileNameButton is pressed.
        continuous; %Boolean expression of whether the recording is continuous.
        %recordTime is disabled when it is 1 and enabled when it is 0.
        continousToggle;
        bitDepth;
        bitDepthSelect;
        scaling;
        scalingEditable;
        advancedButton; %Displays advanced options
        startStop; %Pushbutton that changes between "Start Recording" and 
        %"Stop Recording" and toggles the microphone and recordStatus.
        recordStatus; %1 = recording; 0 = not recording
        recordTime;
        recordTimeEditable;
        timeRemaining;
        timeRemainingDisplay;
        statusWindow;
        waveformDisplay; %Shows the waveform corresponding to the real-time
        %recording.
        spectrogramDisplay; %Shows the spectrogram corresponding to the
        %real-time recording.
        newRecord; %Brings user back to EntryScreen.
    end
    
    methods
        function this = RecordScreen()
            import StandardFunctions.setNameManual;
            bitDepth = 24;
            scaling = 10;
            recordTime = 600;
            fileName = '';
            startingPathway = 'C:\';
            recordStatus = 0;
            timeRemaining = recordTime;
            
            guiF = figure('Name', 'Ready to Record', 'NumberTitle', 'off',...
                'Position', [100 100 1000 1000], 'ToolBar', 'none',...
                'MenuBar', 'none');
            fileNameButton = uicontrol('Style', 'pushbutton', 'Position',...
                [50 900 100 80], 'String', 'File Name', 'Callback',...
                {@setNameManual, startingPathway});
            fileNameEditable = uicontrol('Style', 'edit', 'Position',...
                [170 900 780 80], 'String', fileName);
            advancedButton = uicontrol('Style', 'pushbutton', 'Position',...
                [50 800 200 80], 'String', 'Advanced Options', 'Callback',...
                @AdvancedWindow);
            startStop = uicontrol('Style', 'pushbutton', 'Position', ...
                [60 700 180 80]);
            if recordStatus == 0
                set(startStop, 'String', 'Start Recording', 'BackgroundColor',...
                    [0.5 1 0.5]);
            else
                set(startStop, 'String', 'Stop Recording', 'BackgroundColor',...
                    [0.8 0.1 0.1]);
            end
            uicontrol('Style', 'text', 'Position', [50 600 100 80], ...
                'String', 'Time Remaining:');
            timeRemainingDisplay = uicontrol('Style', 'text',...
                'Position', [150 600 100 80], 'String', timeRemaining,...
                'BackgroundColor', [0.85 0.85 0.85]);
            uicontrol('Style', 'text', 'Position', [50 150 100 80],...
                'String', 'Status');
            statusWindow = uitable('Position', [170 50 800 250]);
            
            waveformDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Waveform Display (placeholder)', 'Position', ...
                [350 650 600 200]);
            spectrogramDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Spectrogram Display (placeholder)', 'Position', ...
                [350 350 600 200]);
            
            function AdvancedWindow(~, ~)
                advF = figure('Name', 'Advanced Options', 'NumberTitle', ...
                    'off', 'Position', [80 820 300 300], 'ToolBar', 'none',...
                    'MenuBar', 'none');
                    %Advanced options figure
                uicontrol('Style', 'text', 'Position', [20 260 200 20],...
                    'String', 'Continous Record', 'HorizontalAlignment',...
                    'left');
                continuousToggle = uicontrol('Style', 'checkbox',...
                    'Position', [220 260 20 20]);
                uicontrol('Style', 'text', 'Position', [20 230 200 20],...
                    'String', 'Scaling Factor', 'HorizontalAlignment',...
                    'left');
                scalingEditable = uicontrol('Style', 'edit', 'Position',...
                    [220 230 50 20], 'String', scaling);
                uicontrol('Style', 'text', 'Position', [20 200 200 20],...
                    'String', 'Bit Depth', 'HorizontalAlignment', 'left');
                bitDepthSelect = uicontrol('Style', 'popupmenu', 'Position',...
                    [220 200 50 20], 'String', {16, 24, 32}, 'Value', 2);
                switch bitDepth
                    case 16
                        set(bitDepthSelect, 'Value', 1);
                    case 24
                        set(bitDepthSelect, 'Value', 2);
                    case 32
                        set(bitDepthSelect, 'Value', 3);
                end
            end    
         
        end
        
        function display(guiobj)
        end
    end
    
end

