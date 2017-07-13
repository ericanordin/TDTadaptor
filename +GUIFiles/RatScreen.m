classdef RatScreen < GUIFiles.GUI
%RATSCREEN Enter the details of the rat being tested.
    %To do:
    %Link to next screen - Import c from LabScreen to determine the naming
    %convention.
    %Ensure that Enter performs callback on current field before checking completeness.
    %Enable auto click on ratEntry.
    
    properties
        guiF;
        instructions;
        ratEntry; %Field for entering ratID
        ratID;
        dayEntry; %Field for entering dayID
        dayID;
        cohortEntry; %Field for entering cohortID
        cohortID;
        %numTabs; %The number of edit fields reflecting the number of tabs 
        %that must be made to reset the cursor to its original position
    end
    
    methods
        function this = RatScreen()
            ratID = '';
            dayID = '';
            cohortID = '';
            %numTabs = 3;
            guiF = figure('Name', 'Enter Rat Information', 'NumberTitle', ...
                'off', 'Position', [100 100 1000 500], 'WindowKeyPressFcn',...
                @Shortcuts);
            instructions = uicontrol('Style', 'text', 'Position',...
                [100 400 800 100], 'String',...
                'Enter information then press Enter to continue. Press Tab to select different entries.');
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
                %all field have information.
                if strcmp(eventdata.Key, 'return')
                    uiwait(gcf);
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
            end
        end
        
        
        function fig = display(guiobj)
        end
    end
    
end

