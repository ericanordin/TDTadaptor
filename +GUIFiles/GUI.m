classdef (Abstract) GUI < handle & matlab.mixin.SetGetExactNames
    %GUI Defines an abstract superclass for the various GUI components of 
    %the program.
    %To do:
    %Determine how to implement the display function (which will likely be
    %renamed to prevent overloading). GUI class may be eliminated if
    %display turns out to be unnecessary.
    
    properties
    end
    
    methods %(Abstract)
        function guiobj = GUI()
        end
        
        fig = display(guiobj)
        
        
    end
    
end

