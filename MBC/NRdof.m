function qNR = NRdof(blades)
% NRdof Obtain the corresponding MBC depending on the number of blades
% Input:
%       * blades : Integer, number of blades of helicopter
% Output:
%       * qNR : Cell of strings containing the names of the different MBC or non-rotating degrees of freedom
syms xi_0

if mod(blades,2)==0
    xi_S = sym(['xi_' num2str(blades/2)]);
    xi_c = sym('xi_c',[blades/2-1 1]);
    xi_s = sym('xi_s',[blades/2-1 1]);
else
    xi_c = sym('xi_c',[(blades-1)/2 1]);
    xi_s = sym('xi_s',[(blades-1)/2 1]);
end

qNR_a = sym(zeros(blades,1));
qNR_a(1) = qNR_a(1)+xi_0;
aux = 2;
for ii=1:length(xi_c)
    qNR_a(aux) = xi_c(ii);
    qNR_a(aux+1) = xi_s(ii);
    aux = aux + 2;
end
if exist("xi_S","var")
    qNR_a(end) = xi_S(1);
end

latex_strings = cell(blades, 1);

for ii = 1:blades
    latex_strings = latex(qNR_a(ii));
    qNR{ii} = ['$' latex_strings '$'];
end

end