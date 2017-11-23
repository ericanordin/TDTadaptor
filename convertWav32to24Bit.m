%32-bit float WAVE files are converted into 24-bit float WAVE files

[fileName, filePath, ~] = uigetfile('*.wav', ...
    'Select 32-bit WAVE file');

fullPath = strcat(filePath, fileName);

[~, ~, ext] = fileparts(fullPath);

newPath = insertBefore(fullPath, ext, ' 24bit');

[data32, Fs] = audioread(fullPath);

data24 = data32/10;

audiowrite(newPath, data24, Fs, 'BitsPerSample', 24);

