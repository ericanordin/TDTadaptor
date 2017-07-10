classdef EntryScreen < GUI
    %ENTRYSCREEN Offers the choice of Auto vs Manual naming.
    
    properties
        guiF;
        instructions;
        autoButton;
        manualButton;
    end
    
    methods
        function this = EntryScreen()
            guiF = figure('Name', 'Select Naming Method', 'NumberTitle',...
                'off', 'Position', [100 100 500 500]);
            instructions = uicontrol('Style', 'text', 'Position', ...
                [10 450 400 30], 'String', ...
                'Would you like to name your file yourself, or let me do it for you?');
            autoButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [10 200 200 150], 'String', 'Name Automatically (a)');
            manualButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [260 200 200 150], 'String', 'Name Manually (m)');
        end
        
        function fig = display(guiobj)
        
        end
    end
    
end

