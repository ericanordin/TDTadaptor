function PlotLoop( samples )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
tic;
t = 0 ;
%x = 0 ;
xWidth = 10000 ; % lowering step has a number of cycles and then acquire more data
interv = size(samples) ; 
interv = interv(1) - xWidth;
step = 10 ; % lowering step has a number of cycles and then acquire more data
plot(samples);
while ( t <interv )
    %b = sin(t)+5;
    %b = getaudiodata(rec);
    
    %x = [ x, b ];
    %plot(x) ;
    plot(samples);
      if (t-xWidth < 0)
          startSpot = 0;
      else
          startSpot = t-xWidth;
      end
      axis([ startSpot, (t+xWidth), 0 , max(samples) ]);
      %grid
      t = t + step;
      drawnow;
      %pause(0.01)
end
totalTime = toc;
disp(totalTime);
end

