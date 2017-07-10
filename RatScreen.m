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
                
                if eventdata.Key == 'return'
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

