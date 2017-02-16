clear;clc
format long;
path = 'C:\Users\Alveuz\Documents\GitHub\EntropyB_Complexity\Data\';

%Load active power data for the Household electric consumption dataset.
activePowerPath     = 'activePowerData.mat';
load([path activePowerPath]);

%%Active power is analyzed for several time scales:minute, hour, day, 
%week and month active power for the Global, Kitchen, and Indoor Comfort.
%For the hours, days, weeks and months the first two columns contains IDs
%and dates, respectively. Thus, Global(:,3), Kitchen(:,4), Indoor Comfort(:,5)
%For the minutes matrix, columns corresponding to ids and dates were removed.

Emrgnc      = zeros(3,5);
SlfRgnztn   = zeros(3,5);
Cmplxty     = zeros(3,5);

noOfStates  = 10;%Number of states of the system

%For each dataset, we calculate E, S and C.
for i=1:5
  
  switch i %columns
      case 1  %Minute
        tempData    = activePowerMinute;
      case 2  %Hour
        tempData    = activePowerHour;
      case 3  %Day
        tempData    = activePowerDay;
      case 4  %Week
        tempData    = activePowerWeek;
      case 5  %Month
        tempData    = activePowerMonth;
  end
  if(i==1)
    for j=1:3 % rows
      switch j
          case 1  %Global
            pmfSample   = cell2mat(tempData(1:end,1));
          case 2  %Kitchen
            pmfSample   = cell2mat(tempData(1:end,2));
          case 3  %Indoor Comfort
            pmfSample   = cell2mat(tempData(1:end,3));
       end
       
       [Emrgnc(j,i), SlfRgnztn(j,i), Cmplxty(j,i)] = ...
          DiscreteComplexityMeasures(pmfSample, noOfStates);
       
    end
  else
    for j=1:3 % rows
      switch j
          case 1  %Global
            pmfSample   = cell2mat(tempData(1:end,3));
          case 2  %Kitchen
            pmfSample   = cell2mat(tempData(1:end,4));
          case 3  %Indoor Comfort
            pmfSample   = cell2mat(tempData(1:end,5));
       end
       
       [Emrgnc(j,i), SlfRgnztn(j,i), Cmplxty(j,i)] = ...
          DiscreteComplexityMeasures(pmfSample, noOfStates);
       
    end
  end
end

%Now we plot the results.
ESC = [Emrgnc(1:3,1), SlfRgnztn(1:3,1), Cmplxty(1:3,1)];

figure(1)
typeLabel=char('Global KW/m','Kitchen W/h','Comfort W/h'); %Household electric consumption
h1 = bar3DPlot(ESC,1, typeLabel);
title('Household energy consumption', 'fontsize', 30);

ESC_e = [Emrgnc(1:3,1), Emrgnc(1:3,2), Emrgnc(1:3,3), Emrgnc(1:3,4), ...
          Emrgnc(1:3,5)];
ESC_s = [SlfRgnztn(1:3,1), SlfRgnztn(1:3,2), SlfRgnztn(1:3,3), ...
          SlfRgnztn(1:3,4), SlfRgnztn(1:3,5)];
ESC_c = [Cmplxty(1:3,1), Cmplxty(1:3,2), Cmplxty(1:3,3), Cmplxty(1:3,4), ...
          Cmplxty(1:3,5)];

xLabels=char('Minute','Hour','Day','Week','Month'); %Household electric consumption

%figure(4);
figure('Position',[200,200,1500,400]);
subplot(2,4,1:2);
typeLabel=char('Global KW/m','Kitchen W/h','Comfort W/h'); %Household electric consumption
h2 = bar3DPlot(ESC_e,0.6, typeLabel, xLabels);
title('Emergence', 'fontsize', 30);

%figure(5);
subplot(2,4,5:6);
typeLabel=char('Global KW/m','Kitchen W/h','Comfort W/h'); %Household electric consumption
h3 = bar3DPlot(ESC_s,0.6, typeLabel, xLabels);
title('Self-organization', 'fontsize', 30);

%figure(6);
subplot(2,4,[3 4 7 8]);
typeLabel=char('Global KW/m','Kitchen W/h','Comfort W/h'); %Household electric consumption
h4 = bar3DPlot(ESC_c,0.6, typeLabel, xLabels);
title('Complexity', 'fontsize', 30);

disp('Bye Cruel World!!!')