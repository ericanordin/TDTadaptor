function checkOverwrite(filePath, displayField, errorColor)
%checkOverwrite checks whether a file with the same name and location
%exists.
%   The displayField is coloured red if recording will overwrite an
%   existing file.
%Also colours red if the file name does not end in .wav

if exist(filePath, 'file') == 2
    %Prevent overwrite
    set(displayField, 'BackgroundColor', errorColor);
else
    fileDesignation = filePath(end-3:end);
    if fileDesignation ~= '.wav'
        set(displayField, 'BackgroundColor', errorColor);
    else
        set(displayField, 'BackgroundColor', 'white');
    end
end

end

