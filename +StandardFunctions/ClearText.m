function ClearText(field, ~)
%CLEARTEXT Erases the text in a uicontrol edit field and selects the field
%for data entry.

%disp('In ClearText');
set(field, 'Enable', 'on', 'Selected', 'on', 'String', '');
uicontrol(field);

end

