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
                'off', 'Position', [100 100 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts);
            instructions = uicontrol('Style', 'text', 'Position', ...
                [10 450 400 30], 'String', ...
                'Would you like to name your file yourself, or let me do it for you?');
            autoButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [10 200 200 150], 'String', 'Name Automatically (a)', ...
                'Callback', @AutoName);
            manualButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [260 200 200 150], 'String', 'Name Manually (m)', ...
                'Callback', @ManualName);
            
            function nameType = AutoName(src, ~)
                import Enums.NamingMethod;
                nameType = NamingMethod.Auto;
                nameType
            end
            function nameType = ManualName(src, ~)
                import Enums.NamingMethod;
                nameType = NamingMethod.Manual;
                nameType
            end
            function Shortcuts(src, eventdata)
                switch eventdata.Key
                    case {'a'}
                        AutoName();
                    case {'m'}
                        ManualName();   
                end
            end
        end
        
        function fig = display(guiobj)
        
        end
        
        
        
    end
    
end

