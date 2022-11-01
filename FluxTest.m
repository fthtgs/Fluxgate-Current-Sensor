clear all
a=serialport("COM3",9600);

figure(1)
plotTitle = 'Curent Value';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Current (A)';               % y-axis label
yLabel2 = 'Voltage (V)';
legend1 = 'Current';
legend2 = 'Voltage';

time = 0;
data = 0;
count = 0;

delay = 0.01;
yMax  = 8;                           %y Maximum Value
yMin  = 0;                       %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min
max_1 = 10;                        % set y-max


%Set up Plot 1

figure(1)
plotGraph1 = plot(time,data,'-b' );  
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1)
grid(plotGrid);

figure(2)
plotGraph2 = plot(time,data,'-b' );  
title('Voltage Value','FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel2,'FontSize',15);
legend(legend2)
grid(plotGrid);

pause(1);
tic
while ishandle(plotGraph1) %Loop when Plot is Active will run until plot is closed
         
         str = readline(a); %Data from the arduino
         dat =str2double(str);
         %dat = readVoltage(a,'A0');
         
         
         V_off = 0.11;
         m0 = 4*pi*10^-7;   %
         mr = 27;           %
         N = 15;            %
         d = 2*10^-3;       %
         S = 1.3;           %
         MPL = pi*(1.75-0.95)/log(17.5/9.5);    

         B = 0.4*pi*mr*N/(MPL+mr*d*10);  %G
         V = dat-V_off;                 %
         
         if V >= -0.05 && V <= 0.05
             V = 0;
         end
         
         
         I = (V*(9.63/213)*10^3)/(S*B);
                          
         count = count + 1;    
         time(count) = toc;    
         data(count) = I;
         data2(count) = V;

         
         set(plotGraph1,'XData',time,'YData',data);
         axis([0 time(count) data(count)-0.1 data(count)+0.1]);
         
         set(plotGraph2,'XData',time,'YData',data2);
         axis([0 time(count) data2(count)-0.1 data2(count)+0.1]);
         
                        
         pause(delay);
         
end
disp('Plot Closed');

