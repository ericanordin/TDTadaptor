classdef RecordScreen < handle & matlab.mixin.SetGetExactNames
    %RECORDSCREEN Displays the GUI for settings and audio recording.
    %   Interfaces with RatScreen and LabScreen
    
    properties
        %% Figures:
        guiF; %Main figure
        
        %% UIControl objects:
        fileNameAuto; %Push button that takes the user through LabScreen
        %(on first iteration only) and RatScreen (on every iteration).
        fileNameManual; %Push button that opens window to select save directory
        %and file name entry.
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
        bitDepthGroup; %uibuttongroup that offers choice of 32, 24, or 16 bit recording
        bitButton32; %32 bit radio button
        bitButton24; %24 bit radio button
        bitButton16; %16 bit radio button
        
        %% Variables:
        recordObj; %The Recording class object
        startingPathway; %What directory to open the dialog box at when
        %fileNameManual is pressed.
        timeRemaining; %Displayed during timed record
        timeAccumulated; %Displayed during continuous record
        labScr; %Holds the LabScreen object
        ratScr; %Holds the RatScreen object
        firstAuto; %1 = first auto save iteration; 0 = not first
        labName; %The name of the lab under which the experiment is being run
        errorColor; %The color which fields are changed to when their contents are invalid 0 = not permitted
        statusText; %Saves all strings which have been printed to statusWindow
        running; %Breaks out of while loop in main file when the figure is closed
        changeState; %Used in waitForChange function to stimulate exit from
        %program or new recording
    end
    
    methods
        %% Function Descriptions:
        %RecordScreen: constructor
        
        %ManualSetName: Executes steps to assign the file name manually.
        %AutoSetName: Executes steps to assign the file name automatically.
        %TogContinuous: Interfaces between the recordObj.continuous variable and the
        %continuousToggle checkbox.
        %GetRecordTime: Interfaces between the recordObj.recordTime variable and the
        %recordTimeEditable field.
        %SelectBitDepth: Interfaces between the recordObj.bitDepth variable and
        %bitDepthGroup.        
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
        %enableNew: Sets New Recording button to a state that the user can
        %press
        
        %% Function Code
        
        function this = RecordScreen()
            %% GUI Set Up
            import RPvdsExLink.Recording;
            import StandardFunctions.ClearText;
            
            this.recordObj = Recording(); %Holds settings for the audio recording
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
            
            uicontrol('Style', 'text', 'Position', [50 640 100 100], ...
                'FontSize', 12, 'String', 'Bit Depth', ...
                'HorizontalAlignment', 'left');
            
            this.bitDepthGroup = uibuttongroup('Units', 'pixels', ...
                'Position', [150 660 110 130], 'SelectionChangedFcn', ...
                @SelectBitDepth);
            
            this.bitButton32 = uicontrol(this.bitDepthGroup, 'Style',...
                'radiobutton', 'String', '32 bit', 'Position', ...
                [15 90 100 30], 'FontSize', 10, 'Tag', '32bitButton');
            
            this.bitButton24 = uicontrol(this.bitDepthGroup, 'Style',...
                'radiobutton', 'String', '24 bit', 'Position', ...
                [15 50 100 30], 'FontSize', 10, 'Tag', '24bitButton');
            
            this.bitButton16 = uicontrol(this.bitDepthGroup, 'Style',...
                'radiobutton', 'String', '16 bit', 'Position', ...
                [15 10 100 30], 'FontSize', 10, 'Tag', '16bitButton');
            
            uicontrol('Style', 'text', 'Position', [50 620 200 20],...
                'String', 'Continous Record', 'HorizontalAlignment',...
                'left', 'FontSize', 12);
            
            this.continuousToggle = uicontrol('Style', 'checkbox',...
                'Position', [240 620 20 20], 'Callback', @TogContinuous);
            
            this.recordTimeLabel = uicontrol('Style', 'Text', 'Position',...
                [50 570 200 20], 'String', 'Recording Time (s)',...
                'HorizontalAlignment', 'left', 'FontSize', 12);
            
            this.recordTimeEditable = uicontrol('Style', 'edit', 'Position',...
                [215 565 70 25], 'String', this.recordObj.recordTime, 'Callback',...
                @GetRecordTime, 'ButtonDownFcn', @ClearText, 'Enable',...
                'inactive', 'FontSize', 12);
            
            uicontrol('Style', 'text', 'Position', [40 800 220 50],...
                'String',...
                'A red box indicates an invalid entry. Check the manual if you are unsure what is permissible.',...
                'FontWeight', 'bold');
            
            this.startStop = uicontrol('Style', 'pushbutton', 'Position', ...
                [60 450 180 80], 'String', 'Start Recording', 'BackgroundColor',...
                [0.5 1 0.5], 'Callback', @PressStartStop);
            
            this.timeChangingLabel = uicontrol('Style', 'text', 'Position',...
                [50 320 100 80], 'String', 'Time Remaining (s):', 'FontSize', 11);
            
            this.timeChangingDisplay = uicontrol('Style', 'text',...
                'Position', [150 350 100 50], 'String', this.timeRemaining,...
                'BackgroundColor', [0.85 0.85 0.85], 'FontSize', 11);
            
            uicontrol('Style', 'text', 'Position', [50 200 100 80],...
                'String', 'Status', 'FontSize', 15);
            
            this.statusWindow = uitable('Position', [170 50 800 250],...
                'RowName', [], 'ColumnName', [], 'Enable', 'inactive',...
                'FontSize', 14, 'ColumnWidth', {798}, 'Data', this.statusText);
            %StandardFunctions.padText relies on the width of statusWindow.
            %Adjust statusWidth in padText if the width of the window is
            %changed.
            
            this.waveformAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 650 600 200], 'YLim', [-10 10], 'YLimMode', 'manual', 'YTick', [-10 -5 0 5 10]);
            %Audio input ranges from -10 to +10 on max gain settings on 
            %microphone (before scaling). Input clips past that. Watch out 
            %for DC offset (when the mean is not 0 - see manual for details).
            
            yScaleWav = get(this.waveformAxes, 'YTick');
            yScaleWav = yScaleWav./10; %Scales +/-10 to +/-1 on waveform display
            set(this.waveformAxes, 'Ydir', 'Normal', 'YTickLabel', yScaleWav);
            
            title(this.waveformAxes, 'Waveform');
            xlabel(this.waveformAxes, 'Seconds');
            ylabel(this.waveformAxes, 'Scaled Amplitude (+/-1 is Max)');
            
            this.spectrogramAxes = axes('Units', 'pixels', 'Box', 'on', 'Position', ...
                [350 350 600 200], 'Ylim', [0 100000], 'YLimMode', 'manual');
            %RX6 has a recording frequency of 195312, so it can record
            %frequencies up to almost 100000 Hz.
            
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
                %Called by pressing "Name File Manually" or clicking the
                %entry field (where the name is displayed). Renames the
                %audio file.
                import StandardFunctions.setNameManual;
                import StandardFunctions.checkValidName;
                import StandardFunctions.addToStatus;
                
                originalLab = this.labName;
                originalName = this.recordObj.wavName;
                originalPath = this.startingPathway;
                
                try                    
                    if strcmp(throughDirectory, 'via uigetdir')
                        %ManualSetName is called via fileNameManual or
                        %fileNameEditable. throughDirectory == 'via
                        %uigetdir' if the function is called via fileNameManual
                        [this.recordObj.wavName, this.startingPathway] = setNameManual(this.startingPathway);
                        set(this.fileNameEditable, 'String', this.recordObj.wavName);
                    else
                        this.recordObj.wavName = get(this.fileNameEditable, 'String');
                    end
                    checkValidName(this.recordObj.wavName, this.fileNameEditable, this.errorColor);
                    if ~strcmp(originalName, this.recordObj.wavName)
                        %Bolding represents which naming option was last
                        %selected
                        set(this.fileNameManual, 'FontWeight', 'bold');
                        set(this.fileNameAuto, 'FontWeight', 'normal');
                    end
                catch
                    %Names are set back to originals if naming is exited
                    %prematurely.
                    this.labName = originalLab;
                    this.recordObj.wavName = originalName;
                    this.startingPathway = originalPath;
                end
                
            end
            
            function AutoSetName(~,~)
                %Called by pressing "Name File Automatically". Renames the
                %audio file according to the template system (see RatScreen).
                import GUIFiles.LabScreen;
                import GUIFiles.RatScreen;
                import StandardFunctions.makeLabDirectory;
                import StandardFunctions.setNameAuto;
                import StandardFunctions.checkValidName;
                
                originalLab = this.labName;
                originalPath = this.startingPathway;
                
                try
                    if this.firstAuto == 1
                        %LabScreen only opens before RatScreen on first 
                        %access of AutoSetName
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
                    if ~isempty(newLab) %Lab was changed during RatScreen access
                        this.labName = newLab;
                    end
                    
                    this.startingPathway = makeLabDirectory(this.labName, cohort);                 
                    
                    this.recordObj.wavName = setNameAuto(this.startingPathway, this.labName, rat, day, cohort);
                    set(this.fileNameEditable, 'String', this.recordObj.wavName);
                    checkValidName(this.recordObj.wavName, this.fileNameEditable, this.errorColor);
                    
                    %Bolding represents which naming option was last selected
                    set(this.fileNameAuto, 'FontWeight', 'bold');                    
                    set(this.fileNameManual, 'FontWeight', 'normal');
                catch
                    %Names are set back to originals if naming is exited
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
                %continuous checkbox.
                isCont = get(checkbox, 'Value'); %isCont corresponds to
                %whether or not the Continuous checkbox is checked or not.
                if isCont == 1 %Box is checked
                    %recordTime fields are made invisible
                    set(this.timeChangingLabel, 'String', 'Elapsed Time (s):');%'Visible', 'off');
                    set(this.timeChangingDisplay, 'String', this.timeAccumulated);%'Visible', 'off');
                    set(this.recordTimeLabel, 'Visible', 'off');
                    set(this.recordTimeEditable, 'Visible', 'off');
                    this.recordObj.continuous = 1;
                else %Box is unchecked
                    %recordTime fields are made visible
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
            end
            
            function SelectBitDepth(source, ~)
                %Sets bit depth from radio button selection
                import Enums.SaveFormat;
                import StandardFunctions.addToStatus;
                switch source.SelectedObject.Tag
                    case '32bitButton'
                        bitFormat = SaveFormat.Int32;
                    case '24bitButton'
                        bitFormat = SaveFormat.Float24;
                    case '16bitButton'
                        bitFormat = SaveFormat.Float16;
                    otherwise
                        bitFormat = NaN;
                        addToStatus('Problem with bit depth selection', this);
                end
                
                try
                    updateBitVariables(this.recordObj, bitFormat);
                catch
                    addToStatus('Bit variable updates failed', this);
                end
            end
            
            function DeselectOnEnter(~, eventdata)
                %Removes cursor from current entry box
                if strcmp(eventdata.Key, 'return')
                    uicontrol(this.timeChangingLabel); %Switches cursor to textbox
                    %in order to move cursor from current location.
                end
            end
            
            function PressStartStop(~,~)
                %Executes when the startStop button is pressed.
                %Stimulates start or stop of recording after checking for
                %appropriate settings
                import RPvdsExLink.AcquireAudio;
                import StandardFunctions.addToStatus;
                
                if this.recordObj.recordStatus == 0
                    %Request to start recording; check for appropriate settings
                    
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
                    
                    if overwriteFile == 1 || invalidRecordNonContinuous == 1
                        addToStatus('Invalid field prevents record', this);
                    else %Set up to start recording
                        set(this.startStop, 'String', 'Stop Recording',...
                            'BackgroundColor', [0.8 0.1 0.1]);
                        this.recordObj.recordStatus = 1;
                        set(this.newRecord, 'Enable', 'off'); 
                        %Disabling button prevents it from being pressed
                        %before the recording is stopped
                        addToStatus('Recording...', this);
                        pause(0.002);
                        set(this.fileNameAuto, 'Enable', 'off');
                        set(this.fileNameManual, 'Enable', 'off');
                        set(this.fileNameEditable, 'Enable', 'off');
                        
                        try %Record audio
                            AcquireAudio(this);
                        catch
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
                %Resets particular settings to record a new test subject
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
                set(this.startStop, 'Enable', 'on');
                this.changeState = 1;
            end
            
            function CloseProgram(~,~)
                %Called by clicking to exit RecordScreen figure. Prevents
                %close if recording is taking place.
                import StandardFunctions.addToStatus;
                if this.recordObj.recordStatus == 0
                    this.running = 0;
                    this.changeState = 1;
                else
                    addToStatus('Cannot exit while recording or saving', this);
                end
            end
            
        end
        
        function setFileName(screenObj, newName)
            screenObj.recordObj.wavName = newName;
        end
        
        function waitForChange(obj)
            %Called from main to determine whether to set up for a new
            %recording or exit program.
            waitfor(obj, 'changeState', 1);
            obj.changeState = 0;
            %Loop resets to new recording if running == 1. Otherwise, the
            %program terminates.
        end
        
        function stopRecord(screen)
            %Make GUI changes at the end of recording
            import StandardFunctions.addToStatus;
            set(screen.startStop, 'String', 'Start Recording',...
                'BackgroundColor', [0.5 1 0.5]);
            screen.recordObj.recordStatus = 0;
            addToStatus('Done recording', screen);
            set(screen.startStop, 'Enable', 'off'); 
            %startStop button must be re-enabled via "New Recording"
        end
        
        function decrementTime(screen)
            %Subtract 1 second from timeRemaining
            screen.timeRemaining = screen.timeRemaining-1;
            set(screen.timeChangingDisplay, 'String', screen.timeRemaining);
            pause(0.001);
        end
        
        function incrementTime(screen)
            %Add 1 second to timeAccumulated
            screen.timeAccumulated = screen.timeAccumulated+1;%-buffLength;
            set(screen.timeChangingDisplay, 'String', screen.timeAccumulated);
            pause(0.001);
        end
        
        function enableNew(screen)
            %Enable newRecord button
            import StandardFunctions.checkValidName
            set(screen.newRecord, 'Enable', 'on');
            checkValidName(screen.recordObj.wavName, screen.fileNameEditable, screen.errorColor);
        end
    end
    
end

