function wtd = rotor_root


wtd=which('setRotorToolBoxPath');
% The minus 2, i.e. -2, is to remove the ".m" of the which output
i=max(findstr(lower(wtd),'setrotortoolboxpath'))-2;
if i>0
  wtd=wtd(1:i);
else
  error('Cannot locate rotor_root.m. You must add the path to the Rotor Toolbox')
end