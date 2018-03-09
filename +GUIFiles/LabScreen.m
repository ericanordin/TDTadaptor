classdef LabScreen < handle & matlab.mixin.SetGetExactNames
    %LABSCREEN Chooses the labName from RecordScreen.
    %   Hidden instead of deleted after use for repeated access.
    
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
        %LabScreen: Constructor
        %Shortcuts: Enables keyboard shortcuts
        %Selection: Assigns appropriate enumeration to chosenLab
        %ExitWindow: Makes the window invisible and terminates auto naming
        %getLabName: Returns chosenLab
        
        %% Function Code:
        
        function this = LabScreen()
            %% GUI Set Up
            
            this.chosenLab = 'Not Set';
            
            this.guiF = figure('Name', 'Select Lab', 'NumberTitle', 'off',...
                'Position', [100 300 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none', 'MenuBar', 'none',...
                'Resize', 'off', 'CloseRequestFcn', @ExitWindow);
            
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
            
            %% Sub-constructor Functions:
            
            function Shortcuts(src, eventdata)
                %Key press shortcuts go straight to Selection function
                Selection(src, eventdata, eventdata.Key);
            end
            
            function Selection(~, ~, choice)
                %Assigns LabName enumeration to chosenLab
                import Enums.LabName;
                switch choice
                    case {'e'}
                        this.chosenLab = LabName.Euston;
                    case {'g'}
                        this.chosenLab = LabName.Gibb;
                    case {'m'}
                        this.chosenLab = LabName.Metz;
                    case {'o'}
                        this.chosenLab = LabName.Other;
                    otherwise
                        this.chosenLab = 'CANCEL';
                end
                set(this.guiF, 'visible', 'off'); %Makes window invisible
            end
            
            function ExitWindow(~,~)
                set(this.guiF, 'visible', 'off');
                this.chosenLab = 'CANCEL';
            end
            
        end
        
        function labName = getLabName(obj)
            originalLab = obj.chosenLab;
            %Maintains original value in case of premature exit
            try
                waitfor(obj, 'chosenLab'); %Function waits to elapse until
                %nameType has been changed.
                if ischar(obj.chosenLab) %Not enum, invalid
                    obj.chosenLab = originalLab;
                    errorStruct.identifier = 'LabScreen:callCanceled';
                    error(errorStruct);
                else
                    labName = obj.chosenLab;
                end
                
            catch ME
                rethrow(ME);
            end
        end
    end
    
end

