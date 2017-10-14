classdef RecordScreen < handle & matlab.mixin.SetGetExactNames
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %To do:
    %Work out kinks from going back and forth between Auto and Manual
    %Offer scaled vs unscaled waveform
    %Make relevant output for Status window
    %Fix weird x-scaling on waveform reset
    %Clean up junk commenting
    %Make pretty
    
    properties
        %% Figures:
        guiF; %Main figure
        
        %% UIControl objects:
        fileNameAuto; %Push button that takes the user through LabScreen
        %(on first iteration only) and RatScreen (on every iteration).
        fileNameManual; %Push button that opens saving GUI
        fileNameEditable; %Edit field that displays the recordObj.wavName and allows
        %the user to edit it when clicked.
        continuousToggle; %Checkbox that indicates whether the recording
        %will have a time limit
        startStop; %Pushbutton that changes between "Start Recording" and
        %"Stop Recording" and toggles the microphone and recordObj.recordStatus.
        recordTimeLabel; %Text that identifies recordTimeEditable
        recordTimeEditable; %Edit field corresponding to recordObj.recordTime variable
        timeChangingLabel; %Text that identifies timeChangingDisplay as incrementing or decrementing
        timeChangingDisplay; %Edit field corresponding to timeChanging variable
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
        timeRemaining; %Displayed during timed record
        timeAccumulated; %Displayed during continuous record
        %initiateNewTest; %0 = don't reset screen; 1 = reset screen
        labScr; %Holds the LabScreen object
        ratScr; %Holds the RatScreen object
        firstAuto; %1 = first auto save iteration; 0 = not first
        labName; %The name of the lab under which the experiment is being run
        errorColor; %The color which fields are changed to when their contents are invalid 0 = not permitted
        statusText; %Saves all strings which have been printed to statusWindow
        running; %Breaks out of while loop in main file when the figure is closed
        changeState; %Used in waitForChange function to stimulate exit or new recording
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
        %waitForChange: Resets RecordScreen GUI when New Recording is pressed
        %or exits while loop when the window is closed.
        %stopRecord: Changes setting to halt the recording
        %decrementTime: Updates timeRemaining
        %incrementTime: Updates timeAccumulated
        
        %% Function Code
        function this = RecordScreen()
            %% GUI Set Up
            import RPvdsExLink.Recording;
            import StandardFunctions.ClearText;
            
            this.recordObj = Recording();
            this.running = 1;
            this.statusText = {};
            this.startingPathway = this.recordObj.wavName;
            this.timeRemaining = this.recordObj.recordTime;
            this.timeAccumulated = 0;
            this.labScr = ''; %isobject returns false
            this.ratScr = ''; %isobject returns false
            this.firstAuto = 1;
            this.errorColor = [1 0.3 0.3];
            
            
            this.guiF = figure('Name', 'Ready to Record', 'NumberTitle', 'off',...
                'Position', [50 50 1000 1000], 'ToolBar', 'none',...
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
                @DeselectOnEnter);
            
            
            uicontrol('Style', 'text', 'Position', [50 750 200 20],...
                'String', 'Continous Record', 'HorizontalAlignment',...
                'left', 'FontSize', 12);
            
            this.continuousToggle = uicontrol('Style', 'checkbox',...
                'Position', [240 750 20 20], 'Callback', @TogContinuous);
            
            this.recordTimeLabel = uicontrol('Style', 'Text', 'Position',...
                [50 700 200 20], 'String', 'Recording Time (s)',...
                'HorizontalAlignment', 'left', 'FontSize', 12);
            
            this.recordTimeEditable = uicontrol('Style', 'edit', 'Position',...
                [215 695 70 25], 'String', this.recordObj.recordTime, 'Callback',...
                @GetRecordTime, 'ButtonDownFcn', @ClearText, 'Enable',...
                'inactive', 'FontSize', 12);
            
            uicontrol('Style', 'text', 'Position', [40 800 220 50],...
                'String',...
                'A red box indicates an invalid entry. Check the manual if you are unsure what is permissible.',...
                'FontWeight', 'bold');
            
            this.startStop = uicontrol('Style', 'pushbutton', 'Position', ...
                [60 550 180 80], 'String', 'Start Recording', 'BackgroundColor',...
                [0.5 1 0.5], 'Callback', @PressStartStop);
            
            this.timeChangingLabel = uicontrol('Style', 'text', 'Position',...
                [50 420 100 80], 'String', 'Time Remaining (s):', 'FontSize', 11);
            
            this.timeChangingDisplay = uicontrol('Style', 'text',...
                'Position', [150 450 100 50], 'String', this.timeRemaining,...
                'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 11);
            
            uicontrol('Style', 'text', 'Position', [50 200 100 80],...
                'String', 'Status', 'FontSize', 15);
            
            this.statusWindow = uitable('Position', [170 50 800 250],...
                'RowName', [], 'ColumnName', [], 'Enable', 'inactive',...
                'FontSize', 14, 'ColumnWidth', {798}, 'Data', this.statusText);
            
            this.waveformAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 650 600 200], 'YLim', [-10 10], 'YLimMode', 'manual', 'YTick', [-10 -5 0 5 10]);
            %Audio input ranges from -10 to +10 on max settings. Input clips past
            %that. Watch out for DC offset (when the mean is not 0).
            
            yScaleWav = get(this.waveformAxes, 'YTick');
            yScaleWav = yScaleWav./10; %Scales +/-10 to +/-1
            set(this.waveformAxes, 'Ydir', 'Normal', 'YTickLabel', yScaleWav);
            
            title(this.waveformAxes, 'Waveform');
            xlabel(this.waveformAxes, 'Seconds');
            ylabel(this.waveformAxes, 'Scaled Amplitude (+/-1 is Max)');
            
            this.spectrogramAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 350 600 200], 'Ylim', [0 100000], 'YLimMode', 'manual');
            
            yScaleSpec = get(this.spectrogramAxes, 'YTick');
            yScaleSpec = yScaleSpec./1000;
            set(this.spectrogramAxes, 'Ydir', 'Normal', 'YTickLabel', yScaleSpec);
            
            title(this.spectrogramAxes, 'Spectrogram');
            xlabel(this.spectrogramAxes, 'Seconds');
            ylabel(this.spectrogramAxes, 'Frequency (kHz)');
            
            this.newRecord = uicontrol('Style', 'pushbutton', 'String',...
                'New Test Subject', 'BackgroundColor', [0.4 0.4 0.9],...
                'Position', [32 50 100 100], 'Callback', @PressNewTest);
            
            %% Sub-constructor Functions
            function ManualSetName(~,~, throughDirectory)
                import StandardFunctions.setNameManual;
                import StandardFunctions.checkValidName;
                import StandardFunctions.addToStatus;
                
                try
                    originalName = this.recordObj.wavName;
                    if strcmp(throughDirectory, 'via uigetdir')
                        
                        [this.recordObj.wavName, this.startingPathway] = setNameManual(this.startingPathway);
                        set(this.fileNameEditable, 'String', this.recordObj.wavName);
                    else
                        this.recordObj.wavName = get(this.fileNameEditable, 'String');
                    end
                    checkValidName(this.recordObj.wavName, this.fileNameEditable, this.errorColor);
                    if ~strcmp(originalName, this.recordObj.wavName)
                        set(this.fileNameManual, 'FontWeight', 'bold');
                        set(this.fileNameAuto, 'FontWeight', 'normal');
                    end
                catch
                end
                
            end
            
            function AutoSetName(~,~)
                import GUIFiles.LabScreen;
                import GUIFiles.RatScreen;
                import StandardFunctions.makeLabDirectory;
                import StandardFunctions.setNameAuto;
                import StandardFunctions.checkValidName;
                
                originalLab = this.labName; 
                originalPath = this.startingPathway;
                
                try
                    if this.firstAuto == 1
                        %LabScreen does not automatically open on all
                        %iterations
                        checkExistence = isobject(this.labScr);
                        if checkExistence == 0
                            this.labScr = LabScreen();
                            %Object is retained after AutoSetName concludes
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
                        this.ratScr.labName = this.labName;
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
                    %Names are set to originals if naming is exited
                    %prematurely.
                    this.labName = originalLab;
                    
                    this.labScr.chosenLab = originalLab;
                    if isempty(this.labName)
                        this.firstAuto = 1;
                    end
                    this.startingPathway = originalPath;
                end
                
            end
            
            function TogContinuous(checkbox, ~)
                %Makes appropriate changes based on the status of the
                %checkbox.
                isCont = get(checkbox, 'Value'); %isCont corresponds to
                %whether or not the Continuous checkbox is checked or not.
                if isCont == 1 %Box is checked
                    %recordObj.recordTime fields are made invisible
                    set(this.timeChangingLabel, 'String', 'Elapsed Time (s):');%'Visible', 'off');
                    set(this.timeChangingDisplay, 'String', this.timeAccumulated);%'Visible', 'off');
                    set(this.recordTimeLabel, 'Visible', 'off');
                    set(this.recordTimeEditable, 'Visible', 'off');
                    this.recordObj.continuous = 1;
                else %Box is unchecked
                    %recordObj.recordTime fields are made visible
                    set(this.timeChangingLabel, 'String', 'Time Remaining (s):'); % 'Visible', 'on');
                    set(this.timeChangingDisplay, 'String', this.timeRemaining);%'Visible', 'on');
                    set(this.recordTimeLabel, 'Visible', 'on');
                    set(this.recordTimeEditable, 'Visible', 'on');
                    this.recordObj.continuous = 0;
                end
            end
            
            function GetRecordTime(field, ~)
                %Sets recordObj.recordTime to the contents of recordTimeEditable
                import StandardFunctions.checkNaturalNum;
                numericContents = checkNaturalNum(field, this.errorColor);
                this.recordObj.recordTime = numericContents;
                this.timeRemaining = this.recordObj.recordTime;
                set(this.timeChangingDisplay, 'String', this.timeRemaining);
                %disp(this.recordObj.recordTime);
            end
            
            
            function DeselectOnEnter(~, eventdata)
                if strcmp(eventdata.Key, 'return')
                    uicontrol(this.timeChangingLabel); %Switches cursor to textbox
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
                        %disp('Invalid field prevents record');
                        addToStatus('Invalid field prevents record', this);
                    else
                        %record(this.recordObj.webcam);
                        set(this.startStop, 'String', 'Stop Recording',...
                            'BackgroundColor', [0.8 0.1 0.1]);
                        %set(this.guiF, 'CloseRequestFcn', '');
                        this.recordObj.recordStatus = 1;
                        set(this.newRecord, 'Enable', 'off');
                        addToStatus('Recording...', this);
                        pause(0.002);
                        %WebcamAnalogue(this);
                        set(this.fileNameAuto, 'Enable', 'off');
                        set(this.fileNameManual, 'Enable', 'off');
                        set(this.fileNameEditable, 'Enable', 'off');
                        disp(this.startingPathway);
                        exist(this.startingPathway, 'dir')
                        try
                            AcquireAudio(this);
                        catch
                            %stopRecord(this);
                            disp('In catch');
                            set(this.newRecord, 'Enable', 'on');
                            set(this.fileNameAuto, 'Enable', 'on');
                            set(this.fileNameManual, 'Enable', 'on');
                            set(this.fileNameEditable, 'Enable', 'on');
                            set(this.startStop, 'String', 'Start Recording',...
                                'BackgroundColor', [0.5 1 0.5]);
                            this.recordObj.recordStatus = 0;
                        end
                    end
                    
                    
                else
                    stopRecord(this);
                    
                end
            end
            
            function PressNewTest(~,~)
                %this.initiateNewTest = 1;
                this.statusText = {};
                set(this.statusWindow, 'Data', this.statusText);
                this.timeRemaining = this.recordObj.recordTime;
                this.timeAccumulated = 0;
                TogContinuous(this.continuousToggle);
                wavPlot = get(this.waveformAxes, 'Children');
                delete(wavPlot);
                specPlot = get(this.spectrogramAxes, 'Children');
                delete(specPlot);
                set(this.fileNameAuto, 'Enable', 'on');
                set(this.fileNameManual, 'Enable', 'on');
                set(this.fileNameEditable, 'Enable', 'on');
                set(this.startStop, 'Enable', 'on');%'BackgroundColor', [0.5 1 0.5]);
                this.changeState = 1;
            end
            
            function CloseProgram(~,~)
                import StandardFunctions.addToStatus;
                %disp('In CloseProgram');
                if this.recordObj.recordStatus == 0
                    this.running = 0;
                    this.changeState = 1;
                    %disp('Exit - enable before compilation');
                    %exit;
                else
                    addToStatus('Cannot exit while recording or saving', this);
                    %disp('Cannot exit while recording');
                end
            end
            
        end
        
        function setFileName(screenObj, newName)
            screenObj.recordObj.wavName = newName;
        end
        
        function waitForChange(obj)
            %Possibly introduce onCleanup command
            %waitfor(obj, 'initiateNewTest', 1) || waitfor(obj, 'running');
            waitfor(obj, 'changeState', 1);
            obj.changeState = 0;
            %Loop resets to new recording if running == 1. Otherwise, the
            %program terminates.
            
            %obj.initiateNewTest = 0;
            %set(obj.guiF, 'visible', 'off');
        end
        
        function stopRecord(screen)
            import StandardFunctions.addToStatus;
            set(screen.startStop, 'String', 'Start Recording',...
                'BackgroundColor', [0.5 1 0.5]);
            screen.recordObj.recordStatus = 0;
            addToStatus('Done recording', screen);
            set(screen.startStop, 'Enable', 'off');
            %checkValidName(screen.recordObj.wavName, screen.fileNameEditable, screen.errorColor);
            
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
            set(screen.timeChangingDisplay, 'String', screen.timeRemaining);
            pause(0.001);
        end
        
        function incrementTime(screen)
            screen.timeAccumulated = screen.timeAccumulated+1;%-buffLength;
            set(screen.timeChangingDisplay, 'String', screen.timeAccumulated);
            pause(0.001);
        end
        
        function enableNew(screen)
            import StandardFunctions.checkValidName
            set(screen.newRecord, 'Enable', 'on');
            %set(screen.startStop, 'Enable', 'on');
            checkValidName(screen.recordObj.wavName, screen.fileNameEditable, screen.errorColor);
            
            %set(screen.guiF, 'CloseRequestFcn', @CloseProgram);
            %Re-enable closing of window
        end
    end
    
end

