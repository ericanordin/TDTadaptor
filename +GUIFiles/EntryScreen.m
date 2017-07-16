classdef EntryScreen < GUIFiles.GUI
    %ENTRYSCREEN Offers the choice of Auto vs Manual naming.
    %To do:
    %Link to next screen - Export nameType.
    %Make pretty
    
    properties
        guiF;
        instructions;
        autoButton; %Pressing this takes the user through the LabScreen and
        %RatScreen GUIs to enter the relevant information. When
        %RecordScreen is opened, the file name and its storage location
        %will already be determined.
        manualButton; %Pressing this takes the user directly to RecordScreen.
        %The user will have to name their file and determine its pathway
        %themselves.
    end
    
    methods
        function this = EntryScreen()
            
            guiF = figure('Name', 'Select Naming Method', 'NumberTitle',...
                'off', 'Position', [100 100 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none');
            instructions = uicontrol('Style', 'text', 'Position', ...
                [10 450 400 30], 'String', ...
                'Would you like to name your file yourself, or let me do it for you?');
            autoButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [10 200 200 150], 'String', 'Name Automatically (a)', ...
                'Callback', @AutoName);
            manualButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [260 200 200 150], 'String', 'Name Manually (m)', ...
                'Callback', @ManualName);
            
            function nameType = AutoName(~, ~)
                import Enums.NamingMethod;
                nameType = NamingMethod.Auto;
                disp(nameType);
            end
            function nameType = ManualName(~, ~)
                import Enums.NamingMethod;
                nameType = NamingMethod.Manual;
                disp(nameType);
            end
            function Shortcuts(~, eventdata)
                %Allows the user to use keyboard shortcuts to select the
                %push buttons.
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

