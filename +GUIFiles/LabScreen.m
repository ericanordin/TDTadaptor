classdef LabScreen < handle & matlab.mixin.SetGetExactNames & GUIFiles.GUI
    %LABSCREEN Chooses the LabName.
    %To do:
    %Make pretty
    %Write destructor
    
    properties
        %Figures:
        guiF;
        
        %UIControl Objects:
        instructions;
        eustonButton; %Push button that selects Euston directory and 
        %naming format
        gibbButton; %Push button that selects Gibb directory and 
        %naming format
        metzButton; %Push button that selects Metz directory and 
        %naming format
        otherButton; %Push button that selects the default directory and 
        %uses the Euston naming format
        
        %Variables:
        chosenLab; %Selected lab
    end
    
    methods
        %Functions:
        %LabScreen: constructor
        %Shortcuts: enables keyboard shortcuts
        %Selection: assigns appropriate enumeration to chosenLab
        %HideWindow: Makes the window invisible
        %getLabName: returns chosenLab
        %display: may or may not be enabled
        
        function this = LabScreen()
            this.guiF = figure('Name', 'Select Lab', 'NumberTitle', 'off',...
                'Position', [100 100 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none',...
                'Resize', 'off', 'CloseRequestFcn', @HideWindow);
            
            this.instructions = uicontrol('Style', 'text', 'Position', ...
                [10 450 400 30], 'String', ...
                'Which lab is running this experiment?');
            
            this.eustonButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 350 400 50], 'String', 'Euston (e)', ...
                'Callback', {@Selection, 'e'});
            
            this.gibbButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 250 400 50], 'String', 'Gibb (g)', ...
                'Callback', {@Selection, 'g'});
            
            this.metzButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 150 400 50], 'String', 'Metz (m)', ...
                'Callback', {@Selection, 'm'});
            
            this.otherButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 50 400 50], 'String', 'Other (o)', ...
                'Callback', {@Selection, 'o'});
            %{
            set(guiF, 'visible', 'off');
            ready = input('Type 1 if ready');
            if ready == 1
                disp('Got in ready');
                set(guiF, 'visible', 'on');
            end
                %}
            function Shortcuts(src, eventdata)
                %Key press shortcuts go straight to Selection function
                Selection(src, eventdata, eventdata.Key);
            end
            
            function chosenLab = Selection(~, ~, choice)
                %Assigns LabName enumeration to chosenLab
                import Enums.LabName;
                switch choice
                    case {'e'}
                        this.chosenLab = LabName.Euston;
                        %'Chose Euston'
                    case {'g'}
                        this.chosenLab = LabName.Gibb;
                        %'Chose Gibb'
                    case {'m'}
                        this.chosenLab = LabName.Metz;
                        %'Chose Metz'
                    case {'o'}
                        this.chosenLab = LabName.Other;
                        %'Chose Other'
                end
                disp(this.chosenLab);
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function HideWindow(~,~)
                disp('In HideWindow');
                set(this.guiF, 'visible', 'off'); %Makes window invisible
                %exit;
            end            
        end
        
        function labName = getLabName(obj)
            waitfor(obj, 'chosenLab'); %Function waits to elapse until
           %nameType has been changed.
           labName = obj.chosenLab;
        end
        
        function fig = display(guiobj)
        end
        
       % function fig = get.guiF(figObj)
        %    fig = figObj.guiF;
        %end
    end
    
end

