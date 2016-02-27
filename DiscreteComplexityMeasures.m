function [ emergence, selfOrganization, complexity, varargout ] = ...
    DiscreteComplexityMeasures( pmfSample, varargin )
    strSize     = length(pmfSample);
    if(~isempty(varargin))
        no_States   = varargin{1};
        margSttProb = (hist(pmfSample,no_States)./strSize)';
        %disp(['Marginal Probability Sum: ', num2str(sum(margSttProb))]);
        if(no_States == 1)
            kConst      = 1;
        else
            kConst      = 1/log2(no_States);
        end
    else
        sysStates   = unique(pmfSample);
        if(size(sysStates,2)>1)
            sysStates   = sysStates';
        end
        no_States   = length(sysStates);
        if(no_States == 1)
            kConst      = 1;
        else
            kConst      = 1/log2(no_States);
        end
        margSttProb     = zeros(length(sysStates), 1);
        for i=1:no_States
            margSttProb(i,1) = (nnz(ismember(pmfSample,sysStates(i) ) ) )/strSize;
        end
    end
    ind             = margSttProb> 0;
    entropy1        = sum(margSttProb(ind,1).*log2(margSttProb(ind,1)));
    emergence           = (-1)*kConst*entropy1;
    selfOrganization    = 1 - emergence;
    complexity          = 4 * emergence * selfOrganization;
    %bar([emergence; selfOrganization; complexity])
    varargout{1} = entropy1;
end

