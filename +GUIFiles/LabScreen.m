classdef LabScreen < GUIFiles.GUI
    %LABSCREEN Chooses the LabName.
    %To do:
    %Link to next screen - Export chosenLab
    %Enable 'go back' option
    %Make pretty
    
    properties
        guiF;
        instructions;
        eustonButton;
        gibbButton;
        metzButton;
    end
    
    methods
        function this = LabScreen()
            guiF = figure('Name', 'Select Lab', 'NumberTitle', 'off',...
                'Position', [100 100 500 500], 'WindowKeyPressFcn', ...
                @Shortcuts, 'ToolBar', 'none');
            instructions = uicontrol('Style', 'text', 'Position', ...
                [10 450 400 30], 'String', ...
                'Which lab is running this experiment?');
            eustonButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 350 400 50], 'String', 'Euston (e)', ...
                'Callback', {@Selection, 'e'});
            gibbButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 250 400 50], 'String', 'Gibb (g)', ...
                'Callback', {@Selection, 'g'});
            metzButton = uicontrol('Style', 'pushbutton', 'Position', ...
                [20 150 400 50], 'String', 'Metz (m)', ...
                'Callback', {@Selection, 'm'});
            
                
            function Shortcuts(src, eventdata)
                %Key press shortcuts go straight to Selection function
                Selection(src, eventdata, eventdata.Key);
            end
            
            function chosenLab = Selection(~, ~, choice)
                %Selects lab
                import Enums.LabName;
                switch choice
                    case {'e'}
                        chosenLab = LabName.Euston;
                        %'Chose Euston'
                    case {'g'}
                        chosenLab = LabName.Gibb;
                        %'Chose Gibb'
                    case {'m'}
                        chosenLab = LabName.Metz;
                        %'Chose Metz'
                end
                disp(chosenLab);
            end
            
        end
        
        function fig = display(guiobj)
        end
    end
    
end

