function T = rotmat(blades,psi)
% rotmat Obtain the rotation matrix for the MBC transformation
%        As described in Coleman [1943]: qR = T*qNR
% Input:
%       * blades: Number of blades, Integer
%       * psi: Vector or azimutal position of each blade, [blades x 1]
% Output:
%       * T : MBC transfomation matrix

T = zeros(blades);
if mod(blades,2)==0
    dof_col = 2;
else
    dof_col = 1;
end
dof_cyc = (blades-dof_col)/2;

T(:,1) = 1;
for ii = 1:blades
    % psi(ii) = sym('psi_1')+(ii-1)*deltapsi;
    aux = 2;
    for jj=1:dof_cyc
        T(ii,aux) = cos((jj)*psi(ii));
        T(ii,aux+1) = sin((jj)*psi(ii));
        aux = aux+2;
    end

    if dof_col==2
        T(ii,end) = (-1)^ii;
    end
end
% disp(T)
end