classdef BinaryToWavGUI < handle & matlab.mixin.SetGetExactNames
    %BinaryToWavGUI forms the bit depth choice element of the BinaryToWav
    %program
    
    properties
        bitDepth; %Desired bit depth for .wav file being produced. 
        enum %Bit depth based on enumeration in SaveFormat.
        gui; %Figure
    end
    
    methods
        function this = BinaryToWavGUI()
            import Enums.SaveFormat
            this.bitDepth = 0;
            this.enum = 0;
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 460 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close);
            uicontrol('Style', 'pushbutton', 'Position', [40 40 100 100], ...
                'String', '32 bit int', 'Callback', {@Selection, SaveFormat.Int32});
            uicontrol('Style', 'pushbutton', 'Position', [180 40 100 100], ...
                'String', '24 bit float', 'Callback', {@Selection, SaveFormat.Float24});
            uicontrol('Style', 'pushbutton', 'Position', [320 40 100 100], ...
                'String', '16 bit float', 'Callback', {@Selection, SaveFormat.Float16});
            
            function Selection (~, ~, choice)
                import Enums.SaveFormat
                this.enum = choice;
                this.bitDepth = SaveFormat.retrieveBitDepth(this.enum);
            end
            
            function close(src, ~)
                set(src, 'Visible', 'off');
                this.bitDepth = -1; %Causes program to exit
            end
        end
    end
    
end

