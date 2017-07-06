classdef (Abstract) GUI
    %GUI Defines an abstract superclass for the various GUI components of the program.    
    
    properties
    end
    
    methods %(Abstract)
        function guiobj = GUI()
        end
        
        display(guiobj)
    end
    
end

