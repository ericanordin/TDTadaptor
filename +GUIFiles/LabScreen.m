classdef LabScreen < handle & matlab.mixin.SetGetExactNames
    %LABSCREEN Chooses the LabName.
    %To do:
    %Make pretty
    %Write destructor
    
    properties
        %% Figures:
        guiF;
        
        %% UIControl Objects:
        instructions;
        eustonButton; %Push button that selects Euston directory and
        %naming format
        gibbButton; %Push button that selects Gibb directory and
        %naming format
        metzButton; %Push button that selects Metz directory and
        %naming format
        otherButton; %Push button that selects the default directory and
        %uses the Euston naming format
        
        %% Variables:
        chosenLab; %Selected lab
        
    end
    
    methods
        %% Function Descriptions:
        %LabScreen: constructor
        %Shortcuts: enables keyboard shortcuts
        %Selection: assigns appropriate enumeration to chosenLab
        %HideWindow: Makes the window invisible
        %getLabName: returns chosenLab
        
        %% Function Code:
        
        function this = LabScreen()
            %% GUI Set Up
            
            this.chosenLab = 'Not Set';
            
            this.guiF = figure('Name', 'Select Lab', 'NumberTitle', 'off',...
                'Position', [100 300 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none',...
                'Resize', 'off', 'CloseRequestFcn', @HideWindow);
            
            this.instructions = uicontrol('Style', 'text', 'Position', ...
                [25 420 450 50], 'FontSize', 14, 'String', ...
                'Which lab is running this experiment?');
            
            this.eustonButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [50 350 400 50], 'String', 'Euston (e)', 'FontSize', 13,...
                'Callback', {@Selection, 'e'});
            
            this.gibbButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [50 250 400 50], 'String', 'Gibb (g)', 'FontSize', 13,...
                'Callback', {@Selection, 'g'});
            
            this.metzButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [50 150 400 50], 'String', 'Metz (m)', 'FontSize', 13,...
                'Callback', {@Selection, 'm'});
            
            this.otherButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [50 50 400 50], 'String', 'Other (o)', 'FontSize', 13,...
                'Callback', {@Selection, 'o'});
            
            %%
            %{
            set(guiF, 'visible', 'off');
            ready = input('Type 1 if ready');
            if ready == 1
                disp('Got in ready');
                set(guiF, 'visible', 'on');
            end
            %}
            %% Sub-constructor Functions:
            
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
                %disp(this.chosenLab);
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function HideWindow(~,~)
                import StandardFunctions.generalHideWindow;
                generalHideWindow(this.guiF);
                disp('Producing function cancellation');
                this.chosenLab = 'CANCEL';
                %errorStruct.identifier = 'LabScreen:callCanceled';
                %error(errorStruct);
                %disp('In HideWindow');
                %set(this.guiF, 'visible', 'off'); %Makes window invisible
                %exit;
            end
            
        end
        
        function labName = getLabName(obj)
            originalLab = obj.chosenLab;
            try
                waitfor(obj, 'chosenLab'); %Function waits to elapse until
                %nameType has been changed.
                if ischar(obj.chosenLab)
                    obj.chosenLab = originalLab;
                    disp('String');
                    errorStruct.identifier = 'LabScreen:callCanceled';
                    error(errorStruct);
                else
                    labName = obj.chosenLab;
                    disp('Not string');
                end
                
            catch ME
                rethrow(ME);
            end
        end
    end
    
end

