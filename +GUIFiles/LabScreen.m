classdef LabScreen < handle & matlab.mixin.SetGetExactNames & GUIFiles.GUI
    %LABSCREEN Chooses the LabName.
    %To do:
    %Enable 'go back' option
    %Make pretty
    %Write destructor
    
    properties
        %Figures:
        guiF;
        
        %UIControl Objects:
        instructions;
        eustonButton; %Push button that selects Euston naming format
        gibbButton; %Push button that selects Gibb naming format
        metzButton; %Push button that selects Metz naming format
        
        %Variables:
        chosenLab; %Selected lab
    end
    
    methods
        %Functions:
        %LabScreen: constructor
        %Shortcuts: enables keyboard shortcuts
        %Selection: assigns appropriate enumeration to chosenLab
        %CloseProgram: Exits the program
        %display: may or may not be enabled
        
        function this = LabScreen()
            this.guiF = figure('Name', 'Select Lab', 'NumberTitle', 'off',...
                'Position', [100 100 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none',...
                'Resize', 'off', 'DeleteFcn', @CloseProgram);
            
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
                end
                disp(this.chosenLab);
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function CloseProgram(~,~)
                disp('In CloseProgram');
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

