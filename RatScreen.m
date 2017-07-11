classdef RatScreen < GUI
    %RATSCREEN Enter the details of the rat being tested.
    %Must import the lab name from LabScreen to determine the naming
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
    end
    
    methods
        function this = RatScreen()
            ratID = '';
            dayID = '';
            cohortID = '';
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
            
            function SetRatID(src, ~)
                ratID = get(ratEntry, 'String');
                %{
                if isempty(ratID)
                    display('Evaluating empty');
                    ratID = '';
                else
                    display('Not evaluating empty');
                end
                %}
                display(ratID);
            end
            
            function SetDayID(src, ~)
                dayID = get(dayEntry, 'String');
                display(dayID);
            end
            
            function SetCohortID(src, ~)
                cohortID = get(cohortEntry, 'String');
                display(cohortID);
            end
            
            function Shortcuts(src, eventdata)
                %Produces a Java robot to execute 3 tabs so that all fields
                %are updated before 'return' is evaluated and the cursor
                %returns to its original position. Without this, the latest
                %field does not update its variable before completion is
                %evaluated.
                import java.awt.Robot
                import java.awt.event.*
                rob = Robot;
                
                if eventdata.Key == 'return'
                    %{    
                    rob.keyPress(java.awt.event.KeyEvent.VK_TAB);
                        rob.keyRelease(java.awt.event.KeyEvent.VK_TAB);
                        rob.keyPress(java.awt.event.KeyEvent.VK_TAB);
                        rob.keyRelease(java.awt.event.KeyEvent.VK_TAB);
                        rob.keyPress(java.awt.event.KeyEvent.VK_TAB);
                        rob.keyRelease(java.awt.event.KeyEvent.VK_TAB);
                    %}
                    %Problem: callback to update data is not executing
                    %before if statement. Must find a way to execute
                    %robot buttons beforehand.
                    rob.mouseMove(410, 1410);
                    rob.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
                        display(ratID);
                        display(dayID);
                        display(cohortID);
                    if ~isempty(ratID) && ~isempty(dayID) && ~isempty(cohortID)
                        Proceed();
                    else
                        display('Missing necessary data');
                    end
                end
                
            end
            
            function Proceed()
                display('Ready to proceed');
            end
        end
        
        
        function fig = display(guiobj)
        end
    end
    
end

