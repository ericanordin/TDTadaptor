classdef BinaryToWavGUI < handle & matlab.mixin.SetGetExactNames
    %BinaryToWavGUI forms the bit depth choice element of the BinaryToWav
    %program
    %GUI options are based off of SaveFormat enumeration options. Changes
    %to SaveFormat must be reflected here.
    
    properties
        %% Figures:
        gui; %Figure
        
        %% Variables:
        bitDepth; %Desired bit depth for .wav file being produced. 
        enum %Bit depth based on enumeration in SaveFormat.        
    end
    
    methods
        %% Function Descriptions:
        %BinaryToWavGUI: constructor
        %Selection: Assigns appropriate SaveFormat enumeration to enumNew
        %close: Closes window before selection is made
        
        function this = BinaryToWavGUI()
            import Enums.SaveFormat
            this.bitDepth = 0;
            this.enum = 0;
            
            %% GUI Set Up
            
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 460 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close);
            uicontrol('Style', 'pushbutton', 'Position', [40 40 100 100], ...
                'String', '32 bit int', 'Callback', {@Selection, SaveFormat.Int32});
            uicontrol('Style', 'pushbutton', 'Position', [180 40 100 100], ...
                'String', '24 bit float', 'Callback', {@Selection, SaveFormat.Float24});
            uicontrol('Style', 'pushbutton', 'Position', [320 40 100 100], ...
                'String', '16 bit float', 'Callback', {@Selection, SaveFormat.Float16});
            
            %% Sub-constructor Functions
            
            function Selection (~, ~, choice)
                %Derive values from button press
                import Enums.SaveFormat
                this.enum = choice;
                this.bitDepth = SaveFormat.retrieveBitDepth(this.enum);
            end
            
            function close(src, ~)
                %Close GUI instead of selecting bit depth
                set(src, 'Visible', 'off');
                this.bitDepth = -1; %Causes program to exit
            end
        end
    end
    
end

