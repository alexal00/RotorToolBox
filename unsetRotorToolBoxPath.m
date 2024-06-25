function unsetRotorToolBoxPath
% unsetWTToolBoxPath removes WTTOOLBOX directories from MATLAB search path.
%

sd            = rotor_dirs;

for i=1:length(sd)
    rmpath(sd{i});
end



disp('RotorToolBox path has been removed from MATLAB path')