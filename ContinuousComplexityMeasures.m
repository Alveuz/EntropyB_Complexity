function [emergence, selfOrganization, complexity, varargout ] = ...
ContinuousComplexityMeasures(pdfSample, varargin )
    minVal  = varargin{1};
    maxVal  = varargin{2};
    distSampleSize = varargin{3};
    %Determine a integration interval Delta
    %Remember that by definition
    %for really small Deltas the entropy
    %is negative and can become -infinity
    Delta = (maxVal-minVal)/(distSampleSize);
    %Use the provided Probability Distribution Function     
    %to determine the non-zero elements of the PDF
    tempPdf = pdfSample;
    ind = tempPdf>0;
    pdfNoZeros = sum(ind);
    %Calculate Differential Entropy 
    %for the non-zero elements of the PDF
    rightHandSide = -1*log2(Delta);
    leftHandSide = (-1)*sum((Delta*tempPdf(ind)).*log2(tempPdf(ind)) );
    lmtEntrpy = rightHandSide + leftHandSide;
    diffEntrop = lmtEntrpy + log2(Delta);
    %K constant to be determined by 1) the number of no-zeros probability
    %elements, 2) a large value (i.e. the sample size)
    if(length(varargin)<4)
        if(distSampleSize < pdfNoZeros)
            kConst = 1/log2(pdfNoZeros);
        else
            kConst = 1/log2(distSampleSize);
        end
    else
        kConst = 1/log2(varargin{4});
    end
    modfDiffEntrop  = diffEntrop.*kConst;     
    if(modfDiffEntrop<0)
        emergence = 0;
        selfOrganization = 1;
        complexity = 0;
    else
        emergence = modfDiffEntrop;
        selfOrganization = 1 - emergence;
        complexity = 4 * (emergence * selfOrganization);
    end
    varargout{1} = diffEntrop;
end

