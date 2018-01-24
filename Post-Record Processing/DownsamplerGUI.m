classdef DownsamplerGUI < handle & matlab.mixin.SetGetExactNames
    %DownsamplerGUI allows selection of appropriate bit depth.
    %   Detailed explanation goes here
    
    properties
        bitDepthOriginal;
        bitDepthNew;
        gui;
    end
    
    methods
        function this = DownsamplerGUI(openedBit)
            this.bitDepthOriginal = openedBit;
            this.bitDepthNew = 0;
            
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 460 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close, ...
                'Visible', 'off');
            
            switch this.bitDepthOriginal
                case 32
                    uicontrol('Style', 'text', 'Position', [50 150 200 100],...
                        'String', ...
                        'You have imported a 32 bit int file. What format would you like to convert to?');
                        
                    uicontrol('Style', 'pushbutton', 'Position',...
                        [40 40 100 100], 'String', '24 bit float', ...
                        'Callback', {@Selection, 24});
                    uicontrol('Style', 'Style', 'pushbutton', 'Position', ...
                        [240 40 100 100], 'String', '16 bit float', ...
                        'Callback', {@Selection, 16});
                    set(this.gui, 'Visible', 'on');
                    
                case 24
                    uicontrol('Style', 'text', 'Position', [50 150 200 100],...
                        'String', ...
                        'You have imported a 24 bit float file. Would you like to convert to a 16 bit float?');
                        
                    uicontrol('Style', 'pushbutton', 'Position',...
                        [40 40 100 100], 'String', 'Yes', ...
                        'Callback', {@Selection, 16});
                    uicontrol('Style', 'Style', 'pushbutton', 'Position', ...
                        [240 40 100 100], 'String', 'No', ...
                        'Callback', {@Selection, -1});
                    set(this.gui, 'Visible', 'on');
                case 16
                    msgbox('The file is already at the lowest bit depth (16 bit) and cannot be converted.');
                otherwise
                    errorStruct.identifier = 'DownsamplerGUI:invalidBitDepth';
                    error(errorStruct);
            end
            
            function Selection (~, ~, choice)
                this.bitDepthNew = choice;
            end
            
            function close(src, ~)
                set(src, 'Visible', 'off');
                this.bitDepthNew = -1;
            end
        end
    end
    
end

