 classdef DownsamplerGUI < handle & matlab.mixin.SetGetExactNames
    %DownsamplerGUI forms the bit depth choice element of the Downsampler
    %program
    %GUI options are based off of SaveFormat enumeration options. Changes
    %to SaveFormat must be reflected here.
    
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
        %% Function Descriptions:
        %DownsamplerGUI: constructor
        %Selection: Assigns appropriate SaveFormat enumeration to enumNew
        %close: Closes window before selection is made
        
        function this = DownsamplerGUI(openedBit)
            %Input: bit depth of opened WAVE file
            
            import Enums.SaveFormat
            this.bitDepthOriginal = openedBit;
            this.bitDepthNew = 0;
            this.enumNew = 0;
            this.guiComplete = 0;
            
            %% GUI Set Up
            
            this.gui = figure('Name', 'Choose Bit Depth', 'NumberTitle', 'off', ...
                'Position', [500 500 320 180], 'Toolbar', 'none', 'Menubar', ...
                'none', 'Resize', 'off', 'CloseRequestFcn', @close, ...
                'Visible', 'off');
            
            switch this.bitDepthOriginal
                %GUI format depends on the input bit depth
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
            
            %% Sub-constructor Functions
            
            function Selection (~, ~, choice)
                %Derive values from button press
                import Enums.SaveFormat
                this.enumNew = choice;
                if ~isnumeric(this.enumNew)
                    %Numeric value for enumNew marks the program for
                    %premature exit. retrieveBitDepth cannot take a numeric
                    %input.
                    this.bitDepthNew = SaveFormat.retrieveBitDepth(this.enumNew);
                end
                set(this.gui, 'Visible', 'off');
                this.guiComplete = 1;
            end
            
            function close(src, ~)
                %Close GUI instead of selecting bit depth
                set(src, 'Visible', 'off');
                this.enumNew = -1; %Causes program to exit
                this.guiComplete = 1;
            end
        end
    end
    
end

