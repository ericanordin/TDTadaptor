classdef RecordScreen < handle & matlab.mixin.SetGetExactNames & GUIFiles.GUI
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %To do:
    %Enable 'New Recording' button and exit figure when saving is complete.
    %Find out how scaling factor applies
    %Write destructor
    %Enable Auto/Manual button toggle
    %Work out kinks from going back and forth between Auto and Manual
    %Make pretty
    
    properties
        %Figures:
        guiF;
        
        %UIControl objects:
        fileNameAuto; %Push button that takes the user through LabScreen
        %(on first iteration only) and RatScreen (on every iteration).
        fileNameManual; %Push button that opens saving GUI
        fileNameEditable; %Edit field that displays the fileName and allows
        %the user to edit it when clicked.
        continousToggle; %Checkbox that indicates whether the recording
        %will have a time limit
        bitDepthSelect; %Options 16, 24, and 32 bits
        scalingEditable; %Edit field corresponding to scaling variable.
        advancedButton; %Displays advanced options
        startStop; %Pushbutton that changes between "Start Recording" and
        %"Stop Recording" and toggles the microphone and recordStatus.
        recordTimeLabel; %Text that identifies recordTimeEditable
        recordTimeEditable; %Edit field corresponding to recordTime variable
        timeRemainingLabel; %Text that identifies timeRemainingDisplay
        timeRemainingDisplay; %Edit field corresponding to timeRemaining variable
        statusWindow; %Displays text describing the background processes
        waveformDisplay; %Shows the waveform corresponding to the real-time
        %recording.
        spectrogramDisplay; %Shows the spectrogram corresponding to the
        %real-time recording.
        newRecord; %Resets to directory with no file name.
        
        
        %Variables:
        fileName; %The name of the recording
        startingPathway; %What location to open the dialog box at when
        %fileNameManual is pressed.
        continuous; %Boolean expression of whether the recording is continuous.
        %recordTime is disabled when it is 1 and enabled when it is 0.
        bitDepth;
        scaling;
        recordStatus; %1 = recording; 0 = not recording
        recordTime;
        timeRemaining;
        initiateNewTest;
        labScr; %Holds the LabScreen object
        ratScr; %Holds the RatScreen object
        firstAuto; %1 = first auto save iteration; 0 = not first
        labName; %The name of the lab under which the experiment is being run
        errorColor; %The color which fields are changed to when their contents are invalid
        advCanClose; %1 = advanced settings window is permitted to close; 0 = not permitted
        
    end
    
    methods
        %Functions:
        %RecordScreen: constructor
        %ManualSetName: Executes steps to assign the file name manually.
        %AutoSetName: Executes steps to assign the file name automatically.
        %AdvancedWindow: Opens window for advanced options.
        %TogContinuous: Interfaces between the continuous variable and the
        %continuousToggle checkbox.
        %GetRecordTime: Interfaces between the recordTime variable and the
        %recordTimeEditable field.
        %GetScaling: Interfaces between the scaling variable and the
        %scalingEditable field.
        %GetBitDepth: Interfaces between the bitDepth variable and the
        %bitDepthSelect pop up menu.
        
        %DeselectOnEnter: Changes location of the cursor away from the
        %currently selected edit field.
        %PressStartStop: Executes start/stop process based on the value of
        %recordStatus.
        %PressNewTest: Triggers the while loop in main to restart by
        %interfacing with waitForNew.
        %CloseProgram: Exits the program
        %display: may or may not be enabled
        
        function this = RecordScreen()
            this.bitDepth = 24;
            this.scaling = 10;
            this.recordTime = 600;
            this.fileName = '';
            this.startingPathway = 'C:\';
            this.recordStatus = 0;
            this.timeRemaining = this.recordTime;
            this.initiateNewTest = 0;
            this.labScr = '';
            this.ratScr = '';
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
                [270 900 680 90], 'String', this.fileName, 'Callback',...
                {@ManualSetName, 'no uigetdir'}, 'KeyPressFcn',...
                @DeselectOnEnter);
            
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
            
            this.statusWindow = uitable('Position', [170 50 800 250]);
            
            this.waveformDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Waveform Display (placeholder)', 'Position', ...
                [350 650 600 200]);
            
            this.spectrogramDisplay = uicontrol('Style', 'pushbutton', 'String',...
                'Spectrogram Display (placeholder)', 'Position', ...
                [350 350 600 200]);
            
            this.newRecord = uicontrol('Style', 'pushbutton', 'String',...
                'New Test Subject', 'BackgroundColor', [0.4 0.4 0.9],...
                'Position', [20 20 100 100], 'Callback', @PressNewTest);
            
            function ManualSetName(~,~, throughDirectory)
                import StandardFunctions.setNameManual;
                import StandardFunctions.checkOverwrite;
                if strcmp(throughDirectory, 'via uigetdir')
                    %disp('via uigetdir');
                    [this.fileName, this.startingPathway] = setNameManual(this.startingPathway);
                    set(this.fileNameEditable, 'String', this.fileName);
                else
                    %disp('no uigetdir');
                    this.fileName = get(this.fileNameEditable, 'String');
                end
                %disp(this.fileName);
                checkOverwrite(this.fileName, this.fileNameEditable, this.errorColor);
            end
            
            function AutoSetName(~,~)
                import GUIFiles.LabScreen;
                import GUIFiles.RatScreen;
                import StandardFunctions.makeLabDirectory;
                import StandardFunctions.setNameAuto;
                import StandardFunctions.checkOverwrite;
                
                if this.firstAuto == 1
                    checkExistence = isobject(this.labScr);
                    if checkExistence == 0
                        this.labScr = LabScreen();
                    else
                        set(this.labScr.guiF, 'visible', 'on');
                    end
                    this.labName = getLabName(this.labScr);
                    
                    %Location of next two lines may change based on directory requests.
                    labDirectory = makeLabDirectory(this.labName);
                    this.startingPathway = labDirectory;
                    this.firstAuto = 0;
                end
                
                checkExistence = isobject(this.ratScr);
                if checkExistence == 0
                    this.ratScr = RatScreen(this);
                else
                    set(this.ratScr.guiF, 'visible', 'on');
                end
                [rat, day, cohort, newLab] = getRatData(this.ratScr);
                if ~isempty(newLab)
                    newLabDirectory = makeLabDirectory(newLab);
                    this.startingPathway = newLabDirectory;
                end
                this.fileName = setNameAuto(this.startingPathway, this.labName, rat, day, cohort);
                set(this.fileNameEditable, 'String', this.fileName);
                checkOverwrite(this.fileName, this.fileNameEditable, this.errorColor);
                
            end
            
            function AdvancedWindow(~, ~)
                import StandardFunctions.ClearText;
                
                advF = figure('Name', 'Advanced Options', 'NumberTitle', ...
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
                    [220 230 50 20], 'String', this.recordTime, 'Callback',...
                    @GetRecordTime, 'ButtonDownFcn', @ClearText, 'Enable',...
                    'inactive');
                
                uicontrol('Style', 'text', 'Position', [20 200 200 20],...
                    'String', 'Scaling Factor', 'HorizontalAlignment',...
                    'left');
                
                this.scalingEditable = uicontrol('Style', 'edit', 'Position',...
                    [220 200 50 20], 'String', this.scaling, 'Callback',...
                    @GetScaling, 'ButtonDownFcn', @ClearText, 'Enable',...
                    'inactive');
                
                uicontrol('Style', 'text', 'Position', [20 170 200 20],...
                    'String', 'Bit Depth', 'HorizontalAlignment', 'left');
                
                this.bitDepthSelect = uicontrol('Style', 'popupmenu', 'Position',...
                    [220 170 50 20], 'String', {16, 24, 32}, 'Value', 2,...
                    'Callback', @GetBitDepth);
                
                uicontrol('Style', 'text', 'Position', [40 100 220 50],...
                    'String',...
                    'A red box indicates an invalid entry. See the manual if you are unsure what is permissible.',...
                    'FontWeight', 'bold');
                
                function TogContinuous(checkbox, ~)
                    %Makes appropriate changes based on the status of the
                    %checkbox.
                    isCont = get(checkbox, 'Value'); %isCont corresponds to
                    %whether or not the Continuous checkbox is checked or not.
                    %disp(isCont);
                    if isCont == 1 %Box is checked
                        %recordTime fields are made invisible
                        set(this.timeRemainingLabel, 'Visible', 'off');
                        set(this.timeRemainingDisplay, 'Visible', 'off');
                        set(this.recordTimeLabel, 'Visible', 'off');
                        set(this.recordTimeEditable, 'Visible', 'off');
                        this.continuous = 1;
                    else %Box is unchecked
                        %recordTime fields are made visible
                        set(this.timeRemainingLabel, 'Visible', 'on');
                        set(this.timeRemainingDisplay, 'Visible', 'on');
                        set(this.recordTimeLabel, 'Visible', 'on');
                        set(this.recordTimeEditable, 'Visible', 'on');
                        this.continuous = 0;
                    end
                    %disp(continuous);
                end
                
                function HideWindow(~,~)
                    disp('In HideWindow');
                    if this.advCanClose == 1
                        disp('Allowed to hide');
                        set(advF, 'visible', 'off'); %Makes window invisible
                    else
                        disp('Shouldnt be closing');
                    end
                    %exit;
                end
            end
            
            
            
            function GetRecordTime(field, ~)
                %Sets recordTime to the contents of recordTimeEditable
                import StandardFunctions.checkInteger;
                this.advCanClose = 0; %Prevents the window from closing until 
                %given a valid entry.
                numericContents = checkInteger(field, this.errorColor);
                this.recordTime = numericContents;
                this.advCanClose = 1; %Window can close
                %disp(this.recordTime);
            end
            
            function GetScaling(field, ~)
                %Sets scaling to the contents of scalingEditable
                import StandardFunctions.checkInteger;
                this.advCanClose = 0; %Prevents the window from closing until 
                %given a valid entry.
                numericContents = checkInteger(field, this.errorColor);
                this.scaling = numericContents;
                this.advCanClose = 1; %Window can close
                %disp(this.scaling);
            end
            
            function GetBitDepth(field, ~)
                %Sets bitDepth to the contents of bitDepthSelect
                
                %{
                switch bitDepth
                    case 16
                        set(field, 'Value', 1);
                    case 24
                        set(field, 'Value', 2);
                    case 32
                        set(field, 'Value', 3);
                end
                %}
                fieldValue = get(field, 'Value');
                switch fieldValue
                    case 1
                        this.bitDepth = 16;
                    case 2
                        this.bitDepth = 24;
                    case 3
                        this.bitDepth = 32;
                end
                disp(this.bitDepth);
            end
            
            function DeselectOnEnter(~, eventdata)
                if strcmp(eventdata.Key, 'return')
                    uicontrol(this.timeRemainingLabel); %Switches cursor to textbox
                    %in order to move cursor from current location.
                end
            end
            
            function PressStartStop(~,~)
                %Executes when the startStop button is pressed.
                if this.recordStatus == 0
                    fileColor = get(this.fileNameEditable, 'BackgroundColor');
                    overwriteFile = isequal(fileColor, this.errorColor);
                    %Uses the background color of fileNameEditable as a
                    %check for whether or not the name will overwrite an
                    %existing file.
                    
                    recordTimeColor = get(this.recordTimeEditable, 'BackgroundColor');
                    invalidRecordTime = isequal(recordTimeColor, this.errorColor);
                    %Uses the background color of recordTimeEditable as a
                    %check for whether or not the recordTime is valid.
                    
                    scalingColor = get(this.scalingEditable, 'BackgroundColor');
                    invalidScaling = isequal(scalingColor, this.errorColor);
                    %Uses the background color of scalingEditable as a
                    %check for whether or not the scaling is valid.
                    
                    if overwriteFile == 1 || invalidScaling == 1 ||...
                            (continuous == 0 && invalidRecordTime == 1)
                        disp('Cannot record with overwrite');
                        
                    else
                        set(this.startStop, 'String', 'Stop Recording',...
                            'BackgroundColor', [0.8 0.1 0.1]);
                        set(this.guiF, 'CloseRequestFcn', '');
                        this.recordStatus = 1;
                        set(this.newRecord, 'Enable', 'off');
                    end
                    
                    
                else
                    set(this.startStop, 'String', 'Start Recording', 'BackgroundColor',...
                        [0.5 1 0.5]);
                    this.recordStatus = 0;
                    %set(this.guiF, 'CloseRequestFcn', closereq);
                    %Only enable closing and new record once saving has completed
                end
            end
            
            function PressNewTest(~,~)
                this.initiateNewTest = 1;
            end
            
            function CloseProgram(~,~)
                disp('In CloseProgram');
                if this.recordStatus == 0
                    disp('Exit - enable before compilation');
                    %exit;
                else
                    disp('Cannot exit while recording');
                end
            end
            
            
        end
        
        function waitForNew(obj)
            waitfor(obj, 'initiateNewTest', 1);
            obj.initiateNewTest = 0;
            %set(obj.guiF, 'visible', 'off');
        end
        
        
        function display(guiobj)
        end
        
        % function path = get.startingPathway(obj)
        %    path = obj.startingPathway;
        %end
    end
    
end

