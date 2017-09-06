a = '';
totalForTime = 0;
totalObjectTime = 0;
disp('for-loop based');
for i = 1:3000
    tic;
    if i == 1
    else
    end
    totalForTime = totalForTime + toc;
end
disp(totalForTime);

disp('object based');
for j = 1:3000
    tic;
    if isobject(a)
    else
    end
    totalObjectTime = totalObjectTime + toc;
end
disp(totalObjectTime);