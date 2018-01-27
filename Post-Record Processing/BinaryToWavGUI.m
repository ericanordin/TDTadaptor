classdef BinaryToWavGUI < handle & matlab.mixin.SetGetExactNames
    %BinaryToWavGUI forms the bit depth choice element of the BinaryToWav
    %program
    
    properties
        bitDepth; %Desired bit depth for .wav file being produced
        gui; %Figure
    end
    
    methods
        function this = BinaryToWavGUI()
            this.bitDepth = 0;
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 460 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close);
            uicontrol('Style', 'pushbutton', 'Position', [40 40 100 100], ...
                'String', '32 bit int', 'Callback', {@Selection, 32});
            uicontrol('Style', 'pushbutton', 'Position', [180 40 100 100], ...
                'String', '24 bit float', 'Callback', {@Selection, 24});
            uicontrol('Style', 'pushbutton', 'Position', [320 40 100 100], ...
                'String', '16 bit float', 'Callback', {@Selection, 16});
            
            function Selection (~, ~, choice)
                this.bitDepth = choice;
            end
            
            function close(src, ~)
                set(src, 'Visible', 'off');
                this.bitDepth = -1; %Causes program to exit
            end
        end
    end
    
end

