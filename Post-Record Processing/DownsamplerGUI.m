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
                'none', 'Resize', 'off', 'CloseRequestFcn', @close);
            
            
            switch this.bitDepthOriginal
                case 32
                case 24
                case 16
                otherwise
                    errorStruct.identifier = 'DownsamplerGUI:invalidBitDepth';
                    error(errorStruct);
            end
        end
    end
    
end

