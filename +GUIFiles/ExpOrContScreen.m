classdef ExpOrContScreen < handle & matlab.mixin.SetGetExactNames
%EXPORCONTSCREEN Opens a GUI to specify whether that rat is experimental or
%control.
%   This function is only relevant for the Metz lab.

    properties
        %% Figures:
        guiF;
        
        %% UIControl Objects:
        instructions;
        experimentalButton; %Push button that selects the Experimental subfolder
        controlButton; %Push button that selects the Control subfolder       
        
        %% Variables:
        subfolderName; %The selection of experimental or control
        
    end
    
    methods
        %% Function Descriptions:
        %ExpOrContScreen: constructor
        %Shortcuts: enables keyboard shortcuts
        %Selection: assigns appropriate string to choice
        %getExpOrCont: returns subfolderName
        
        %% Function Code:        
        function this = ExpOrContScreen()
            %% GUI Set Up
            this.guiF = figure('Name', 'Subfolder', 'NumberTitle', 'off',...
                'Position', [150 620 500 300], 'ToolBar', 'none',...
                'MenuBar', 'none', 'Resize', 'off', 'WindowKeyPressFcn',...
                @Shortcuts);
            this.instructions = uicontrol('Style', 'text', 'Position',...
                [30 190 440 70], 'String',...
                'Is this an experimental or a control rat?',...
                'FontSize', 14);
            this.experimentalButton = uicontrol('Style', 'pushbutton',...
                'Position', [50 100 150 100], 'String', 'Experimental (e)',...
                'Callback', {@Selection, 'e'}, 'FontSize', 13);
            this.controlButton = uicontrol('Style', 'pushbutton',...
                'Position', [300 100 150 100], 'String', 'Control (c)',...
                'Callback', {@Selection, 'c'}, 'FontSize', 13);
            
            %% Sub-constructor Functions
            function Shortcuts(src, eventdata)
                %Key press shortcuts go straight to Selection function
                Selection(src, eventdata, eventdata.Key);
            end
            
            function Selection(~, ~, choice)
                switch choice
                    case {'e'}
                        this.subfolderName = 'Experimental';
                    case {'c'}
                        this.subfolderName = 'Control';
                end                
            end
            
        end
        
        function subfolder = getExpOrCont(obj)
            waitfor(obj, 'subfolderName');
            subfolder = obj.subfolderName;
            close(obj.guiF);
        end
        
    end
end

