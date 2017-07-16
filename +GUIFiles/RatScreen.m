classdef RatScreen < GUIFiles.GUI
%RATSCREEN Enter the details of the rat being tested.
    %To do:
    %Link to next screen - Import chosenLab from LabScreen to determine 
    %the naming convention.
    %Write destructor
    %Complete Proceed function
    
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
        %display: may or may not be enabled
        
        function this = RatScreen()
            ratID = '';
            dayID = '';
            cohortID = '';
            
            guiF = figure('Name', 'Enter Rat Information', 'NumberTitle', ...
                'off', 'Position', [100 100 1000 500], 'WindowKeyPressFcn',...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none');
            
            instructions = uicontrol('Style', 'text', 'Position',...
                [100 400 800 100], 'String',...
                'Type in information then press Enter to continue. Press Tab to select different entries.');
            
            uicontrol('Style', 'text', 'Position', [100 300 200 100],...
                'String', 'Rat ID');
            
            ratEntry = uicontrol('Style', 'edit', 'Position',...
                [100 200 200 100], 'Callback', @SetRatID);
            
            uicontrol('Style', 'text', 'Position', [350 300 200 100],...
                'String', 'Day ID');
            
            dayEntry = uicontrol('Style', 'edit', 'Position',...
                [350 200 200 100], 'Callback', @SetDayID);
            
            uicontrol('Style', 'text', 'Position', [600 300 200 100],...
                'String', 'Cohort ID');
            
            cohortEntry = uicontrol('Style', 'edit', 'Position',...
                [600 200 200 100], 'Callback', @SetCohortID);
            
            uicontrol(ratEntry); %Puts cursor at ratEntry upon opening the figure
            
            function SetRatID(~, ~)
                %Data entered in the ratEntry field is copied into the
                %ratID variable.
                ratID = get(ratEntry, 'String');
                display(ratID);
                uiresume(gcbf);
            end
            
            function SetDayID(~, ~)
                %Data entered in the dayEntry field is copied into the
                %dayID variable.
                dayID = get(dayEntry, 'String');
                display(dayID);
                uiresume(gcbf);
            end
            
            function SetCohortID(~, ~)
                %Data entered in the cohortEntry field is copied into the
                %cohortID variable.
                cohortID = get(cohortEntry, 'String');
                display(cohortID);
                uiresume(gcbf);
            end
            
            function Shortcuts(~, eventdata)
                %If the user presses 'return', this function checks that
                %all fields have information.
                if strcmp(eventdata.Key, 'return')
                    uiwait(gcf); %Prevents if statement from executing until
                    %the setter function has executed for the current
                    %field with uiresume(gcbf).
                    display(ratID);
                    display(dayID);
                    display(cohortID);
                    if ~isempty(ratID) && ~isempty(dayID) && ~isempty(cohortID)
                        Proceed();
                    else
                        disp('Missing necessary data');
                    end

                end
                
            end
            
            function Proceed()
                %Currently empty; will advance to recording screen.
                disp('Ready to proceed');
                close(guiF);
            end
        end
        
        
        function fig = display(guiobj)
        end
    end
    
end

