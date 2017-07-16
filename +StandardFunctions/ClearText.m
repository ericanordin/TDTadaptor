function ClearText(field, ~)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
disp('In ClearText');
set(field, 'Enable', 'on', 'Selected', 'on', 'String', '');
uicontrol(field);

end

