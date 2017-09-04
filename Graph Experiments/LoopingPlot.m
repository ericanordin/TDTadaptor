figure(1);

for loop = 0:4
    y = rand(1,5);
    x = [0:4].*(loop+1);
    if loop == 0
        w = plot(x,y);
    else
        w.YData = y;
    end
    pause(0.5);
end