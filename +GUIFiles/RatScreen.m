classdef RatScreen < handle & matlab.mixin.SetGetExactNames
    %RATSCREEN Enter the details of the rat being tested.
    %To do:
    %Write destructor
    %Make pretty
    
    properties
        %% Figures:
        guiF;
        %% UIControl Objects:
        instructions;
        ratEntry; %Field for entering ratID
        dayEntry; %Field for entering dayID
        cohortEntry; %Field for entering cohortID
        ratLabel; %Label above the ratEntry field
        dayLabel; %Label above the dayEntry field
        cohortLabel; %Label above the cohortEntry field
        
        %% Variables:
        ratID; %The rat's identification or litter number
        dayID; %The day of the experiment or rat's postnatal day
        cohortID; %The rat's cohort or experiment number
        dataComplete; %1 = data entry done; 0 = not done
        newLab; %Set when the lab is changed from this screen
        labName; %The lab corresponding to the rat
        cancelCall; %Indicates whether the window is hidden and the call is canceled
    end
    
    methods
        %% Function Descriptions:
        %RatScreen: constructor
        %SetRatID: Copies ratEntry into ratID
        %SetDayID: Copies dayEntry into dayID
        %SetCohortID: Copies cohortEntry into cohortID
        %Shortcuts: Checks information when user presses 'return'
        %CheckIfMissing: Ensures that no data is missing and calls Proceed
        %Proceed: Compiles chosenLab, ratID, dayID, and cohortID into a
        %file name and opens RecordScreen
        %HideWindow: Makes window invisible
        %SetLabels: Assigns text to the Label UIControl objects based on
        %lab.
        %getRatData: Returns ratID, dayID, cohortID
        
        %% Function Code:
        
        function this = RatScreen(recordScreen, lab)
            %% GUI Set Up
            this.ratID = '';
            this.dayID = '';
            this.cohortID = '';
            this.dataComplete = 0;
            this.labName = lab;
            this.cancelCall = 0;
            
            this.guiF = figure('Name', 'Enter Rat Information', 'NumberTitle', ...
                'off', 'Position', [100 300 900 400], 'WindowKeyPressFcn',...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none', 'Resize',...
                'off', 'CloseRequestFcn', @HideWindow);
            %Position [100 300] - big monitor
            %Position [100 300] - back monitor
            
            this.instructions = uicontrol('Style', 'text', 'Position',...
                [100 300 700 90], 'String',...
                {'Type in information then press Enter to continue.',...
                'Press Tab to select different entries.',...
                'Press Insert to increment the current rat number by one.',...
                'Press Home to select a different lab.'},...
                'FontSize', 14);
            
            this.ratLabel = uicontrol('Style', 'text', 'Position',...
                [100 210 200 50], 'FontSize', 14);
            
            this.dayLabel = uicontrol('Style', 'text', 'Position',...
                [350 210 200 50], 'FontSize', 14);
            
            this.cohortLabel = uicontrol('Style', 'text', 'Position',...
                [600 210 200 50], 'FontSize', 14);
            
            SetLabels(this.labName);
            
            this.ratEntry = uicontrol('Style', 'edit', 'Position',...
                [100 100 200 100], 'Callback', @SetRatID,...
                'FontSize', 13);
            
            this.dayEntry = uicontrol('Style', 'edit', 'Position',...
                [350 100 200 100], 'Callback', @SetDayID,...
                'FontSize', 13);
            
            this.cohortEntry = uicontrol('Style', 'edit', 'Position',...
                [600 100 200 100], 'Callback', @SetCohortID,...
                'FontSize', 13);
            
            uicontrol(this.ratEntry); %Puts cursor at ratEntry upon opening the figure
            
            %% Sub-constructor Functions
            function SetRatID(~, ~)
                %Data entered in the ratEntry field is copied into the
                %ratID variable.
                this.ratID = get(this.ratEntry, 'String');
                %display(this.ratID);
                uiresume(gcbf);
            end
            
            function SetDayID(~, ~)
                %Data entered in the dayEntry field is copied into the
                %dayID variable.
                this.dayID = get(this.dayEntry, 'String');
                %display(this.dayID);
                uiresume(gcbf);
            end
            
            function SetCohortID(~, ~)
                %Data entered in the cohortEntry field is copied into the
                %cohortID variable.
                this.cohortID = get(this.cohortEntry, 'String');
                %display(this.cohortID);
                uiresume(gcbf);
            end
            
            function Shortcuts(~, eventdata)
                import GUIFiles.LabScreen;
                %If the user presses 'return', this function checks that
                %all fields have information.
                switch eventdata.Key
                    case 'return'
                        uiwait(gcf); %Prevents if statement from executing until
                        %the setter function has executed for the current
                        %field with uiresume(gcbf).
                        CheckIfMissing(); %No increment
                    case 'insert'
                        CheckIfMissing(1); %Increment by 1
                    case 'home'
                        checkExistence = isobject(recordScreen.labScr);
                        if checkExistence == 0
                            recordScreen.labScr = LabScreen();
                        else
                            set(recordScreen.labScr.guiF, 'visible', 'on');
                        end
                        this.newLab = getLabName(recordScreen.labScr);
                        disp(this.newLab);
                        SetLabels(this.newLab);
                end
                
            end
            
            function CheckIfMissing(varargin)
                if ~isempty(this.ratID) && ~isempty(this.dayID) && ...
                        ~isempty(this.cohortID)
                    if ~isempty(varargin)
                        this.ratID = this.ratID + varargin{1}; %Increments ratID
                    end
                    Proceed();
                else
                    disp('Missing necessary data');
                end
            end
            
            function Proceed()
                this.dataComplete = 1; %Triggers getRatData
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function HideWindow(~,~)
                set(window, 'visible', 'off');
                this.cancelCall = 1;
                this.dataComplete = 1;
            end
            
            function SetLabels(lab)
                if strcmp(lab, 'Gibb')
                    set(this.ratLabel, 'String', 'Rat ID or Litter Number');
                    
                    set(this.dayLabel, 'String', 'Postnatal Day');
                    
                    set(this.cohortLabel, 'String', 'Experiment');
                else
                    set(this.ratLabel, 'String', 'Rat ID');
                    
                    set(this.dayLabel,'String', 'Day ID');
                    
                    set(this.cohortLabel, 'String', 'Cohort ID');
                end
            end
        end
        
        function [rat, day, cohort, modifiedLab] = getRatData(obj)
            try
                waitfor(obj, 'dataComplete', 1);
                if obj.cancelCall == 1
                    errorStruct.identifier = 'RatScreen:callCanceled';
                    error(errorStruct);
                else
                    rat = obj.ratID;
                    day = obj.dayID;
                    cohort = obj.cohortID;
                    if ~isempty(obj.newLab)
                        modifiedLab = obj.newLab;
                        obj.newLab = '';
                    else
                        modifiedLab = '';
                    end
                    obj.dataComplete = 0; %Resets value for next time the window
                    %is used.
                end
            catch ME
                obj.dataComplete = 0;
                obj.cancelCall = 0;
                rethrow(ME);
            end
        end
    end
    
end

