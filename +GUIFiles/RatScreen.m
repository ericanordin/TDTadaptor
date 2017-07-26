classdef RatScreen < handle & matlab.mixin.SetGetExactNames & GUIFiles.GUI
    %RATSCREEN Enter the details of the rat being tested.
    %To do:
    %Add button to select new lab
    %Button to increase rat number by 1.
    %Write destructor
    %Make pretty
    
    properties
        %Figures:
        guiF;
        
        %UIControl Objects:
        instructions;
        ratEntry; %Field for entering ratID
        dayEntry; %Field for entering dayID
        cohortEntry; %Field for entering cohortID
        
        %Variables:
        ratID;
        dayID;
        cohortID;
        dataComplete; %1 = data entry done; 0 = not done
    end
    
    methods
        %Functions:
        %RatScreen: constructor
        %SetRatID: Copies ratEntry into ratID
        %SetDayID: Copies dayEntry into dayID
        %SetCohortID: Copies cohortEntry into cohortID
        %Shortcuts: Checks information when user presses 'return'
        %Proceed: Compiles chosenLab, ratID, dayID, and cohortID into a
        %file name and opens RecordScreen
        %getRatData: Returns ratID, dayID, cohortID
        %HideWindow: Makes the window invisible
        %display: may or may not be enabled
        
        function this = RatScreen()
            this.ratID = '';
            this.dayID = '';
            this.cohortID = '';
            this.dataComplete = 0;
            
            this.guiF = figure('Name', 'Enter Rat Information', 'NumberTitle', ...
                'off', 'Position', [100 100 1000 500], 'WindowKeyPressFcn',...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none', 'Resize',...
                'off', 'DeleteFcn', @HideWindow);
            
            this.instructions = uicontrol('Style', 'text', 'Position',...
                [100 400 800 100], 'String',...
                'Type in information then press Enter to continue. Press Tab to select different entries. Press Insert to increment the current rat number by one.');
            
            uicontrol('Style', 'text', 'Position', [100 300 200 100],...
                'String', 'Rat ID');
            
            this.ratEntry = uicontrol('Style', 'edit', 'Position',...
                [100 200 200 100], 'Callback', @SetRatID);
            
            uicontrol('Style', 'text', 'Position', [350 300 200 100],...
                'String', 'Day ID');
            
            this.dayEntry = uicontrol('Style', 'edit', 'Position',...
                [350 200 200 100], 'Callback', @SetDayID);
            
            uicontrol('Style', 'text', 'Position', [600 300 200 100],...
                'String', 'Cohort ID');
            
            this.cohortEntry = uicontrol('Style', 'edit', 'Position',...
                [600 200 200 100], 'Callback', @SetCohortID);
            
            uicontrol(this.ratEntry); %Puts cursor at ratEntry upon opening the figure
            
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
                end
                
            end
            
            function CheckIfMissing(varargin)
                if ~isempty(this.ratID) && ~isempty(this.dayID) && ...
                        ~isempty(this.cohortID)
                    if ~isempty(varargin)
                        this.ratID = this.ratID + varargin{1};
                    end
                    Proceed();
                else
                    disp('Missing necessary data');
                end
            end
            
            function Proceed()
                this.dataComplete = 1; %Triggers getRatData
                disp('Ready to proceed');
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function HideWindow(~,~)
                disp('In HideWindow');
                set(this.guiF, 'visible', 'off'); %Makes window invisible
                %exit;
            end
        end
        
        function [rat, day, cohort] = getRatData(obj)
            waitfor(obj, 'dataComplete', 1);
            rat = obj.ratID;
            day = obj.dayID;
            cohort = obj.cohortID;
            obj.dataComplete = 0; %Resets value for next time the window
            %is used.
        end
        
        function fig = display(guiobj)
        end
    end
    
end

