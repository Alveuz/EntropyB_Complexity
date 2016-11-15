<<<<<<< HEAD
clear;clc
format long;
path = 'C:\Users\Alveuz\Google Drive\Research And Development\UNAM PostDoc\Working Papers\ESC Matlab Functions for Frontiers\Data\Test RealWorld\Household Electric Consumption\DiffDataScales\';

%activePowerPath     = 'activePowerData.mat';
%load([path activePowerPath]);

activePowerPath     = 'activePowerData1.mat';
load([path activePowerPath]);

%Active Power: Global(:,3), Kitchen(:,4), Indoor Comfort(:,5)
%Active power is analyzed for several time scales: hours, days, weeks, 
% and months.

%Rows corresponds to Global, Kitchen, and Indoor Comfort
%Columns corresponds to Time Scales: hours, days, weeks, and months.

Emrgnc      = zeros(3,5);
SlfRgnztn   = zeros(3,5);
Cmplxty     = zeros(3,5);

noOfStates  = 10;%Number of states of the system

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

ESC = [Emrgnc(1:3,1), SlfRgnztn(1:3,1), Cmplxty(1:3,1)];

figure(1)
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h1 = bar3DPlot(ESC,1, typeLabel);
title("Household energy consumption", "fontsize", 30);

ESC_e = [Emrgnc(1:3,1), Emrgnc(1:3,2), Emrgnc(1:3,3), Emrgnc(1:3,4), ...
          Emrgnc(1:3,5)];
ESC_s = [SlfRgnztn(1:3,1), SlfRgnztn(1:3,2), SlfRgnztn(1:3,3), ...
          SlfRgnztn(1:3,4), SlfRgnztn(1:3,5)];
ESC_c = [Cmplxty(1:3,1), Cmplxty(1:3,2), Cmplxty(1:3,3), Cmplxty(1:3,4), ...
          Cmplxty(1:3,5)];

xLabels=['Minute';'Hour';'Day';'Week';'Month']; %Household electric consumption

%figure(4);
figure('Position',[200,200,1500,400]);
subplot(1,3,1);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h2 = bar3DPlot(ESC_e,0.6, typeLabel, xLabels);
title("Emergence", "fontsize", 30);

%figure(5);
subplot(1,3,2);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h3 = bar3DPlot(ESC_s,0.6, typeLabel, xLabels);
title("Self-organization", "fontsize", 30);

%figure(6);
subplot(1,3,3);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h4 = bar3DPlot(ESC_c,0.6, typeLabel, xLabels);
title("Complexity", "fontsize", 30);

=======
clear;clc
format long;
path = 'C:\Users\Alveuz\Documents\GitHub\EntropyB_Complexity\';

%activePowerPath     = 'activePowerData.mat';
%load([path activePowerPath]);

activePowerPath     = 'activePowerData.mat';
load([path activePowerPath]);

%Active Power: Global(:,3), Kitchen(:,4), Indoor Comfort(:,5)
%Active power is analyzed for several time scales: hours, days, weeks, 
% and months.

%Rows corresponds to Global, Kitchen, and Indoor Comfort
%Columns corresponds to Time Scales: hours, days, weeks, and months.

Emrgnc      = zeros(3,5);
SlfRgnztn   = zeros(3,5);
Cmplxty     = zeros(3,5);

noOfStates  = 10;%Number of states of the system

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

ESC = [Emrgnc(1:3,1), SlfRgnztn(1:3,1), Cmplxty(1:3,1)];

figure(1)
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h = bar3DPlot(ESC,1, typeLabel);

ESC_e = [Emrgnc(1:3,1), Emrgnc(1:3,2), Emrgnc(1:3,3), Emrgnc(1:3,4), ...
          Emrgnc(1:3,5)];
ESC_s = [SlfRgnztn(1:3,1), SlfRgnztn(1:3,2), SlfRgnztn(1:3,3), ...
          SlfRgnztn(1:3,4), SlfRgnztn(1:3,5)];
ESC_c = [Cmplxty(1:3,1), Cmplxty(1:3,2), Cmplxty(1:3,3), Cmplxty(1:3,4), ...
          Cmplxty(1:3,5)];

xLabels=['Minute';'Hour';'Day';'Week';'Month']; %Household electric consumption

figure(4);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h = bar3DPlot(ESC_e,0.6, typeLabel, xLabels);

figure(5);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h = bar3DPlot(ESC_s,0.6, typeLabel, xLabels);

figure(6);
typeLabel=['Global KW/m';'Kitchen W/h';'Comfort W/h']; %Household electric consumption
h = bar3DPlot(ESC_c,0.6, typeLabel, xLabels);

>>>>>>> origin/master
disp('Bye Cruel World!!!')