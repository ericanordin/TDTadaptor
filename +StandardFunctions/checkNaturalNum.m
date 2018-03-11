function numericContents = checkNaturalNum(entryField, errorColor)
%checkInteger Confirms that the string in entryField is a natural number (positive integer).
%   Checks that the contents of entryField are a non-decimal integer above
%   0 and converts the contents into an integer that is returned as
%   numericContents.

validNum = 0;

while validNum == 0    
    fieldContents = get(entryField, 'String');
    numericContents = str2double(fieldContents);
    if isempty(numericContents) %str2num returns an empty
        %array if the converted string is non-numeric.
        set(entryField, 'BackgroundColor',...
            errorColor);
        waitfor(entryField, 'String');
    else
        if floor(numericContents) ~= numericContents
            %Not an integer
            set(entryField, 'BackgroundColor',...
                errorColor);
            waitfor(entryField, 'String');
        else
            if numericContents < 1
                %Not a positive number
                set(entryField, 'BackgroundColor',...
                    errorColor);
                waitfor(entryField, 'String');
            else
                validNum = 1;
                set(entryField, 'BackgroundColor',...
                    'white');
            end
        end
    end
end

