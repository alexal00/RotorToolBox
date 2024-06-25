function modstr = latexfmt(str)
% latexfmt change generic string with underscores to latex format
%
% Input:
%       * str : string to modify

pattern = '(\w+)_(\w+)';  % Pattern to match word characters separated by underscore
replaceStr = '$1_{$2}';    % Replacement pattern with curly brackets
modstr = regexprep(str, pattern, replaceStr);
modstr = ['$\', modstr,'$'];  % Add $ and \ before the xi
end