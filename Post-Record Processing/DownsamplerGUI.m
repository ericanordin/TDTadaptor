 classdef DownsamplerGUI < handle & matlab.mixin.SetGetExactNames
    %DownsamplerGUI allows selection of appropriate bit depth.
    %   Assumes the bit depths available are 16, 24, and 32
    
    properties
        %% Figures:
        gui;
        
        %% Variables:
        bitDepthOriginal; %Bit depth of file opened for conversion
        bitDepthNew; %Desired bit depth of new file
        enumNew; %SaveFormat enum for new file
        guiComplete; %Binary; indicates whether the selection process has been completed
    end
    
    methods
        function this = DownsamplerGUI(openedBit)
            import Enums.SaveFormat
            this.bitDepthOriginal = openedBit;
            this.bitDepthNew = 0;
            this.enumNew = 0;
            this.guiComplete = 0;
            
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 320 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close, ...
                'Visible', 'off');
            
            switch this.bitDepthOriginal
                case 32
                    uicontrol('Style', 'text', 'Position', [50 140 220 30],...
                        'String', ...
                        'You have imported a 32 bit file. What format would you like to convert to?');
                        
                    uicontrol('Style', 'pushbutton', 'Position',...
                        [40 30 100 100], 'String', '24 bit float', ...
                        'Callback', {@Selection, SaveFormat.Float24});
                    uicontrol('Style', 'pushbutton', 'Position', ...
                        [180 30 100 100], 'String', '16 bit float', ...
                        'Callback', {@Selection, SaveFormat.Float16});
                    set(this.gui, 'Visible', 'on');
                    
                case 24
                    uicontrol('Style', 'text', 'Position', [50 140 220 30],...
                        'String', ...
                        'You have imported a 24 bit file. Would you like to convert to a 16 bit float?');
                        
                    uicontrol('Style', 'pushbutton', 'Position',...
                        [40 30 100 100], 'String', 'Yes', ...
                        'Callback', {@Selection, SaveFormat.Float16});
                    uicontrol('Style', 'pushbutton', 'Position', ...
                        [180 30 100 100], 'String', 'No', ...
                        'Callback', {@Selection, -1});
                    set(this.gui, 'Visible', 'on');
                case 16
                    Selection(0,0,-3); 
                    %Cannot be scaled down, causes program to exit
                otherwise
                    Selection(0,0,-2); %Causes program to exit
            end
            
            function Selection (~, ~, choice)
                import Enums.SaveFormat
                this.enumNew = choice;
                if ~isnumeric(this.enumNew)
                    this.bitDepthNew = SaveFormat.retrieveBitDepth(this.enumNew);
                end
                set(this.gui, 'Visible', 'off');
                this.guiComplete = 1;
            end
            
            function close(src, ~)
                set(src, 'Visible', 'off');
                this.bitDepthNew = -1; %Causes program to exit
                this.guiComplete = 1;
            end
        end
    end
    
end

