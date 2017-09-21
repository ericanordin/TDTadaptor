classdef RecordScreen < handle & matlab.mixin.SetGetExactNames
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %To do:
    %Enable 'New Recording' button and exit figure when saving is complete.
    %Write destructor
    %Work out kinks from going back and forth between Auto and Manual
    %Offer option to save advanced settings
    %Remove bit depth options. Should be 32 bit floating point (if
    %there is no buffer issue).
    %Integrate plots and decrementTime into AcquireAudio
    %Make relevant output for Status window
    %Make pretty
    
    properties
        %% Figures:
        guiF; %Main figure
        advF; %Advanced options figure
        
        %% UIControl objects:
        fileNameAuto; %Push button that takes the user through LabScreen
        %(on first iteration only) and RatScreen (on every iteration).
        fileNameManual; %Push button that opens saving GUI
        fileNameEditable; %Edit field that displays the recordObj.wavName and allows
        %the user to edit it when clicked.
        continousToggle; %Checkbox that indicates whether the recording
        %will have a time limit
        bitDepthSelect; %Options 16, 24, and 32 bits
        advancedButton; %Displays advanced options
        startStop; %Pushbutton that changes between "Start Recording" and
        %"Stop Recording" and toggles the microphone and recordObj.recordStatus.
        recordTimeLabel; %Text that identifies recordTimeEditable
        recordTimeEditable; %Edit field corresponding to recordObj.recordTime variable
        timeRemainingLabel; %Text that identifies timeRemainingDisplay
        timeRemainingDisplay; %Edit field corresponding to timeRemaining variable
        statusWindow; %Displays text describing the background processes
        waveformAxes; %Shows the waveform corresponding to the real-time
        %recording.
        spectrogramAxes; %Shows the spectrogram corresponding to the
        %real-time recording.
        newRecord; %Resets to directory with no file name.
        
        %% Variables:
        recordObj; %The Recording class object
        startingPathway; %What location to open the dialog box at when
        %fileNameManual is pressed.
        timeRemaining;
        initiateNewTest; %0 = don't reset screen; 1 = reset screen
        labScr; %Holds the LabScreen object
        ratScr; %Holds the RatScreen object
        firstAuto; %1 = first auto save iteration; 0 = not first
        labName; %The name of the lab under which the experiment is being run
        errorColor; %The color which fields are changed to when their contents are invalid
        advCanClose; %1 = advanced settings window is permitted to close; 0 = not permitted
        statusText; %Saves all strings which have been printed to statusWindow
        
    end
    
    methods
        %% Function Descriptions:
        %RecordScreen: constructor
        %ManualSetName: Executes steps to assign the file name manually.
        %AutoSetName: Executes steps to assign the file name automatically.
        %AdvancedWindow: Opens window for advanced options.
        %TogContinuous: Interfaces between the recordObj.continuous variable and the
        %continuousToggle checkbox.
        %HideWindow: Makes window invisible
        %GetRecordTime: Interfaces between the recordObj.recordTime variable and the
        %recordTimeEditable field.
        %GetBitDepth: Interfaces between the recObj.bitDepth variable and
        %the bitDepthSelect pop up menu.
        
        %DeselectOnEnter: Changes location of the cursor away from the
        %currently selected edit field.
        %PressStartStop: Executes start/stop process based on the value of
        %recordObj.recordStatus.
        %PressNewTest: Triggers the while loop in main to restart by
        %interfacing with waitForNew.
        %CloseProgram: Exits the program
        %setFileName: Allows main to access recordObj.wavName
        %waitForNew: Resets RecordScreen GUI when New Recording is pressed.
        %stopRecord: Changes setting to halt the recording
        %decrementTime: Updates time remaining
        
        %% Function Code
        function this = RecordScreen()
            %% GUI Set Up
            import RPvdsExLink.Recording;
            %import RPvdsExLink.AcquireAudio;
            %import RPvdsExLink.WebcamAnalogue;
            this.recordObj = Recording();
            
            this.statusText = {};%{'First command'; 'Second command'; 'Third command'};
            
            
            %this.statusText = {char(pad("Command", this.statusWidth, 'both'))};
            %this.statusText = {['First command'], ['Second command'], ['Third command']};
            this.startingPathway = this.recordObj.wavName;
            this.timeRemaining = this.recordObj.recordTime;
            this.initiateNewTest = 0;
            this.labScr = ''; %isobject returns false
            this.ratScr = ''; %isobject returns false
            this.advF = ''; %isobject returns false
            this.firstAuto = 1;
            this.errorColor = [1 0.1 0.1];
            this.advCanClose = 1;
            
            
            this.guiF = figure('Name', 'Ready to Record', 'NumberTitle', 'off',...
                'Position', [100 100 1000 1000], 'ToolBar', 'none',...
                'MenuBar', 'none', 'CloseRequestFcn', @CloseProgram, 'Resize', 'off');
            
            this.fileNameAuto = uicontrol('Style', 'pushbutton', 'Position',...
                [50 950 200 40], 'String', 'Name File Automatically',...
                'Callback', @AutoSetName);
            
            this.fileNameManual = uicontrol('Style', 'pushbutton', 'Position',...
                [50 900 200 40], 'String', 'Name File Manually', 'Callback',...
                {@ManualSetName, 'via uigetdir'});
            
            this.fileNameEditable = uicontrol('Style', 'edit', 'Position',...
                [270 900 680 90], 'String', this.recordObj.wavName, 'Callback',...
                {@ManualSetName, 'no uigetdir'}, 'KeyPressFcn',...
                @DeselectOnEnter);%, 'BackgroundColor', this.errorColor);
            
            this.advancedButton = uicontrol('Style', 'pushbutton', 'Position',...
                [50 800 200 80], 'String', 'Advanced Options', 'Callback',...
                @AdvancedWindow);
            
            this.startStop = uicontrol('Style', 'pushbutton', 'Position', ...
                [60 700 180 80], 'String', 'Start Recording', 'BackgroundColor',...
                [0.5 1 0.5], 'Callback', @PressStartStop);
            
            this.timeRemainingLabel = uicontrol('Style', 'text', 'Position',...
                [50 600 100 80], 'String', 'Time Remaining:');
            
            this.timeRemainingDisplay = uicontrol('Style', 'text',...
                'Position', [150 600 100 80], 'String', this.timeRemaining,...
                'BackgroundColor', [0.85 0.85 0.85]);
            
            uicontrol('Style', 'text', 'Position', [50 150 100 80],...
                'String', 'Status');
            
            this.statusWindow = uitable('Position', [170 50 800 250],...
                'RowName', [], 'ColumnName', [], 'Enable', 'inactive',...
                'FontSize', 14, 'ColumnWidth', {798}, 'Data', this.statusText);
            
            %this.statusWindow = uitable('Units', 'characters',...
            %    'Position', [30 5 160 15],...
            %    'RowName', [], 'ColumnName', [], 'Enable', 'inactive',...
            %    'FontSize', 14, 'Units', 'characters', 'ColumnWidth', {158},...
            %    'Data', this.statusText);
            
            %set(this.statusWindow, 'Units', 'characters');
            %set(this.statusWindow, 'ColumnWidth', {this.statusWidth});
            %this.statusWindow = uitable('Position', [170 50 800 250],...
            %    'RowName', [], 'ColumnName', [], 'Enable', 'inactive',...
            %    'FontSize', 14, 'Data', this.statusText);
            
            %set(this.statusWindow, 'Units', 'characters');
            %set(this.statusWindow, 'ColumnWidth', {this.statusWidth});
            
            
            %this.statusWindow = uicontrol('Style', 'edit', 'enable', 'inactive',...
            %    'Max', 2, 'Min', 1, 'String', this.statusText);
            
            this.waveformAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 650 600 200]);
            
            this.spectrogramAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 350 600 200]);
            %{
            this.waveformDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Waveform Display (placeholder)', 'Position', ...
                [350 650 600 200]);
            
            this.spectrogramDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Spectrogram Display (placeholder)', 'Position', ...
                [350 350 600 200]);
                %}
                this.newRecord = uicontrol('Style', 'pushbutton', 'String',...
                    'New Test Subject', 'BackgroundColor', [0.4 0.4 0.9],...
                    'Position', [20 20 100 100], 'Callback', @PressNewTest);
                
                %WebcamAnalogue(this);
                
                %% Sub-constructor Functions
            function ManualSetName(~,~, throughDirectory)
                import StandardFunctions.setNameManual;
                import StandardFunctions.checkValidName;
                import StandardFunctions.addToStatus;
                
                %for a = 1:20
                %    addToStatus('Catch my electric boogaloo on the flippidy-floop', this);
                %end
                
                try
                    originalName = this.recordObj.wavName;
                    if strcmp(throughDirectory, 'via uigetdir')
                        %disp('via uigetdir');
                        
                        [this.recordObj.wavName, this.startingPathway] = setNameManual(this.startingPathway);
                        set(this.fileNameEditable, 'String', this.recordObj.wavName);
                    else
                        %disp('no uigetdir');
                        this.recordObj.wavName = get(this.fileNameEditable, 'String');
                    end
                    %disp(this.recordObj.wavName);
                    checkValidName(this.recordObj.wavName, this.fileNameEditable, this.errorColor);
                    if ~strcmp(originalName, this.recordObj.wavName)
                        set(this.fileNameManual, 'FontWeight', 'bold');
                        set(this.fileNameAuto, 'FontWeight', 'normal');
                    end
                catch
                    %ME.stack
                    disp('Canceled ManualName');
                end
                
            end
            
            function AutoSetName(~,~)
                import GUIFiles.LabScreen;
                import GUIFiles.RatScreen;
                import StandardFunctions.makeLabDirectory;
                import StandardFunctions.setNameAuto;
                import StandardFunctions.checkValidName;
                try
                    if this.firstAuto == 1
                        checkExistence = isobject(this.labScr);
                        if checkExistence == 0
                            this.labScr = LabScreen();
                        else
                            set(this.labScr.guiF, 'visible', 'on');
                        end
                        this.labName = getLabName(this.labScr);
                        this.firstAuto = 0;
                    end
                    
                    checkExistence = isobject(this.ratScr);
                    if checkExistence == 0
                        this.ratScr = RatScreen(this, this.labName);
                    else
                        set(this.ratScr.guiF, 'visible', 'on');
                    end
                    [rat, day, cohort, newLab] = getRatData(this.ratScr);
                    if ~isempty(newLab)
                        this.labName = newLab;
                    end
                    
                    labDirectory = makeLabDirectory(this.labName, cohort);
                    this.startingPathway = labDirectory;
                    
                    
                    this.recordObj.wavName = setNameAuto(this.startingPathway, this.labName, rat, day, cohort);
                    set(this.fileNameEditable, 'String', this.recordObj.wavName);
                    checkValidName(this.recordObj.wavName, this.fileNameEditable, this.errorColor);
                    
                    set(this.fileNameAuto, 'FontWeight', 'bold');
                    
                    set(this.fileNameManual, 'FontWeight', 'normal');
                catch
                    disp('Canceled AutoName');
                end
                
            end
            
            function AdvancedWindow(~, ~)
                import StandardFunctions.ClearText;
                
                checkExistence = isobject(this.advF);
                if checkExistence == 0
                    
                    
                    this.advF = figure('Name', 'Advanced Options', 'NumberTitle', ...
                        'off', 'Position', [80 820 300 300], 'ToolBar', 'none',...
                        'MenuBar', 'none', 'Resize', 'off', 'CloseRequestFcn', @HideWindow);
                    %Advanced options figure
                    
                    uicontrol('Style', 'text', 'Position', [20 260 200 20],...
                        'String', 'Continous Record', 'HorizontalAlignment',...
                        'left');
                    
                    continuousToggle = uicontrol('Style', 'checkbox',...
                        'Position', [220 260 20 20], 'Callback', @TogContinuous);
                    
                    this.recordTimeLabel = uicontrol('Style', 'Text', 'Position',...
                        [20 230 200 20], 'String', 'Recording Time (s)',...
                        'HorizontalAlignment', 'left');
                    
                    this.recordTimeEditable = uicontrol('Style', 'edit', 'Position',...
                        [220 230 50 20], 'String', this.recordObj.recordTime, 'Callback',...
                        @GetRecordTime, 'ButtonDownFcn', @ClearText, 'Enable',...
                        'inactive');
                    
                    uicontrol('Style', 'text', 'Position', [20 170 200 20],...
                        'String', 'Bit Depth', 'HorizontalAlignment', 'left');
                    
                    this.bitDepthSelect = uicontrol('Style', 'popupmenu', 'Position',...
                        [220 170 50 20], 'String', {16, 24, 32}, 'Value', 2,...
                        'Callback', @GetBitDepth);
                    
                    uicontrol('Style', 'text', 'Position', [40 100 220 50],...
                        'String',...
                        'A red box indicates an invalid entry. Check the manual if you are unsure what is permissible.',...
                        'FontWeight', 'bold');
                end
                
                function TogContinuous(checkbox, ~)
                    %Makes appropriate changes based on the status of the
                    %checkbox.
                    isCont = get(checkbox, 'Value'); %isCont corresponds to
                    %whether or not the Continuous checkbox is checked or not.
                    %disp(isCont);
                    if isCont == 1 %Box is checked
                        %recordObj.recordTime fields are made invisible
                        set(this.timeRemainingLabel, 'Visible', 'off');
                        set(this.timeRemainingDisplay, 'Visible', 'off');
                        set(this.recordTimeLabel, 'Visible', 'off');
                        set(this.recordTimeEditable, 'Visible', 'off');
                        this.recordObj.continuous = 1;
                    else %Box is unchecked
                        %recordObj.recordTime fields are made visible
                        set(this.timeRemainingLabel, 'Visible', 'on');
                        set(this.timeRemainingDisplay, 'Visible', 'on');
                        set(this.recordTimeLabel, 'Visible', 'on');
                        set(this.recordTimeEditable, 'Visible', 'on');
                        this.recordObj.continuous = 0;
                    end
                    %disp(recordObj.continuous);
                end
                
                function HideWindow(~,~)
                    disp('In HideWindow');
                    if this.advCanClose == 1
                        disp('Allowed to hide');
                        import StandardFunctions.generalHideWindow;
                        generalHideWindow(this.advF);
                        %set(this.advF, 'visible', 'off'); %Makes window invisible
                    else
                        disp('Shouldnt be closing');
                    end
                    %exit;
                end
            end
            
            function GetRecordTime(field, ~)
                %Sets recordObj.recordTime to the contents of recordTimeEditable
                import StandardFunctions.checkNaturalNum;
                this.advCanClose = 0; %Prevents the window from closing until
                %given a valid entry.
                numericContents = checkNaturalNum(field, this.errorColor);
                this.recordObj.recordTime = numericContents;
                this.timeRemaining = this.recordObj.recordTime;
                this.advCanClose = 1; %Window can close
                %disp(this.recordObj.recordTime);
            end
            
            function GetBitDepth(field, ~)
                %Sets recordObj.bitDepth to the contents of bitDepthSelect
                
                fieldValue = get(field, 'Value');
                switch fieldValue
                    case 1
                        this.recordObj.bitDepth = 16;
                    case 2
                        this.recordObj.bitDepth = 24;
                    case 3
                        this.recordObj.bitDepth = 32;
                end
                disp(this.recordObj.bitDepth);
            end
            
            function DeselectOnEnter(~, eventdata)
                if strcmp(eventdata.Key, 'return')
                    uicontrol(this.timeRemainingLabel); %Switches cursor to textbox
                    %in order to move cursor from current location.
                end
            end
            
            function PressStartStop(~,~)
                %Executes when the startStop button is pressed.
                import RPvdsExLink.AcquireAudio;
                %import RPvdsExLink.WebcamAnalogue;
                import StandardFunctions.addToStatus;
                
                if this.recordObj.recordStatus == 0
                    fileColor = get(this.fileNameEditable, 'BackgroundColor');
                    overwriteFile = isequal(fileColor, this.errorColor);
                    %Uses the background color of fileNameEditable as a
                    %check for whether or not the name will overwrite an
                    %existing file.
                    
                    if this.recordObj.continuous == 1
                        invalidRecordTime = 0;
                    else
                        recordTimeColor = get(this.recordTimeEditable, 'BackgroundColor');
                        invalidRecordTime = isequal(recordTimeColor, this.errorColor);
                    end
                    %Uses the background color of recordTimeEditable as a
                    %check for whether or not the recordObj.recordTime is valid.
                    
                    invalidRecordNonContinuous =...
                        (this.recordObj.continuous == 0 & invalidRecordTime == 1);
                    %invalidRecordNonContinuous is giving an empty logical
                    %array
                    
                    if overwriteFile == 1 || invalidRecordNonContinuous == 1
                        disp('Invalid field prevents record');
                    else
                        %record(this.recordObj.webcam);
                        set(this.startStop, 'String', 'Stop Recording',...
                            'BackgroundColor', [0.8 0.1 0.1]);
                        set(this.guiF, 'CloseRequestFcn', '');
                        this.recordObj.recordStatus = 1;
                        set(this.newRecord, 'Enable', 'off');
                        addToStatus('Recording...', this);
                        pause(0.002);  
                        %WebcamAnalogue(this);
                        AcquireAudio(this);
                    end
                    
                    
                else
                    this.stopRecord(this);
                    
                end
            end
            
            function PressNewTest(~,~)
                this.initiateNewTest = 1;
            end
            
            function CloseProgram(~,~)
                disp('In CloseProgram');
                if this.recordObj.recordStatus == 0
                    disp('Exit - enable before compilation');
                    %exit;
                else
                    disp('Cannot exit while recording');
                end
            end
            
        end
        
        function setFileName(screenObj, newName)
            screenObj.recordObj.wavName = newName;
        end
        
        function waitForNew(obj)
            %Possibly introduce onCleanup command
            waitfor(obj, 'initiateNewTest', 1);
            obj.initiateNewTest = 0;
            %set(obj.guiF, 'visible', 'off');
        end
        
        function stopRecord(screen)
            import StandardFunctions.addToStatus;
            set(screen.startStop, 'String', 'Start Recording',...
                'BackgroundColor', [0.5 1 0.5]);
            screen.recordObj.recordStatus = 0;
            addToStatus('Done recording', screen);
            
            %stop(this.recordObj.webcam);
            %disp('Done recording');
            %disp(this.recordObj.webcam);
            %play(this.recordObj.webcam);
            %disp('Done playing');
            %set(this.guiF, 'CloseRequestFcn', closereq);
            %Only enable closing and new record once saving has completed
        end
        
        function decrementTime(screen)
            screen.timeRemaining = screen.timeRemaining-1;%-buffLength;
            set(screen.timeRemainingDisplay, 'String', screen.timeRemaining);
            pause(0.001);
        end
    end
    
end

