function numericContents = checkInteger(entryField)
%checkInteger Confirms that the string in entryField is an integer.
%   Checks that the contents of entryField are a non-decimal integer and
%   converts the contents into an integer that is returned as
%   numericContents.
validNum = 0;
while validNum == 0
    
    fieldContents = get(entryField, 'String');
    numericContents = str2num(fieldContents);
    if isempty(numericContents) %str2num returns an empty
        %array if the converted string is non-numeric.
        %disp('Not a number');
        set(entryField, 'BackgroundColor',...
            [1 0.1 0.1]);
        waitfor(entryField, 'String');
    else
        if floor(numericContents) ~= numericContents
            %disp('Not an integer');
            set(entryField, 'BackgroundColor',...
                [1 0.1 0.1]);
            waitfor(entryField, 'String');
        else
            validNum = 1;
            set(entryField, 'BackgroundColor',...
                'white');
        end
        
    end
end



end

