function [ emergence, selfOrganization, complexity, varargout ] = ...
    DiscreteComplexityMeasures( pmfSample, varargin )
    
    %This function calculates Discrete Complexity Measures for discrete samples.
    %First, we get the number of observations contained in the sample.
    measLen     = length(pmfSample);
    %If the number of states of the PMF
    %is known beforehand
    if(~isempty(varargin))
        %Calculate the marginal states probability
        no_States   = varargin{1};
        margSttProb = (hist(pmfSample,no_States)./measLen)';
        
    else %Use an heuristic to obtain the PMF
        %Obtain the system's unique states. 
        sysStates   = unique(pmfSample);
        if(size(sysStates,2)>1)
            sysStates   = sysStates';
        end
        %Get the length of the unique states.
        %And calculate the marginal states probability
        no_States   = length(sysStates);
        margSttProb = zeros(length(sysStates), 1);
        for i=1:no_States
            margSttProb(i,1) = (nnz(ismember(pmfSample,sysStates(i) ) ) )/measLen;
        end
    end
    %Define the normalizing constant k
    if(no_States == 1) %If it is a trivial system.
        kConst      = 1;
    else
        kConst      = 1/log2(no_States);
    end
    
    %Then, calculate entropy for all elements 
    %of the PMF with p(x)>0
    ind             = margSttProb> 0;
    entropy1        = sum(margSttProb(ind,1).*log2(margSttProb(ind,1)));
    %Calculate ESC measures
    emergence           = (-1)*kConst*entropy1;
    selfOrganization    = 1 - emergence;
    complexity          = 4 * emergence * selfOrganization;
    varargout{1}        = entropy1;
end

