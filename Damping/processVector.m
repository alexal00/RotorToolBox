%% Code start
% Author: Alejandro Alvaro, 2023-2024

function [posCount, negCount, processedVector, processedIndices] = processVector(v)
    % processVector processes a vector to count positive and negative elements,
    %               and extracts elements with the majority sign.
    %
    % SUMMARY:
    % This function counts the number of positive and negative elements in
    % the input vector v. It then determines the majority sign and extracts
    % elements with that sign into processedVector, along with their indices
    % in processedIndices.
    %
    % Inputs:
    %       * v : Input vector to process
    %
    % Outputs:
    %       *posCount : Count of positive elements
    %       *negCount : Count of negative elements
    %       *processedVector : Vector containing elements with the majority sign
    %       *processedIndices : Indices of elements with the majority sign in the original vector

    
    % Initialize counts and arrays
    posCount = 0;
    negCount = 0;
    processedVector = [];
    processedIndices = [];

    % Count positive and negative elements in v
    posCount = sum(v > 0);
    negCount = sum(v < 0);

    % Determine the majority sign
    if posCount > negCount
        majoritySign = 1;  % Majority sign is positive
    elseif negCount > posCount
        majoritySign = -1;  % Majority sign is negative
    else
        majoritySign = 1;  % If equal, assume positive majority
    end

    % Process vector to keep elements with the majority sign
    for i = 1:length(v)
        if sign(v(i)) == majoritySign
            processedVector = [processedVector, v(i)];
            processedIndices = [processedIndices, i];
        end
    end
end
