function charArray = padText(inputText)
%padText adds white spaces on either end of a string of text to centre display
%   Called whenever adding information to RecordScreen.statusWindow

statusWidth = 148; %Width of RecordScreen.statusWindow in characters

if ~isstring(inputText)
    inputText = string(inputText);
end

charArray = char(pad(inputText, statusWidth, 'both'));

end

