clear;clc
format long;
filePath = 'C:\Users\Alveuz\Documents\GitHub\EntropyB_Complexity\Data\';

SolarFlaresData         = 'SolarFlaresData.mat';
BikeSharingData         = 'BikeSharingData.mat';
HouseElecCnsmptData     = 'HouseHoldElectricConsumption.mat';
% Load datasets containing UCI's data sets
% In this example SolarFlares and Household electric consumption are
% matrix while Bike sharing data for hour and day are two separated vectors
% for convinience.

complexityType = 1; %Discrete complexity measures
% complexityType = 2; %Continuous complexity measures

switch complexityType
    case 1
%        dataSet = 1; load([filePath SolarFlaresData]);%Flares, contains 
%        dataSet = 2; load([filePath BikeSharingData]);%Bike Sharing
        dataSet = 3; load([filePath HouseElecCnsmptData]);%Household electric consumption
        noOfStates  = 10;%Number of states of the system
        switch dataSet
            case 1
                Emrgnc      = zeros(3,1);
                SlfRgnztn   = zeros(3,1);
                Cmplxty     = zeros(3,1);
                %SolarFlares(:,1) contains C-Class, (:,2) M-Class, (:,3)
                %X-Class
                for i=1:3
                    pmfSample   = SolarFlares(:,i);
                    [Emrgnc(i,1), SlfRgnztn(i,1), Cmplxty(i,1)] = ...
                        DiscreteComplexityMeasures(pmfSample, noOfStates);
                end
            case 2
                Emrgnc      = zeros(2,1);
                SlfRgnztn   = zeros(2,1);
                Cmplxty     = zeros(2,1);
                %BikeSDDay(:,1) contains a counter of Bikes used per Day, 
                %BikeSDHour(:,1) contains a counter of Bikes used per Hour
                for i=1:2
                    switch i
                        case 1
                            pmfSample   = BikeSDDay(:,1);
                        case 2
                            pmfSample   = BikeSDHour(:,1);
                    end
                    [Emrgnc(i,1), SlfRgnztn(i,1), Cmplxty(i,1)] = ...
                        DiscreteComplexityMeasures(pmfSample, noOfStates);
                end
            case 3
                Emrgnc      = zeros(2,1);
                SlfRgnztn   = zeros(2,1);
                Cmplxty     = zeros(2,1);
                %Household electric consumption(:,1) contains Global house
                %consumption, (:,2) Kitchen consumption
                for i=1:2
                    pmfSample   = HouseholdPowerConsumption(:,i);
                    [Emrgnc(i,1), SlfRgnztn(i,1), Cmplxty(i,1)] = ...
                        DiscreteComplexityMeasures(pmfSample, noOfStates);
                end
        end
    case 2
        %% Continuous Complexity Measures
        % This is an example on how to use the continuous complexity
        % measures. In this, two probability density functions are
        % employed: Gaussian and Power-Law
        % Define the experimantal Setup MetaParameters
        distSampleSize  = 100000;
        distParamNum    = 10;
        %Probability Function
        % 1 = Gaussian Distribution
        % 2 = Power Law Distribution
        pdfType     = 2;
        %Want to produce plots for distributions?
%       plotPDFOn   = 0;%Definetively NO
        plotPDFOn   = 1; %Yes, it would be amazing!
        noOfStates  = 50;
        %% Create Probability Distribution Parameter Sequence
        switch pdfType
            case 1
                % Normal Distribution
                % Two Parameters, Mean (mu) and Standard Deviation (sigma)
                % Since differential entropy is translate invariant, the
                % mu parameter is dropped out of the calculations.
                paramSeq        = 1:distParamNum; 
                % Create discrete integration sequence
                maxVal  = 100;
                minVal  = 0; 
                dtSeq   = linspace (minVal, maxVal, distSampleSize); 
                % Define Mean of the Normal Distribution(i.e. Mu=0)
                mu      = (maxVal - minVal)/2;
                %Delta increment for discrete Integration
                Delta   = (maxVal-minVal)/(distSampleSize);
                for i=1:distParamNum
                    % Define Sigma of the Normal Distribution
                    sigma   = paramSeq(1,i);
                    % Create the Normal PDF
                    gaussDist   = normpdf(dtSeq,mu,sigma);
                    switch plotPDFOn
                        case 1
                            figure(2);
                            plot(dtSeq, gaussDist, 'linewidth', i); 
                            hold on;
                        otherwise
                    end
                    % Temporarely save the distribution
                    pdfMatrix(:, i) = gaussDist(1,:);
                    % Calculate Differential Complexity Measures
                    [Emrgnc(i,1), SlfRgnztn(i,1), Cmplxty(i,1)] = ...
                        ContinuousComplexityMeasures(gaussDist,...
                        minVal, maxVal, distSampleSize,noOfStates);
                end
            case 2
                % Power-Law Distribution
                % Two Parameters, xmin and scale exponent (alpha)
                % In this example, alpha is fixed, while x_min is tested.
                alpha           = 5;
%                xmin            = 3;
                paramSeqXmin    = 1:distParamNum;
%                paramSeqScale   = 2:distParamNum+1;
                % Create discrete integration sequence
                maxVal      = 100;
                for i=1:distParamNum
                    % Define the Power-Law Density Distribution Function
                    xmin        = paramSeqXmin(i);
%                    alpha       = paramSeqScale(i);
                    dtSeq       = linspace (xmin, maxVal, distSampleSize);
                    % Create the Power-Law PDF
                    rightHand   = ((alpha-1)/xmin);
                    leftHand    = (dtSeq(:)./xmin).^(-1*alpha);
                    pLawDist    = rightHand*leftHand;
                    switch plotPDFOn
                        case 1
                            figure(2);
                            plot(pLawDist,'r', 'linewidth', (.1*(i-1)+1 ));
                            hold on;
                    end
                    [Emrgnc(i,1), SlfRgnztn(i,1), Cmplxty(i,1)] = ...
                        ContinuousComplexityMeasures(pLawDist,...
                        xmin, maxVal, distSampleSize,noOfStates);
                end
        end
end
ESC = [Emrgnc, SlfRgnztn, Cmplxty];
qq = figure(3);

% Discrete examples labels
% typeLabel=['C-Class';'M-Class';'X-Class']; %Flares
% typeLabel=['Bikes p/H';'Bikes p/D']; %Bike Sharing
typeLabel=['Global KW/m';'Kitchen W/h']; %Household electric consumption

% typeLabel=char('1','2','3','4','5','6','7','8','9','10'); %Gaussian Distribution
% typeLabel=char('1','2','3','4','5','6','7','8','9','10'); %Power Law Distribution
% typeLabel=char('2','3','4','5','6','7','8','9','10', '11'); %Power Law Distribution

h = bar3DPlot(ESC,0.7, typeLabel);

%title('Solar Flares Data', 'fontsize', 30);
%title('Bike Sharing Data', 'fontsize', 30);
title('Household Electric Consumption', 'fontsize', 30);

% title('Gaussian Distribution', 'fontsize', 30);
% title('Power Law Distribution', 'fontsize', 30);
% ylabel(sprintf('\\alpha \n (scale exponent)'), 'fontsize', 20);
% ylabel(sprintf('x_{min}'), 'fontsize', 20);
% ylabel(sprintf('\\sigma \n Std. Dev.'), 'fontsize', 20);



disp('Bye Cruel World!!!')

