classdef RatScreen < GUI
    %RATSCREEN Enter the details of the rat being tested.
    %Must import the lab name from LabScreen to determine the naming
    %convention.
    %Prevent Enter from advancing if all fields haven't been entered yet.
    %Enable auto click on ratEntry.
    
    properties
        guiF;
        instructions;
        ratEntry; %Field for entering ratID
        ratID = '';
        dayEntry; %Field for entering dayID
        dayID = '';
        cohortEntry; %Field for entering cohortID
        cohortID = '';
    end
    
    methods
        function this = RatScreen()
            guiF = figure('Name', 'Enter Rat Information', 'NumberTitle', ...
                'off', 'Position', [100 100 1000 500], 'WindowKeyPressFcn',...
                @Shortcuts);
            instructions = uicontrol('Style', 'text', 'Position',...
                [100 400 800 100], 'String',...
                'Enter information then press Enter to continue. Press Tab to select different entries.');
            uicontrol('Style', 'text', 'Position', [100 300 200 100],...
                'String', 'Rat ID');
            ratEntry = uicontrol('Style', 'edit', 'Position',...
                [100 200 200 100]);
            uicontrol('Style', 'text', 'Position', [350 300 200 100],...
                'String', 'Day ID');
            dayEntry = uicontrol('Style', 'edit', 'Position',...
                [350 200 200 100]);
            uicontrol('Style', 'text', 'Position', [600 300 200 100],...
                'String', 'Cohort ID');
            cohortEntry = uicontrol('Style', 'edit', 'Position',...
                [600 200 200 100]);
            
            function Shortcuts(src, eventdata)
                %{
                if eventdata.Key == 'return'
                    if (ratID~='') && (dayID~='') && (cohortID~='')
                        Proceed();
                    else
                        display('Missing necessary data');
                    end
                end
                %}
            end
            
            function Proceed()
                display('Ready to proceed');
            end
        end
        
        
        function fig = display(guiobj)
        end
    end
    
end

