classdef LabScreen < GUI
    %LABSCREEN Chooses the LabName.
    
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
                @Shortcuts);
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
                Selection(src, eventdata, eventdata.Key);
                %{
                switch eventdata.Key
                    case {'e'}
                        
                    case {'g'}
                        
                    case {'m'}
                        
                end
                %}
            end
            
            function chosenLab = Selection(src, eventdata, choice)
                import Enums.LabName;
                switch choice
                    case {'e'}
                        chosenLab = LabName.Euston;
                        %'Chose Euston'
                    case {'g'}
                        chosenLab = LabName.Gibb;
                    case {'m'}
                        chosenLab = LabName.Metz;
                end
                chosenLab
            end
            
        end
        
        function fig = display(guiobj)
        end
    end
    
end

