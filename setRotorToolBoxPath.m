function setRotorToolBoxPath
% setWTToolBoxPath add WTToolBox directories to MATLAB search path.
%

% This is not the best place to do this task because this function is
% intendend to be a set path function and we are cluttering the
% functionality of the setWTToolBoxPath
disp('Default text interpreter is set to LaTeX')

sd            = rotor_dirs;

for i=1:length(sd)
    addpath(sd{i});
end

disp('RotorToolBox path has been added to MATLAB path')
disp('To startup: please type at MATLAB command window >> doc RotorToolBox')
disp('or go to MATLAB help (F1)->Supplemental Software->WTToolBox')